local M = {}

M.clangd = function(capabilities, on_attach)
	local lsp = require('lspconfig')
	local setup = {
		capabilities = capabilities,
		on_attach = on_attach,
		cmd = { 'clangd' },
		filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
		root_dir = lsp.util.root_pattern(
			'.clangd',
			'.clang-tidy',
			'.clang-format',
			'compile_commands.json',
			'compile_flags.txt',
			'configure.ac',
			'.git'
		),
		single_file_support = true
	}
	return setup
end

return M
