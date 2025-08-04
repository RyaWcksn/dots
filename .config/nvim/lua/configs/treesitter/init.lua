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
	highlight = {
		enable = true,
	},
}
