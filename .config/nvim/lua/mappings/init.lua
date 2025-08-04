vim.g.mapleader = " "

local opt = { silent = false, noremap = true }
local utils = require('core.utils')

-- Resize split panes
vim.keymap.set('n', '<M-UP>', '<cmd>resize +2<cr>', opt)
vim.keymap.set('n', '<M-DOWN>', '<cmd>resize -2<cr>', opt)
vim.keymap.set('n', '<M-LEFT>', '<cmd>vertical resize +2<cr>', opt)
vim.keymap.set('n', '<M-RIGHT>', '<cmd>vertical resize -2<cr>', opt)

-- Quickfix
vim.keymap.set('n', '<C-l>', ":cnext<CR>", opt)
vim.keymap.set('n', '<C-h>', ":cprev<CR>", opt)

-- Search and replace in visual selection
vim.keymap.set('x', '<leader>/', [[:s/\%V]], { desc = "Search and replace" })

-- Move around
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Folding
vim.keymap.set({ 'n' }, '<F3>', "zc", { desc = "Fold" })
vim.keymap.set({ 'n' }, '<F5>', "zR", { desc = "Unfold all" })
vim.keymap.set({ 'n' }, '<F4>', "zo", { desc = "Unfold" })

vim.keymap.set('n', '<leader><leader>', ':w<CR>', { desc = "Save" })

-- Stuff
vim.keymap.set("n", "J", "mzJ`z", opt)
vim.keymap.set("n", "Y", "y$", opt)
vim.keymap.set("n", "N", "Nzzzv", opt)
vim.keymap.set("n", "n", "nzzzv", opt)
vim.keymap.set('n', '<c-k>', ':m -2<CR>==', opt)
vim.keymap.set('n', '<c-j>', ':m +1<CR>==', opt)
vim.keymap.set('v', '<M-k>', ":m '<-2<CR>gv=gv", opt)
vim.keymap.set('v', '<M-j>', ":m '>+1<CR>gv=gv", opt)

-- Indent
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opt)
vim.keymap.set("v", "L", ">gv", opt)
vim.keymap.set("v", "H", "<gv", opt)

-- Using jk as ESC
vim.keymap.set("t", "jk", "<C-\\><C-n>", opt)
vim.keymap.set({ "i", "v" }, "jk", "<esc>", opt)

-- Terminal Float
vim.keymap.set("t", "<F2>", "<C-\\><C-n>:ToggleTerm<CR>", opt)
vim.keymap.set("i", "<F2>", "<C-\\><C-n>:ToggleTerm<CR>", opt)
vim.keymap.set("n", "<F2>", "<C-\\><C-n>:ToggleTerm<CR>", opt)

-- Find file
vim.keymap.set('n', '<leader>fw', utils.search, { desc = "Find word global" })
vim.keymap.set('n', '<leader>ff', utils.file_picker, { desc = "Find Files" })
vim.keymap.set('n', '<leader>fr', utils.search_and_replace, { desc = "Search and replace" })

-- Open stuff
vim.keymap.set('n', '<leader>oo', function()
	vim.cmd('topleft vsplit') -- create split on the left
	vim.cmd('vertical resize 30') -- resize to 30 columns (adjust as needed)
	vim.cmd('edit .')      -- open filetree using netrw
end, { desc = "Filetree" })

-- DAP
vim.keymap.set('n', '<leader>dR', "<cmd>lua require'dap'.run_to_cursor()<CR>", { desc = "Run to Cursor" })
vim.keymap.set('n', '<leader>dE', "<cmd>lua require'dapui'.eval(vim.fn.input '[Expression] > ')<CR>",
	{ desc = "Evaluate Input" })
vim.keymap.set('n', '<leader>dC', "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<CR>",
	{ desc = "Conditional Breakpoint" })
vim.keymap.set('n', '<leader>dU', "<cmd>lua require'dapui'.toggle()<CR>", { desc = "Toggle UI" })
vim.keymap.set('n', '<leader>db', "<cmd>lua require'dap'.step_back()<CR>", { desc = "Step Back" })
vim.keymap.set('n', '<leader>dc', "<cmd>lua require'dap'.continue()<CR>", { desc = "Continue" })
vim.keymap.set('n', '<leader>dd', "<cmd>lua require'dap'.disconnect()<CR>", { desc = "Disconnect" })
vim.keymap.set('n', '<leader>de', "<cmd>lua require'dapui'.eval()<CR>", { desc = "Evaluate" })
vim.keymap.set('n', '<leader>dg', "<cmd>lua require'dap'.session()<CR>", { desc = "Get Session" })
vim.keymap.set('n', '<leader>dh', "<cmd>lua require'dap.ui.widgets'.hover()<CR>", { desc = "Hover Variables" })
vim.keymap.set('n', '<leader>dS', "<cmd>lua require'dap.ui.widgets'.scopes()<CR>", { desc = "Scopes" })
vim.keymap.set('n', '<leader>di', "<cmd>lua require'dap'.step_into()<CR>", { desc = "Step Into" })
vim.keymap.set('n', '<leader>do', "<cmd>lua require'dap'.step_over()<CR>", { desc = "Step Over" })
vim.keymap.set('n', '<leader>dp', "<cmd>lua require'dap'.pause.toggle()<CR>", { desc = "Pause" })
vim.keymap.set('n', '<leader>dq', "<cmd>lua require'dap'.close()<CR>", { desc = "Quit" })
vim.keymap.set('n', '<leader>dr', "<cmd>lua require'dap'.repl.toggle()<CR>", { desc = "Toggle Repl" })
vim.keymap.set('n', '<leader>ds', "<cmd>lua require'dap'.continue()<CR>", { desc = "Start" })
vim.keymap.set('n', '<leader>dt', "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle Breakpoint" })
vim.keymap.set('n', '<leader>dx', "<cmd>lua require'dap'.terminate()<CR>", { desc = "Terminate" })
vim.keymap.set('n', '<leader>du', "<cmd>lua require'dap'.step_out()<CR>", { desc = "Step Out" })

-- Window
vim.keymap.set('n', '<leader>wk', "<c-w>k", { desc = "Switch Up" })
vim.keymap.set('n', '<leader>wj', "<c-w>j", { desc = "Switch Down" })
vim.keymap.set('n', '<leader>wh', "<c-w>h", { desc = "Switch Left" })
vim.keymap.set('n', '<leader>wl', "<c-w>l", { desc = "Switch Right" })
vim.keymap.set('n', '<leader>wK', ":res +5<CR>", { desc = "Resize Up" })
vim.keymap.set('n', '<leader>wJ', ":res -5<CR>", { desc = "Resize Down" })
vim.keymap.set('n', '<leader>wH', ":vertical res -5<CR>", { desc = "Resize Left" })
vim.keymap.set('n', '<leader>wL', ":vertical res +5<CR>", { desc = "Resize Right" })
vim.keymap.set('n', '<leader>wq', ":q<CR>", { desc = "Kill Window" })


-- Buffer
vim.keymap.set('n', '<leader>bl', utils.buffers_to_quickfix, { desc = "List all buffers in quickfix list" })
vim.keymap.set('n', '<leader>bd', ":bd<CR>", { desc = "Delete This Buffer" })
vim.keymap.set('n', '<leader>ba', ":w <bar> %bd <bar> e# <bar> bd# <CR>", { desc = "Delete All But This Buffer" })
vim.keymap.set('n', '<tab>', ":bn<CR>", { desc = "Next Buffer" })
vim.keymap.set('n', '<s-tab>', ":bp<CR>", { desc = "Prev Buffer" })
