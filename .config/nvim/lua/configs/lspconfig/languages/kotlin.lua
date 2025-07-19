local M = {}

M.kotlin = function(capabilities, on_attach)
	local lsp = require('lspconfig')
	local setup = {
		capabilities = capabilities,
		on_attach = on_attach,
		cmd = { "/home/aya/Downloads/kotlin-lsp.sh" },
		filetypes = { "kotlin", "kt" },
		root_dir = lsp.util.root_pattern("settings.gradle", "settings.gradle.kts"),
		settings = {
			kotlin = {
				compiler = {
					jvm = {
						target = "17" -- or "1.8" if that's what you really want
					}
				}
			}
		}
	}

	return setup
end

return M
