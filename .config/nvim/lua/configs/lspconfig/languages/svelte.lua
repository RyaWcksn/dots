local M = {}

M.svelte = function(capabilities, on_attach)
	local lsp = require('lspconfig')
	local setup = {
		cmd = { "svelteserver", "--stdio" },
		on_attach = on_attach,
		capabilities = capabilities,
		single_file_support = true,
		filetypes = { "svelte" },
		root_dir = lsp.util.root_pattern("package.json", ".git"),
	}
	return setup
end

return M
