local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

require("lazy").setup({
	{
		"nyoom-engineering/oxocarbon.nvim"
	},
	{
		"simrat39/rust-tools.nvim",
		ft = " rust"
	},
	{
		"RRethy/base16-nvim"
	},
	-- -- AI companion
	-- {
	-- 	"nomnivore/ollama.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 	},

	-- 	-- All the user commands added by the plugin
	-- 	cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },
	-- 	keys = {
	-- 		{
	-- 			"<leader>oG",
	-- 			":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
	-- 			desc = "ollama Generate Code",
	-- 			mode = { "n", "v" },
	-- 		},
	-- 	},
	-- 	config = function()
	-- 		require('configs.ollama')
	-- 	end
	-- },
	-- Simple, minimal Lazy.nvim configuration
	{
		"huynle/ogpt.nvim",
		event = "VeryLazy",
		opts = {
			default_provider = "ollama",
			providers = {
				openrouter = {
					enabled = true,
					model = "google/gemma-3-27b-it:free",
					api_host = os.getenv("OPENROUTER_API_HOST") or "https://openrouter.ai/api",
					api_key = os.getenv("OPENROUTER_API_KEY") or
					    "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",
					api_params = {
						temperature = 0.5,
						top_p = 0.99,
					},
					api_chat_params = {
						frequency_penalty = 0.8,
						presence_penalty = 0.5,
						temperature = 0.8,
						top_p = 0.99,
					},
				},
			}
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim"
		}
	},
	{
		"rcarriga/nvim-notify",
		config = function()
			require("notify").setup({
				stages = "fade",
				timeout = 5000,
			})
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require('configs.comment')
		end,
	},

	{
		"APZelos/blamer.nvim"
	},
	{
		'neovim/nvim-lspconfig',
		config = function()
			require('configs.lspconfig')
		end,
	},
	{
		"folke/which-key.nvim",
		config = function()
			require('configs.whichkey')
		end,
		cmd = "WhichKey",
		event = "VeryLazy",
	},
	{ 'nvim-lua/plenary.nvim' },
	{
		'nvim-telescope/telescope.nvim',
		config = function()
			require('configs.telescope')
		end,
		lazy = true,
		cmd = "Telescope",
	},
	{ 'nvim-telescope/telescope-fzf-native.nvim', make = 'make' },
	{
		'hrsh7th/nvim-cmp',
		config = function()
			require('configs.cmp')
		end,
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp",         lazy = true },
			{ "saadparwaiz1/cmp_luasnip",     lazy = true },
			{ "hrsh7th/cmp-path",             lazy = true },
			{ "rafamadriz/friendly-snippets", lazy = true },
		},
	},
	{
		'L3MON4D3/LuaSnip',
		config = function()
			require('configs.snippet')
		end,
		event = "InsertEnter",
		dependencies = {
			"friendly-snippets",
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			'mfussenegger/nvim-dap',
			"nvim-neotest/nvim-nio",
			"leoluz/nvim-dap-go"
		},
		config = function()
			require("configs.dap")
		end
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require('configs.treesitter')
		end
	},
	{
		"olexsmir/gopher.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("configs.gopher")
		end,
		ft = "go"
	},
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("configs.toggleterm")
		end
	},
	{
		"windwp/nvim-autopairs",
		wants = "nvim-treesitter",
		module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
		config = function()
			require("configs.autopairs")
		end,
	},
})
