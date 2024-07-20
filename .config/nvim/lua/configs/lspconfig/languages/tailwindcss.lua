local M = {}

M.tailwind = function(capabilities, on_attach)
	local lsp = require('lspconfig')
	local setup = {
		capabilities = capabilities,
		on_attach = on_attach,
	}
	return setup
end

return M
