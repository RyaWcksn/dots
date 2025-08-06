local plugins = {
	-- Theme
	{ src = "https://github.com/rrethy/base16-nvim" },

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

	-- Treesitter
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },

	-- Gopher.nvim
	{ src = "https://github.com/olexsmir/gopher.nvim" },

	-- Autopairs
	{ src = "https://github.com/windwp/nvim-autopairs" },

}



vim.pack.add(plugins)

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.cmd.colorscheme("base16-ayu-dark")
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.defer_fn(function()
			require("configs.whichkey")
			require('configs.lspconfig')
		end, 50)
	end,
})

vim.api.nvim_create_autocmd("BufReadPre", {
	callback = function()
		require("configs.treesitter")
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	callback = function()
		require("configs.gopher")
	end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
	once = true,
	callback = function()
		require("configs.cmp")
		require("configs.snippet")
		require("configs.autopairs")
	end,
})
