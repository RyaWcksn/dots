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
		"yetone/avante.nvim",
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		-- ⚠️ must add this setting! ! !
		build = function()
			-- conditionally use the correct build system for the current OS
			if vim.fn.has("win32") == 1 then
				return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			else
				return "make"
			end
		end,
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		---@module 'avante'
		---@type avante.Config
		opts = {
			-- add any opts here
			-- for example
			provider = "gemini",
			-- providers = {
			-- 	gemini = {
			-- 	},
			-- },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"echasnovski/mini.pick", -- for file_selector provider mini.pick
			"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			"ibhagwan/fzf-lua", -- for file_selector provider fzf
			"stevearc/dressing.nvim", -- for input provider dressing
			"folke/snacks.nvim", -- for input provider snacks
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				'MeanderingProgrammer/render-markdown.nvim',
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
	{
		"nyoom-engineering/oxocarbon.nvim"
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			strategies = {
				chat = {
					adapter = "gemini",
				},
				inline = {
					adapter = "gemini",
				},
			},
			gemini = function()
				return require("codecompanion.adapters").extend("gemini", {
					schema = {
						model = {
							default = "gemini-2.0-flash-lite",
						},
					},
					env = {
						api_key = "AIzaSyB7OC5PmZe5T8WhaHUGznJNpTRuoWroC0g",
					},
				})
			end,
			display = {
				diff = {
					provider = "mini_diff",
				},
			},
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "codecompanion" }
	},
	{
		"echasnovski/mini.diff",
		config = function()
			local diff = require("mini.diff")
			diff.setup({
				-- Disabled by default
				source = diff.gen_source.none(),
			})
		end,
	},
	{
		"simrat39/rust-tools.nvim",
		ft = " rust"
	},
	{
		"rrethy/base16-nvim"
	},
	-- -- ai companion
	-- {
	-- 	"nomnivore/ollama.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 	},

	-- 	-- all the user commands added by the plugin
	-- 	cmd = { "ollama", "ollamamodel", "ollamaserve", "ollamaservestop" },
	-- 	keys = {
	-- 		{
	-- 			"<leader>og",
	-- 			":<c-u>lua require('ollama').prompt('generate_code')<cr>",
	-- 			desc = "ollama generate code",
	-- 			mode = { "n", "v" },
	-- 		},
	-- 	},
	-- 	config = function()
	-- 		require('configs.ollama')
	-- 	end
	-- },
	-- simple, minimal lazy.nvim configuration
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
		"numtostr/comment.nvim",
		config = function()
			require('configs.comment')
		end,
	},

	{
		"apzelos/blamer.nvim"
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
		cmd = "whichkey",
		event = "verylazy",
	},
	{ 'nvim-lua/plenary.nvim' },
	{
		'nvim-telescope/telescope.nvim',
		config = function()
			require('configs.telescope')
		end,
		lazy = true,
		cmd = "telescope",
	},
	{ 'nvim-telescope/telescope-fzf-native.nvim', make = 'make' },
	{
		'hrsh7th/nvim-cmp',
		config = function()
			require('configs.cmp')
		end,
		event = { "insertenter", "cmdlineenter" },
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp",         lazy = true },
			{ "saadparwaiz1/cmp_luasnip",     lazy = true },
			{ "hrsh7th/cmp-path",             lazy = true },
			{ "rafamadriz/friendly-snippets", lazy = true },
		},
	},
	{
		'l3mon4d3/luasnip',
		config = function()
			require('configs.snippet')
		end,
		event = "insertenter",
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
		build = ":tsupdate",
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
