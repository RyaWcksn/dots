local M = {}

M.tailwind = function(capabilities, on_attach)
	local lsp = require('lspconfig')
	local setup = {
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { "templ", "astro", "typescript", "react", "html", "htmldjango", "typescriptreact", "javascript", "javascriptreact" },
		settings = {
			tailwindCSS = {
				includeLanguages = {
					templ = "html",
				},
			},
		},
	}
	return setup
end

return M
