local wk = require("which-key")


-- Function to open URL under cursor
wk.setup {
	{
		plugins = {
			marks = true, -- shows a list of your marks on ' and `
			registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
			-- the presets plugin, adds help for a bunch of default keybindings in Neovim
			-- No actual key bindings are created
			spelling = {
				enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
				suggestions = 20, -- how many suggestions should be shown in the list?
			},
			presets = {
				operators = true, -- adds help for operators like d, y, ...
				motions = true, -- adds help for motions
				text_objects = true, -- help for text objects triggered after entering an operator
				windows = true, -- default bindings on <c-w>
				nav = true, -- misc bindings to work with windows
				z = true, -- bindings for folds, spelling and others prefixed with z
				g = true, -- bindings for prefixed with g
			},
		},
		-- add operators that will trigger motion and text object completion
		-- to enable all native operators, set the preset / operators plugin above
		operators = { gc = "Comments" },
		key_labels = {
			-- override the label used to display some keys. It doesn't effect WK in any other way.
			-- For example:
			-- ["<space>"] = "SPC",
			-- ["<cr>"] = "RET",
			-- ["<tab>"] = "TAB",
		},
		motions = {
			count = true,
		},
		icons = {
			breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
			separator = "➜", -- symbol used between a key and it's label
			group = "+", -- symbol prepended to a group
		},
		popup_mappings = {
			scroll_down = "<c-d>", -- binding to scroll down inside the popup
			scroll_up = "<c-u>", -- binding to scroll up inside the popup
		},
		window = {
			border = "none", -- none, single, double, shadow
			position = "bottom", -- bottom, top
			margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
			padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
			winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
			zindex = 1000, -- positive value to position WhichKey above other floating windows.
		},
		layout = {
			height = { min = 4, max = 25 },                             -- min and max height of the columns
			width = { min = 20, max = 50 },                             -- min and max width of the columns
			spacing = 3,                                                -- spacing between columns
			align = "left",                                             -- align columns left, center or right
		},
		ignore_missing = false,                                             -- enable this to hide mappings for which you didn't specify a label
		hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " }, -- hide mapping boilerplate
		show_help = true,                                                   -- show a help message in the command line for using WhichKey
		show_keys = true,                                                   -- show the currently pressed key and its label as a message in the command line
		triggers = "auto",                                                  -- automatically setup triggers
		-- triggers = {"<leader>"} -- or specifiy a list manually
		-- list of triggers, where WhichKey should not wait for timeoutlen and show immediately
		triggers_nowait = {
			-- marks
			"`",
			"'",
			"g`",
			"g'",
			-- registers
			'"',
			"<c-r>",
			-- spelling
			"z=",
		},
		triggers_blacklist = {
			-- list of mode / prefixes that should never be hooked by WhichKey
			-- this is mostly relevant for keymaps that start with a native binding
			i = { "j", "k" },
			v = { "j", "k" },
		},
		-- disable the WhichKey popup for certain buf types and file types.
		-- Disabled by default for Telescope
		disable = {
			buftypes = {},
			filetypes = {},
		},
	}
}

local function get_netrw_path()
	-- Get the current netrw directory
	local netrw_curdir = vim.fn.expand('%:p:h')

	-- Prompt the user for the filename
	local filename = vim.fn.input('Enter filename: ')

	-- Combine the directory path and the filename
	local file_path = netrw_curdir .. "/" .. filename

	-- Return the concatenated path
	return file_path
end

wk.register({
	b = {
		name = "+Buffer",
		b = { ":Telescope buffers<CR>", "Open Buffers" },
		d = { ":bd<CR>", "Delete This Buffer" },
		a = { ":w <bar> %bd <bar> e# <bar> bd# <CR>", "Delete All But This Buffer" },
	},
	w = {
		name = "+Window",
		k = { "<c-w>k", "Switch Up" },
		j = { "<c-w>j", "Switch Down" },
		h = { "<c-w>h", "Switch Leff" },
		l = { "<c-w>l", "Switch Right" },
		K = { ":res +5<CR>", "Resize Up" },
		J = { ":res -5<CR>", "Resize Down" },
		H = { ":vertical res -5<CR>", "Resize Left" },
		L = { ":vertical res +5<CR>", "Resize Right" },
		q = { ":q<CR>", "Kill Window" },
		["<Leader>"] = {
			name = "+Split",
			k = { ":vs<CR>", "Split Vertically" },
			j = { ":sp<CR>", "Split Horizontally" },
		},
	},
	f = {
		name = "+Finds",
		f = { ":Telescope find_files theme=dropdown<CR>", "Find Files" },
	},
	p = {
		name = "+Packer",
		s = { ":PackerSync<CR>", "Sync plugins" },
		i = { ":PackerInstall<CR>", "Install plugins" }
	},
	o = {
		name = "+Open",
		i = { ":Lexplore %:p:h<CR>", "Filetree" },
		e = { ":NvimTreeToggle<CR>", "Filetree" },
		t = { ":ToggleTerm<CR>", "ToggleTerm" },
	},
	l = {
		name = "+LSP",
	},
	d = {
		name = "Debug",
		R = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run to Cursor" },
		E = { "<cmd>lua require'dapui'.eval(vim.fn.input '[Expression] > ')<cr>", "Evaluate Input" },
		C = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>", "Conditional Breakpoint" },
		U = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
		b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
		c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
		d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
		e = { "<cmd>lua require'dapui'.eval()<cr>", "Evaluate" },
		g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
		h = { "<cmd>lua require'dap.ui.widgets'.hover()<cr>", "Hover Variables" },
		S = { "<cmd>lua require'dap.ui.widgets'.scopes()<cr>", "Scopes" },
		i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
		o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
		p = { "<cmd>lua require'dap'.pause.toggle()<cr>", "Pause" },
		q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
		r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
		s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
		t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
		x = { "<cmd>lua require'dap'.terminate()<cr>", "Terminate" },
		u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
	},
	s = {

		name = "+DB",
		u = { ':DBUIToggle<CR>', 'Toggle DBUI' },
		f = { ':DBUIFindBuffer<CR>', 'Find Buffer in DBUI' },
		r = { ':DBUIRenameBuffer<CR>', 'Rename Buffer in DBUI' },
		l = { ':DBUILastQueryInfo<CR>', 'Show Last Query Info in DBUI' }
	},
	K = { ":lua vim.lsp.buf.hover()<CR>", "Hover" },
	[";"] = { ":", "Command" }
}, { prefix = "<leader>", mode = "n", noremap = true })

wk.register({
}, { prefix = "<leader>", mode = "n", noremap = true })
