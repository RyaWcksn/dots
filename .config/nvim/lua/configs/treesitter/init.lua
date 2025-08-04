require 'nvim-treesitter.configs'.setup {
	ensure_installed = {
		"go",
		"javascript",
		"typescript",
		"lua",
		"tsx",
		"rust",
		"python",
		"templ",
	},
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<CR>",
			node_incremental = "<CR>",
			node_decremental = "<BS>",
		},
	},
	additional_vim_regex_highlighting = false,
}
