local M = {}

M.terraformls = function(capabilities, on_attach)
	local lsp = require('lspconfig')
	local setup = {
		capabilities = capabilities,
		on_attach = on_attach,
		cmd = { "terraform-ls", "serve" },
		filetypes = { "terraform", "terraform-vars" },
		root_dir = lsp.util.root_pattern(".terraform", ".git", ""),
	}

	return setup
end

return M
