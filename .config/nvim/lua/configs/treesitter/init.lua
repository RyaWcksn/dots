require 'nvim-treesitter.configs'.setup {
	ensure_installed = {
		"go",
		"javascript",
		"typescript",
		"lua",
		"tsx",
		"rust",
		"python",
	},
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = " ",
			node_incremental = " ",
			scope_incremental = "gi",
			node_decremental = "g ",
		},
	},
	highlight = {
		enable = true,
	},
}
