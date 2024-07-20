local M = {}

M.golangci = function(capabilities, on_attach)
	local lsp = require('lspconfig')
	local setup = {
		capabilities = capabilities,
		on_attach = on_attach,
		default_config = {
			cmd = { 'golangci-lint-langserver' },
			root_dir = lsp.util.root_pattern('.golangci.yml', '.golangci.yaml', '.golangci.toml',
				'.golangci.json',
				'go.work', 'go.mod', '.git'),
			init_options = {
				command = { "golangci-lint", "run", "--out-format", "json" },
			}
		},
		filetypes = { 'go', 'gomod' }
	}
	return setup
end

return M
