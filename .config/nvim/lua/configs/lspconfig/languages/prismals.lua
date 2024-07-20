local M = {}

M.prismals = function(capabilities, on_attach)
	local lsp = require('lspconfig')
	local setup = {
		capabilities = capabilities,
		on_attach = on_attach,
		cmd = { "prisma-language-server", "--stdio" },
		filetypes = { 'prisma' },
		root_dir = lsp.util.root_pattern(".git", "package.json"),
		settings = {
			{
				prisma = {
					prismaFmtBinPath = ""
				}
			}
		},
	}
	return setup
end

return M
