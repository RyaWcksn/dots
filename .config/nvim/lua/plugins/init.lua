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

require("lazy").setup({
	{
		"rrethy/base16-nvim"
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
		"apzelos/blamer.nvim"
	},
	{
		"folke/which-key.nvim",
		config = function()
			require('configs.whichkey')
		end,
		cmd = "Whichkey",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
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
		build = ":TSUpdate",
		config = function()
			require('configs.treesitter')
			local ok, hl = pcall(require, "vim.treesitter.highlighter")
			if ok then
				local orig = hl.new
				hl.new = function(...)
					local self = orig(...)
					local orig_on_line = self.on_line
					self.on_line = function(s, buf, line)
						local ok, err = pcall(function()
							local line_text = vim.api.nvim_buf_get_lines(buf, line, line + 1,
								false)[1] or ""
							local line_len = #line_text
							local orig_extmark = vim.api.nvim_buf_set_extmark
							vim.api.nvim_buf_set_extmark = function(bufnr, ns_id, lnum, col,
												opts)
								if opts.end_col and opts.end_col > line_len then
									opts.end_col = line_len
								end
								return orig_extmark(bufnr, ns_id, lnum, col, opts)
							end

							orig_on_line(s, buf, line)

							vim.api.nvim_buf_set_extmark = orig_extmark -- restore
						end)
						if not ok then
							vim.schedule(function()
								vim.notify("TS highlight error: " .. err,
									vim.log.levels.ERROR)
							end)
						end
					end

					return self
				end
			end
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
