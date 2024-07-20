local function winbar_exec()
	---format buffer list
	---@return string
	local function format_buffer_list()
		local filenames = {}
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			-- Check if the buffer is associated with a file
			if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, 'buftype') == '' then
				local name = vim.fn.bufname(buf)
				-- Extract the filename from the full path
				local filename = vim.fn.fnamemodify(name, ':t')
				table.insert(filenames, filename)
			end
		end
		return string.format(" [ %s ] ", table.concat(filenames, ' | '))
	end
	local winbar = {
		"%#Normal#",
		format_buffer_list()
	}

	vim.o.winbar = table.concat(winbar, '')
end


vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		winbar_exec()
	end
})
