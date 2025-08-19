local M = {}


function M.open_file_tree()
	vim.api.nvim_command('topleft vsplit')
	vim.api.nvim_win_set_width(0, 30)
	vim.cmd.edit('.')
end

function M.git_blame_current_line()
	-- Determine visual or normal mode range
	local mode = vim.fn.mode()
	local start_line, end_line

	if mode == 'v' or mode == 'V' then
		-- Visual mode: get selected line range
		start_line = vim.fn.line("v")
		end_line = vim.fn.line(".")
		if start_line > end_line then
			start_line, end_line = end_line, start_line
		end
		-- Exit visual mode
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
	else
		-- Normal mode: just the current line
		start_line = vim.fn.line(".")
		end_line = start_line
	end

	local filepath = vim.fn.expand('%:p')
	local cmd = { 'git', 'blame', '--line-porcelain', '-L', start_line .. ',' .. end_line, filepath }

	local handle = io.popen(table.concat(cmd, ' '))
	if not handle then
		vim.notify("Failed to run git blame", vim.log.levels.ERROR)
		return
	end

	local output = handle:read("*a")
	handle:close()

	local messages = {}
	local current_author, current_summary
	local uncommitted_sha = "0000000000000000000000000000000000000000"

	for line in output:gmatch("[^\r\n]+") do
		if line:match("^" .. uncommitted_sha) then
			table.insert(messages, "Not committed")
		elseif line:match("^author ") then
			current_author = line:match("^author (.+)")
		elseif line:match("^summary ") then
			current_summary = line:match("^summary (.+)")
			if current_author and current_summary then
				table.insert(messages, current_author .. ": " .. current_summary)
				current_author, current_summary = nil, nil
			end
		end
	end

	if #messages == 0 then
		vim.notify("No blame info found", vim.log.levels.WARN)
	else
		vim.notify(table.concat(messages, "\n"), vim.log.levels.INFO, { title = "Git Blame" })
	end
end

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
					vim.api.nvim_create_autocmd("BufEnter", {
						pattern = "*",
						once = true,
						callback = function()
							-- Check if quickfix window is open, then close it
							for _, win in ipairs(vim.api.nvim_list_wins()) do
								if vim.fn.getwininfo(win)[1].quickfix == 1 then
									vim.api.nvim_win_close(win, false)
								end
							end
						end,
					})
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
