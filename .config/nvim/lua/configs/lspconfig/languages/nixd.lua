local M = {}

M.nixd = function(capabilities, on_attach)
	local lsp = require('lspconfig')
	local setup = {
		capabilities = capabilities,
		on_attach = on_attach,
		cmd = { 'nixd' },
		filetypes = { 'nix' },
		root_dir = lsp.util.root_pattern('.git', 'flake.nix', '.'),
		single_file_support = true
	}
	return setup
end

return M
