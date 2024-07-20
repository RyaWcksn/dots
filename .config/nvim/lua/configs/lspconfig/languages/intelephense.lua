local M = {}

M.intelephense = function(capabilities, on_attach)
	local lsp = require('lspconfig')
	local setup = {
		cmd = { "intelephense", "--stdio" },
		filetypes = { 'php' },
		root_dir = lsp.util.root_pattern('.git', 'composer.json'),
	}

	return setup
end


return M
