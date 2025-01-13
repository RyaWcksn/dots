vim.g.mapleader = " "

local opt = { silent = true, noremap = true }
local keymap = vim.keymap.set

-- Resize split panes
keymap('n', '<M-UP>', '<cmd>resize +2<cr>', opt)
keymap('n', '<M-DOWN>', '<cmd>resize -2<cr>', opt)
keymap('n', '<M-LEFT>', '<cmd>vertical resize +2<cr>', opt)
keymap('n', '<M-RIGHT>', '<cmd>vertical resize -2<cr>', opt)

-- Quickfix
keymap('n', '<C-l>', ":cnext<CR>", opt)
keymap('n', '<C-h>', ":cprev<CR>", opt)

-- Search and replace in visual selection
keymap('x', '<leader>/', [[:s/\%V]], opt)

keymap({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

keymap({ 'n' }, '<F3>', "zc", { desc = "Fold" })
keymap({ 'n' }, '<F5>', "zR", { desc = "Unfold all" })
keymap({ 'n' }, '<F4>', "zo", { desc = "Unfold" })

keymap('n', '<bs>', '<c-^>\'”zz', { desc = "Prev buffer" })

keymap('n', '<leader><leader>', ':w<CR>', { desc = "Save" })

-- Stuff
keymap("n", "J", "mzJ`z", opt)
keymap("n", "Y", "y$", opt)
keymap("n", "N", "Nzzzv", opt)
keymap("n", "n", "nzzzv", opt)
keymap('n', '<c-k>', ':m -2<CR>==', opt)
keymap('n', '<c-j>', ':m +1<CR>==', opt)
keymap('v', '<M-k>', ":m '<-2<CR>gv=gv", opt)
keymap('v', '<M-j>', ":m '>+1<CR>gv=gv", opt)

-- Add blank line without leaving normal mode
keymap('n', '<leader>o', 'o<Esc>', opt)
keymap('n', '<leader>O', 'O<Esc>', opt)

-- Delete word with backspace
keymap('n', '<C-BS>', 'a<C-w>', opt)

-- Indent
keymap("v", "K", ":m '<-2<CR>gv=gv", opt)
keymap("v", "L", ">gv", opt)
keymap("v", "H", "<gv", opt)

-- Using ; to Command mode
-- keymap("n", ";", ":", {})

-- Using jk as ESC
keymap("t", "jk", "<C-\\><C-n>", opt)
keymap({ "i", "v" }, "jk", "<esc>", opt)

-- Terminal Float
keymap("t", "<F2>", "<C-\\><C-n>:ToggleTerm<CR>", opt)
keymap("i", "<F2>", "<C-\\><C-n>:ToggleTerm<CR>", opt)
keymap("n", "<F2>", "<C-\\><C-n>:ToggleTerm<CR>", opt)

-- Search and replace word under the cursor
keymap('n', '<leader>R', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>',
	{ desc = 'Search and replace word under the cursor' })

-- Carbon Now Sha
keymap("v", "<F5>", ":CarbonNowSh<CR>", opt)

keymap("n", "<Up>", "<C-u>", opt)
keymap("n", "<Down>", "<C-d>", opt)


-- Search and replace
function search_replace_with_confirmation(type)
	local oldTerm = vim.fn.input('Enter search term: ')

	local newTerm = vim.fn.input('Enter replacement term: ')

	if type == "global" then
		vim.cmd('vimgrep /' .. oldTerm .. '/ **/*')
	elseif type == "local" then
		local filename = vim.fn.expand('%')

		vim.cmd('vimgrep /' .. oldTerm .. '/ ' .. filename)
	end

	vim.cmd('copen')

	vim.cmd('cdo %s/' .. oldTerm .. '/' .. newTerm .. '/gc')

	vim.cmd('cclose')
end

function search_word(type)
	local word = vim.fn.input('Enter search term: ')
	if type == "global" then
		vim.cmd('vimgrep /' .. word .. '/ **/*')
	elseif type == "local" then
		local filename = vim.fn.expand('%')

		vim.cmd('vimgrep /' .. word .. '/ ' .. filename)
	end

	vim.cmd('copen')
end

function search_under_cursor(type)
	local success, result = xpcall(function()
		local word = vim.fn.expand('<cword>')
		if type == "global" then
			vim.cmd('vimgrep /' .. word .. '/ **/*')
		elseif type == "local" then
			local filename = vim.fn.expand('%')
			vim.cmd('vimgrep /' .. word .. '/ ' .. filename)
		end
		vim.cmd('copen')
	end, function(err)
		-- This function will be called if an error occurs
		if not string.find(err, "interrupted!") then
			print("An error occurred during the search.")
		end
	end)

	-- Handle errors caught by xpcall
	if not success and not string.find(result, "interrupted!") then
		print("An error occurred during the search.")
	end
end

keymap('n', '<leader>fR', ":lua search_replace_with_confirmation('global')<CR>", { desc = "Find and replace global" })
keymap('n', '<leader>fr', ":lua search_replace_with_confirmation('local')<CR>", { desc = "Find and replace local" })
keymap('n', '<leader>fw', ":Telescope live_grep<CR>", { desc = "Find word global" })
keymap('n', '<leader>fo', ":lua search_under_cursor('local')<CR>", { desc = "Find word under cursor local" })
keymap('n', '<leader>fO', ":lua search_under_cursor('global')<CR>", { desc = "Find word under cursor global" })
keymap('n', '<leader>fe', ':lua search_word("global")<CR>', {desc = "Find word"})

-- Function to list all buffers and populate the quickfix list
local function buffers_to_quickfix()
  local buffers = vim.api.nvim_list_bufs() -- Get all buffers
  local quickfix_list = {}

  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" then -- Ignore unnamed buffers
        table.insert(quickfix_list, {
          filename = name,
          lnum = 1, -- Line number (default to 1)
          col = 1,  -- Column number (default to 1)
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

-- Map the function to a key (e.g., <leader>bl)
vim.keymap.set('n', '<leader>bl', buffers_to_quickfix, { desc = "List all buffers in quickfix list" })



vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('lsp', { clear = true }),
	callback = function()
		local map = function(key, action, desc)
			vim.keymap.set('n', '<leader>' .. key, action, { desc = "LSP: " .. desc })
		end
		keymap("n", "K", ":lua vim.lsp.buf.hover()<CR>", opt)
		keymap('n', '[', ":lua vim.diagnostic.goto_prev()<CR>", opt)
		keymap('n', ']', ":lua vim.diagnostic.goto_next()<CR>", opt)
		map('lf', vim.lsp.buf.format, "Format")
		map('lc', vim.lsp.buf.code_action, "Code Action")
		map('ls', vim.lsp.buf.signature_help, "Signature Help")
		map('ld', vim.lsp.buf.definition, "Goto Definition")
		map('li', vim.lsp.buf.implementation, "Code Implementation")
		map('lw', vim.lsp.buf.references, "Code References")
		map('ll', vim.lsp.codelens.run, "Codelens Run")
		map('lL', vim.lsp.codelens.refresh, "Codelens Refresh")
		map('lr', vim.lsp.buf.rename, "Rename")
		map('lr', vim.lsp.buf.rename, "Rename")
		map('lt', vim.diagnostic.setqflist, "Diagnostics")
	end
})
