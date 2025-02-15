local M = {}

M.dartls = function(capabilities, on_attach)
	local lsp = require('lspconfig')
	local util = require 'lspconfig.util'
	local setup = {
		cmd = { "dart", "language-server", "--protocol=lsp" },
		on_attach = on_attach,
		capabilities = capabilities,
		single_file_support = true,
		filetypes = { "dart" },
		init_options = {
			{
				closingLabels = true,
				flutterOutline = true,
				onlyAnalyzeProjectsWithOpenFiles = true,
				outline = true,
				suggestFromUnimportedLibraries = true
			}
		},
		root_dir = util.root_pattern 'pubspec.yaml',
		settings = {
			{
				dart = {
					completeFunctionCalls = true,
					showTodos = true
				}
			}
		}
	}
	return setup
end

return M
