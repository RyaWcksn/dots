local M = {}

M.lua_ls = function(capabilities)
	local default_workspace = {
		library = {
			vim.env.VIMRUNTIME,
			"${3rd}/love2d/library",
		},

		checkThirdParty = false,
		maxPreload = 5000,
		preloadFileSize = 10000,
	}
	local setup = {
		capabilities = capabilities,
		cmd = { 'lua-language-server' },
		filetypes = { 'lua' },
		codeLens = { enabled = true },
		root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml",
			"stylua.toml", "selene.toml", "selene.yml", ".git" },
		settings = {
			Lua = {
				hint = { enable = true },
				elemetry = { enable = false },
				diagnostics = {
					globals = { "vim" },
				},
				workspace = default_workspace,
			}
		}
	}
	return setup
end

return M
