local function mode()
	return ' 有 '
end

local function filepath()
	local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
	if fpath == "" or fpath == "." then
		return " "
	end

	return string.format(" %%<%s/", fpath)
end

local function filename()
	local fname = vim.fn.expand "%:t"
	if fname == "" then
		return ""
	end
	if vim.api.nvim_buf_get_option(0, 'modified') == 1 then
		fname = fname .. "*"
	end
	return fname .. " "
end


local function lsp()
	local count = {}
	local levels = {
		errors = "Error",
		warnings = "Warn",
		info = "Info",
		hints = "Hint",
	}

	for k, level in pairs(levels) do
		count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
	end

	local errors = ""
	local warnings = ""
	local hints = ""
	local info = ""

	if count["errors"] ~= 0 then
		errors = " %#Normal#ERR " .. count["errors"]
	end
	if count["warnings"] ~= 0 then
		warnings = " %#Normal#WARN " .. count["warnings"]
	end
	if count["hints"] ~= 0 then
		hints = " %#Normal#HINT " .. count["hints"]
	end
	if count["info"] ~= 0 then
		info = " %#Normal#INFO " .. count["info"]
	end


	return errors .. warnings .. hints .. info .. "%#Normal# "
end

local function lsp_servers()
	local msg = 'No Active Lsp'
	local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
	local clients = vim.lsp.get_active_clients()
	local names = {}
	for _, client in ipairs(clients) do
		local filetypes = client.config.filetypes
		if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
			table.insert(names, client.name)
		end
	end
	if #names == 0 then
		return msg
	else
		return string.format(" LSP [ %s ]", table.concat(names, ', '))
	end
end

local function get_git_branch()
	local handle = io.popen('git rev-parse --abbrev-ref HEAD 2>/dev/null')
	local result = handle:read('*l')
	handle:close()
	result = string.format(" [%s] ", result)
	return result or '!git'
end

local function get_project_name()
	-- Get the current working directory (CWD)
	local cwd = vim.fn.getcwd()
	-- Extract the last part of the path (the project name)
	return vim.fn.fnamemodify(cwd, ":t")
end

local function statusbar_exec()
	local statusline = {
		"%#Normal#",
		mode(),
		get_git_branch(),
		filepath() .. filename() .. "%r",
		"%=%#Extra#",
		"%#Normal#",
		lsp_servers(),
		lsp(),
		get_project_name(),
	}
	vim.o.statusline = table.concat(statusline, '')
end

vim.api.nvim_create_autocmd({ "DiagnosticChanged", "VimEnter", "BufWinEnter" }, {
	callback = function()
		statusbar_exec()
	end
})
