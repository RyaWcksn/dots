local M = {}

M.kotlin = function(capabilities, on_attach)
	local lsp = require('lspconfig')
	local setup = {
		capabilities = capabilities,
		on_attach = on_attach,
		cmd = { "kotlin-language-server" },
		filetypes = { "kotlin", "kt" },
		root_dir = lsp.util.root_pattern("settings.gradle", "settings.gradle.kts"),
	}

	return setup
end

return M
