local augroup = vim.api.nvim_create_augroup('user_cmds', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'help', 'man', 'qf' },
	group = augroup,
	desc = 'Use q to close the window',
	command = 'nnoremap <buffer> q <cmd>quit<cr>'
})
vim.api.nvim_create_autocmd('TextYankPost', {
	group = augroup,
	desc = 'Highlight on yank',
	callback = function(event)
		vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
	end
})


vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.md",
    callback = function()
        local buf = vim.api.nvim_get_current_buf()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local formatted = {}

        -- Check if there's a table in the file
        local in_table = false
        for _, line in ipairs(lines) do
            if line:match("|") then
                in_table = true
                break
            end
        end

        if not in_table then return end -- No tables, skip formatting

        -- Use Prettier if available, fallback to basic formatting
        local prettier_cmd = "prettier --parser markdown"
        local handle = io.popen(prettier_cmd .. " 2>/dev/null")
        if handle and handle:read("*a") ~= "" then
            vim.cmd("%!prettier --parser markdown")
        else
            -- Basic fallback formatting (adjust column widths)
            local function split(str, sep)
                local result = {}
                for part in str:gmatch("[^" .. sep .. "]+") do
                    table.insert(result, part:match("^%s*(.-)%s*$")) -- Trim spaces
                end
                return result
            end

            local tables = {}
            local current_table = {}
            local max_col_widths = {}

            for _, line in ipairs(lines) do
                if line:match("|") then
                    local cols = split(line, "|")
                    table.insert(current_table, cols)
                    for i, col in ipairs(cols) do
                        max_col_widths[i] = math.max(max_col_widths[i] or 0, #col)
                    end
                elseif #current_table > 0 then
                    table.insert(tables, current_table)
                    current_table = {}
                end
            end
            if #current_table > 0 then
                table.insert(tables, current_table)
            end

            for _, table_data in ipairs(tables) do
                for i, row in ipairs(table_data) do
                    local formatted_row = "|"
                    for j, col in ipairs(row) do
                        formatted_row = formatted_row .. " " .. col .. string.rep(" ", max_col_widths[j] - #col) .. " |"
                    end
                    table.insert(formatted, formatted_row)
                    if i == 1 then
                        local separator = "|"
                        for j = 1, #row do
                            separator = separator .. string.rep("-", max_col_widths[j] + 2) .. "|"
                        end
                        table.insert(formatted, separator)
                    end
                end
            end

            vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted)
        end
    end,
})
