local M = {}

M.pyright = function(capabilities, on_attach)
	local lsp = require('lspconfig')
	vim.env.PYENV_VERSION = vim.fn.system('pyenv version'):match('(%S+)%s+%(.-%)')
	local setup = {
		cmd = { "pyright-langserver", "--stdio" },
		on_attach = on_attach,
		capabilities = capabilities,
		single_file_support = true,
		filetypes = { "python" }
	}
	return setup
end

return M
