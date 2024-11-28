local M = {}

local curl = require("plenary.curl")
local json = vim.fn.json_decode
local uv = vim.loop

-- Cache prayer times and location
local prayer_times = {}
local current_city = {}

-- Helper to get home directory
local function get_home_dir()
	return uv.os_homedir()
end

-- Function to check or fetch prayer schedule
function M.check_or_fetch_schedule()
	vim.notify("Checking or fetching prayer schedule...", vim.log.levels.INFO)
	local home_dir = get_home_dir()
	local current_date = os.date("%Y-%m")
	local schedule_file = string.format("%s/jadwal-%s.json", home_dir, current_date)

	-- Check if schedule file exists
	local fd = uv.fs_open(schedule_file, "r", 438)
	if fd then
		local stat = uv.fs_fstat(fd)
		local data = uv.fs_read(fd, stat.size, 0)
		uv.fs_close(fd)
		if data then
			prayer_times = json(data)
			vim.notify("Prayer schedule loaded from file.", vim.log.levels.INFO)
			return
		end
	end

	-- Detect city and fetch schedule if file doesn't exist or is outdated
	M.get_city_from_network(function(city_id)
		if not city_id then
			vim.notify("Unable to determine city ID. Fetch failed.", vim.log.levels.ERROR)
			return
		end
		M.fetch_prayer_times(city_id, os.date("%Y"), os.date("%m"), function(schedule)
			local fd = uv.fs_open(schedule_file, "w", 438)
			if fd then
				uv.fs_write(fd, vim.fn.json_encode(schedule), 0)
				uv.fs_close(fd)
				vim.notify("Prayer schedule saved to file.", vim.log.levels.INFO)
			else
				print("Failed to write schedule to file.")
				vim.notify("Failed to write schedule to file.", vim.log.levels.ERROR)
			end
		end)
	end)
end

-- Function to detect city from network and get city ID
function M.get_city_from_network(callback)
	local url = "https://ipinfo.io/json"
	local response = curl.get(url, {
		headers = {
			["Content-Type"] = "application/json",
		},
	})

	if response.status == 200 then
		local data = json(response.body)
		if data and data.city then
			local city_search_url = "https://api.myquran.com/v2/sholat/kota/cari/" .. data.city
			local search_response = curl.get(city_search_url, {
				headers = {
					["Content-Type"] = "application/json",
				},
			})

			if search_response.status == 200 then
				local search_data = json(search_response.body)
				if search_data and search_data.data and #search_data.data > 0 then
					local city_id = search_data.data[1].id -- Assuming the first result is correct
					current_city = {
						lokasi = search_data.data[1].lokasi,
						id = city_id,
					}
					print("Detected city: " .. current_city.lokasi .. " with ID " .. city_id)
					callback(city_id)
					return
				end
			end
		end
	end

	print("Failed to detect city from network.")
	callback(nil)
end

-- Function to fetch prayer times for the month
function M.fetch_prayer_times(city_id, year, month, callback)
	local url = string.format("https://api.myquran.com/v2/sholat/jadwal/%s/%s/%s", city_id, year, month)

	local response = curl.get(url, {
		headers = {
			["Content-Type"] = "application/json",
		},
	})

	if response.status == 200 then
		local data = json(response.body)
		if data and data.data and data.data.jadwal then
			prayer_times = data.data.jadwal or {}
			print("Prayer times fetched successfully for city ID " .. city_id)
			if callback then
				callback(prayer_times)
			end
		else
			print("Failed to parse prayer times.")
			if callback then
				callback(nil)
			end
		end
	else
		print("Failed to fetch prayer times. HTTP Status: " .. response.status)
		if callback then
			callback(nil)
		end
	end
end

-- Function to calculate next prayer time
function M.get_next_prayer_time()
	local now = os.time()
	local today = os.date("*t")
	local prayers = nil

	for _, day in ipairs(prayer_times) do
		if day.date == string.format("%04d-%02d-%02d", today.year, today.month, today.day) then
			prayers = day
			break
		end
	end

	if not prayers then
		vim.notify("No prayer times available for today.")
		return nil
	end

	for _, prayer in pairs({ "subuh", "dzuhur", "ashar", "maghrib", "isya" }) do
		local prayer_time = prayers[prayer]
		if prayer_time then
			local prayer_hour, prayer_minute = prayer_time:match("(%d+):(%d+)")
			local prayer_timestamp = os.time({
				year = today.year,
				month = today.month,
				day = today.day,
				hour = tonumber(prayer_hour),
				min = tonumber(prayer_minute),
				sec = 0,
			})

			if now < prayer_timestamp then
				vim.notify("Next prayer is " .. prayer .. " at " .. prayer_time, vim.log.levels.INFO)
				return { prayer = prayer, time = prayer_time }
			end
		end
	end

	vim.notify("No more prayers left for today.", vim.log.levels.INFO)
	return nil
end

-- Function to check current prayer time
function M.get_current_prayer_time()
	local now = os.time()
	local today = os.date("*t")
	local prayers = nil

	for _, day in ipairs(prayer_times) do
		if day.date == string.format("%04d-%02d-%02d", today.year, today.month, today.day) then
			prayers = day
			break
		end
	end

	if not prayers then
		print("No prayer times available for today.")
		return nil
	end

	for _, prayer in pairs({ "subuh", "dzuhur", "ashar", "maghrib", "isya" }) do
		local prayer_time = prayers[prayer]
		if prayer_time then
			local prayer_hour, prayer_minute = prayer_time:match("(%d+):(%d+)")
			local prayer_timestamp = os.time({
				year = today.year,
				month = today.month,
				day = today.day,
				hour = tonumber(prayer_hour),
				min = tonumber(prayer_minute),
				sec = 0,
			})

			if now >= prayer_timestamp and now < (prayer_timestamp + 900) then -- 15-minute window
				vim.notify("It is currently time for " .. prayer .. " prayer!", vim.log.levels.INFO)
				return prayer
			end
		end
	end

	return nil
end

-- -- Command to fetch or check schedule
-- vim.api.nvim_create_user_command("CheckOrFetchSchedule", function()
-- end, {})

M.check_or_fetch_schedule()

-- Command to get next prayer time
vim.api.nvim_create_user_command("NextPrayerTime", function()
	M.get_next_prayer_time()
end, {})

-- Command to get current prayer time
vim.api.nvim_create_user_command("CurrentPrayerTime", function()
	M.get_current_prayer_time()
end, {})

-- Auto notify if it's time for prayer every minute
local function auto_notify()
	vim.defer_fn(function()
		if M.get_current_prayer_time() then
			vim.notify("It's time to pray!", vim.log.levels.INFO, {})
		end
		auto_notify()
	end, 60000) -- Check every 60 seconds
end

auto_notify()

return M
