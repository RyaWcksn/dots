local wk = require("which-key")
wk.setup {
	{
		plugins = {
			marks = true, -- shows a list of your marks on ' and `
			registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
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
		operators = { gc = "Comments" },
		key_labels = {
			["<space>"] = "SPC",
			["<cr>"] = "RET",
			["<tab>"] = "TAB",
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
		triggers_nowait = {
			-- marks
			"`",
			"'",
			"g`",
			"g'",
			'"',
			"<c-r>",
			"z=",
		},
		triggers_blacklist = {
			i = { "j", "k" },
			v = { "j", "k" },
		},
		disable = {
			buftypes = {},
			filetypes = {},
		},
	}
}

wk.register({
	b = {
		name = "+Buffer",
	},
	w = {
		name = "+Window",
	},
	f = {
		name = "+Finds",
	},
	o = {
		name = "+Open",
	},
	l = {
		name = "+LSP",
	},
	d = {
		name = "+Debug",
	},
	s = {
		name = "+DB",
	},
	n = {
		name = "+Notes"
	}
}, { prefix = "<leader>", mode = "n", noremap = true })

wk.register({
}, { prefix = "<leader>", mode = "n", noremap = true })
