local M = {}

M.golangci = function(capabilities)
	local setup = {
		capabilities = capabilities,
		default_config = {
			cmd = { 'golangci-lint-langserver' },
			root_markers = { '.golangci.yml', '.golangci.yaml', '.golangci.toml', '.golangci.json', 'go.work', 'go.mod', '.git' },
			init_options = {
				command = { "golangci-lint", "run", "--out-format", "json" },
			}
		},
		filetypes = { 'go', 'gomod' }
	}
	return setup
end

return M
