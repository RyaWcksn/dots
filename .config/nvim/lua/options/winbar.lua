local function winbar_exec()
	--- Format buffer list with highlight on current buffer
	---@return string
	local function format_buffer_list()
		local filenames = {}
		local current_buf = vim.api.nvim_get_current_buf()

		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(buf)
			    and vim.api.nvim_buf_get_option(buf, 'buftype') == ''
			    and vim.api.nvim_buf_get_option(buf, 'filetype') ~= 'netrw' then
				local name = vim.fn.bufname(buf)
				local filename = vim.fn.fnamemodify(name, ':t')

				-- Highlight the currently open buffer
				if buf == current_buf then
					table.insert(filenames, "%#IncSearch#" .. filename .. "%#Normal#")
				else
					table.insert(filenames, filename)
				end
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
