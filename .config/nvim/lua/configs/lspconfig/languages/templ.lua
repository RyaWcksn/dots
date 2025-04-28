local M = {}

M.templ = function(capabilities, on_attach)
	local lsp = require('lspconfig')
	local setup = {
		capabilities = capabilities,
		on_attach = on_attach,
		cmd = { 'templ', 'lsp' },
		filetypes = { 'templ' },
		root_dir = lsp.util.root_pattern('.git', 'go.mod', '.', 'go.work'),
		settings = {
		},
	}
	return setup
end

return M
