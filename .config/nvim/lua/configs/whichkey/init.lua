local wk = require("which-key")
wk.setup {
	{
		operators = { gc = "Comments" },
		key_labels = {
			["<space>"] = "SPC",
			["<cr>"] = "RET",
			["<tab>"] = "TAB",
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

wk.add({
	{
		{ "<leader>b", group = "Buffer", remap = false },
		{ "<leader>d", group = "Debug",  remap = false },
		{ "<leader>f", group = "Finds",  remap = false },
		{ "<leader>l", group = "LSP",    remap = false },
		{ "<leader>n", group = "Notes",  remap = false },
		{ "<leader>o", group = "Open",   remap = false },
		{ "<leader>s", group = "DB",     remap = false },
		{ "<leader>w", group = "Window", remap = false },
	}

}, { prefix = "<leader>", mode = "n", noremap = true })
