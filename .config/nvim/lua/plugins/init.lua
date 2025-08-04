local plugins = {
	-- Theme
	{ src = "https://github.com/rrethy/base16-nvim" },

	-- Notifications
	{ src = "https://github.com/rcarriga/nvim-notify" },

	-- Git Blame
	{ src = "https://github.com/apzelos/blamer.nvim" },

	-- Which Key
	{ src = "https://github.com/folke/which-key.nvim" },

	-- Autocompletion
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/saadparwaiz1/cmp_luasnip" },
	{ src = "https://github.com/hrsh7th/cmp-path" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },

	-- Snippets
	{ src = "https://github.com/L3MON4D3/LuaSnip" },

	-- DAP + DAP UI
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
	{ src = "https://github.com/leoluz/nvim-dap-go" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },

	-- Treesitter
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },

	-- Gopher.nvim
	{ src = "https://github.com/olexsmir/gopher.nvim" },

	-- Terminal
	{ src = "https://github.com/akinsho/toggleterm.nvim" },

	-- Autopairs
	{ src = "https://github.com/windwp/nvim-autopairs" },

}

vim.pack.add(plugins)

-- Plugin config
vim.cmd.colorscheme("base16-ayu-dark")

require("notify").setup({
	stages = "fade",
	timeout = 5000,
})
vim.notify = require("notify")

vim.g.gitblame_enabled = 0
vim.g.gitblame_message_template = "<summary> • <date> • <author>"
vim.g.gitblame_highlight_group = "LineNr"
vim.g.gist_open_browser_after_post = 1

require("configs.whichkey")
require("configs.cmp")
require("configs.snippet")
require("configs.dap")
require("configs.treesitter")
require("configs.gopher")
require("configs.toggleterm")
require("configs.autopairs")
require('configs.lspconfig')
