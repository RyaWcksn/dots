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

-- Move around
keymap({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Folding
keymap({ 'n' }, '<F3>', "zc", { desc = "Fold" })
keymap({ 'n' }, '<F5>', "zR", { desc = "Unfold all" })
keymap({ 'n' }, '<F4>', "zo", { desc = "Unfold" })

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

-- Find file
keymap('n', '<leader>fw', ":Telescope live_grep<CR>", { desc = "Find word global" })
keymap('n', '<leader>fe', ':lua search_word("global")<CR>', { desc = "Find word" })
keymap('n', '<leader>ff', ":Telescope find_files theme=dropdown<CR>", { desc = "Find Files" })

-- Open stuff
keymap('n', '<leader>oo', ':Lexplore %:p:h<CR>', { desc = "Filetree" })

-- DAP
keymap('n', '<leader>dR', "<cmd>lua require'dap'.run_to_cursor()<CR>", { desc = "Run to Cursor" })
keymap('n', '<leader>dE', "<cmd>lua require'dapui'.eval(vim.fn.input '[Expression] > ')<CR>", { desc = "Evaluate Input" })
keymap('n', '<leader>dC', "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<CR>",
	{ desc = "Conditional Breakpoint" })
keymap('n', '<leader>dU', "<cmd>lua require'dapui'.toggle()<CR>", { desc = "Toggle UI" })
keymap('n', '<leader>db', "<cmd>lua require'dap'.step_back()<CR>", { desc = "Step Back" })
keymap('n', '<leader>dc', "<cmd>lua require'dap'.continue()<CR>", { desc = "Continue" })
keymap('n', '<leader>dd', "<cmd>lua require'dap'.disconnect()<CR>", { desc = "Disconnect" })
keymap('n', '<leader>de', "<cmd>lua require'dapui'.eval()<CR>", { desc = "Evaluate" })
keymap('n', '<leader>dg', "<cmd>lua require'dap'.session()<CR>", { desc = "Get Session" })
keymap('n', '<leader>dh', "<cmd>lua require'dap.ui.widgets'.hover()<CR>", { desc = "Hover Variables" })
keymap('n', '<leader>dS', "<cmd>lua require'dap.ui.widgets'.scopes()<CR>", { desc = "Scopes" })
keymap('n', '<leader>di', "<cmd>lua require'dap'.step_into()<CR>", { desc = "Step Into" })
keymap('n', '<leader>do', "<cmd>lua require'dap'.step_over()<CR>", { desc = "Step Over" })
keymap('n', '<leader>dp', "<cmd>lua require'dap'.pause.toggle()<CR>", { desc = "Pause" })
keymap('n', '<leader>dq', "<cmd>lua require'dap'.close()<CR>", { desc = "Quit" })
keymap('n', '<leader>dr', "<cmd>lua require'dap'.repl.toggle()<CR>", { desc = "Toggle Repl" })
keymap('n', '<leader>ds', "<cmd>lua require'dap'.continue()<CR>", { desc = "Start" })
keymap('n', '<leader>dt', "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle Breakpoint" })
keymap('n', '<leader>dx', "<cmd>lua require'dap'.terminate()<CR>", { desc = "Terminate" })
keymap('n', '<leader>du', "<cmd>lua require'dap'.step_out()<CR>", { desc = "Step Out" })

-- Window
keymap('n', '<leader>wk', "<c-w>k", { desc = "Switch Up" })
keymap('n', '<leader>wj', "<c-w>j", { desc = "Switch Down" })
keymap('n', '<leader>wh', "<c-w>h", { desc = "Switch Left" })
keymap('n', '<leader>wl', "<c-w>l", { desc = "Switch Right" })
keymap('n', '<leader>wK', ":res +5<CR>", { desc = "Resize Up" })
keymap('n', '<leader>wJ', ":res -5<CR>", { desc = "Resize Down" })
keymap('n', '<leader>wH', ":vertical res -5<CR>", { desc = "Resize Left" })
keymap('n', '<leader>wL', ":vertical res +5<CR>", { desc = "Resize Right" })
keymap('n', '<leader>wq', ":q<CR>", { desc = "Kill Window" })

-- Nested mappings under <leader>w<Leader>
keymap('n', '<leader>w<leader>k', ":vs<CR>", { desc = "Split Vertically" })
keymap('n', '<leader>w<leader>j', ":sp<CR>", { desc = "Split Horizontally" })

-- Database
keymap('n', '<leader>mu', ":DBUIToggle<CR>", { desc = "Toggle DBUI" })
keymap('n', '<leader>mf', ":DBUIFindBuffer<CR>", { desc = "Find Buffer in DBUI" })
keymap('n', '<leader>mr', ":DBUIRenameBuffer<CR>", { desc = "Rename Buffer in DBUI" })
keymap('n', '<leader>ml', ":DBUILastQueryInfo<CR>", { desc = "Show Last Query Info in DBUI" })


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

-- Buffer
keymap('n', '<leader>bl', buffers_to_quickfix, { desc = "List all buffers in quickfix list" })
keymap('n', '<leader>bd', ":bd<CR>", { desc = "Delete This Buffer" })
keymap('n', '<leader>ba', ":w <bar> %bd <bar> e# <bar> bd# <CR>", { desc = "Delete All But This Buffer" })

-- Note taking
local function open_daily_note()
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
		vim.cmd("normal o")
	end
end

keymap("n", "<leader>nd", open_daily_note, { noremap = true, silent = false, desc = "Journal time" })
