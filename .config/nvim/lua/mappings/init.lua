vim.g.mapleader = " "

local opt = { silent = false, noremap = true }
local utils = require('core.utils')

-- Quickfix
vim.keymap.set('n', '<C-l>', ":cnext<CR>", opt)
vim.keymap.set('n', '<C-h>', ":cprev<CR>", opt)

-- Move around
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Folding
vim.keymap.set({ 'n' }, '<leader>kk', "zc", { desc = "Fold" })
vim.keymap.set({ 'n' }, '<leader>kh', "zR", { desc = "Unfold all" })
vim.keymap.set({ 'n' }, '<leader>kl', "zo", { desc = "Unfold" })

vim.keymap.set('n', '<leader><leader>', ':w<CR>', { desc = "Save" })

-- Stuff
vim.keymap.set("n", "J", "mzJ`z", opt)
vim.keymap.set("n", "Y", "y$", opt)

-- Using jk as ESC
vim.keymap.set("t", "jk", "<C-\\><C-n>", opt)
vim.keymap.set({ "i", "v" }, "jk", "<esc>", opt)

-- Find file
vim.keymap.set('n', '<leader>fw', utils.search, { desc = "Find word global" })
vim.keymap.set('n', '<leader>ff', utils.file_picker, { desc = "Find Files" })
vim.keymap.set('n', '<leader>fr', utils.search_and_replace, { desc = "Search and replace" })

-- Open stuff
vim.keymap.set('n', '<leader>oo', utils.open_file_tree, { desc = "Filetree" })

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

-- Buffer
vim.keymap.set('n', '<leader>bl', utils.buffers_to_quickfix, { desc = "List all buffers in quickfix list" })
vim.keymap.set('n', '<leader>bd', ":bd<CR>", { desc = "Delete This Buffer" })
vim.keymap.set({ 'n', 'v' }, '<leader>bb', utils.git_blame_current_line, { desc = "Git Blame current line" })
vim.keymap.set('n', '<leader>ba', ":w <bar> %bd <bar> e# <bar> bd# <CR>", { desc = "Delete All But This Buffer" })
vim.keymap.set('n', '<tab>', ":bn<CR>", { desc = "Next Buffer" })
vim.keymap.set('n', '<s-tab>', ":bp<CR>", { desc = "Prev Buffer" })
