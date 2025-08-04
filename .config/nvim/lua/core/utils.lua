local M = {}


function M.search()
	local search = vim.fn.input("Search for: ")
	-- Escape special shell characters for safe execution
	local escaped_input = search:gsub("'", [["]])

	-- Use ripgrep to search string content in files
	local cmd = "rg --vimgrep --smart-case '" .. escaped_input .. "'"
	local results = vim.fn.systemlist(cmd)

	if vim.v.shell_error ~= 0 then
		vim.notify("No matches found for '" .. input .. "'", vim.log.levels.WARN)
		return
	end

	vim.fn.setqflist({}, ' ', {
		title = 'Search Results',
		lines = results,
	})
	vim.cmd("copen")
end

function M.search_and_replace()
	local search = vim.fn.input("Search for: ")
	if search == "" then
		vim.notify("Nothing to search...", vim.log.levels.INFO)
		return
	end
	local replace = vim.fn.input("Replace with: ")
	local cmd = string.format('args `rg --files-with-matches "%s"` | argdo %%s/%s/%s/ge | update', search, search,
		replace)
	vim.cmd(cmd)
end

function M.buffers_to_quickfix()
	local buffers = vim.api.nvim_list_bufs() -- Get all buffers
	local quickfix_list = {}

	for _, buf in ipairs(buffers) do
		if vim.api.nvim_buf_is_loaded(buf) then
			local name = vim.api.nvim_buf_get_name(buf)
			if name ~= "" then -- Ignore unnamed buffers
				table.insert(quickfix_list, {
					filename = name,
					lnum = 1, -- Line number (default to 1)
					col = 1, -- Column number (default to 1)
					text = "Buffer: " .. name,
				})
			end
		end
	end

	if #quickfix_list == 0 then
		print("No active buffers to list.")
		return
	end

	-- Set the quickfix list
	vim.fn.setqflist(quickfix_list, 'r')
	vim.cmd("copen") -- Open the quickfix list window
	print("Buffers added to quickfix list.")
end

function M.file_picker()
	vim.ui.input({ prompt = "Search filenames > " }, function(input)
		if not input or input == "" then return end

		local cmd = { "rg", "--files" }

		vim.fn.setqflist({}, "r")

		vim.fn.jobstart(cmd, {
			cwd = vim.fn.getcwd(),
			stdout_buffered = true,
			on_stdout = function(_, data)
				if not data then return end

				local matches = {}
				for _, filepath in ipairs(data) do
					if filepath ~= "" and filepath:lower():find(input:lower(), 1, true) then
						table.insert(matches, {
							filename = filepath,
							lnum = 1,
							col = 1,
							text = filepath,
						})
					end
				end

				if #matches > 0 then
					vim.fn.setqflist(matches, "r")
					vim.cmd("copen")
				else
					vim.notify("No matching files for: " .. input, vim.log.levels.INFO)
				end
			end,

		})
	end)
end

function M.open_daily_note()
	local notes_dir = vim.fn.expand("~/Notes/Journal") -- Change this to your Notes directory
	local date = os.date("%y-%m-%d")
	local filepath = notes_dir .. "/" .. date .. ".md"
	local timestamp = "## " .. os.date("%H:%M:%S")
	local datestamp = "# " .. date

	vim.cmd("edit " .. filepath)
	if vim.fn.filereadable(filepath) == 0 then
		vim.api.nvim_put({ datestamp, timestamp }, "l", true, true)
	else
		vim.cmd("normal G")
		vim.api.nvim_put({ timestamp }, "l", true, true)
		vim.cmd("normal G")
	end
end

return M
