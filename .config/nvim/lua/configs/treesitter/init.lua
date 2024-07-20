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
}
