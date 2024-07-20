local M = {}

M.basedpyright = function(capabilities, on_attach)
	local lsp = require('lspconfig')
	vim.env.PYENV_VERSION = vim.fn.system('pyenv version'):match('(%S+)%s+%(.-%)')
	local setup = {
		cmd = { "basedpyright-langserver", "--stdio" },
		on_attach = on_attach,
		capabilities = capabilities,
		single_file_support = true,
		filetypes = { "python" },
		settings = {
			basedpyright = {
				analysis = {
					autoSearchPaths = true,
					diagnosticMode = "openFilesOnly",
					useLibraryCodeForTypes = true
				}
			}
		}
	}
	return setup
end

return M
