local M = {}

M.clangd = function(capabilities, on_attach)
	local lsp = require('lspconfig')
	local setup = {
		capabilities = capabilities,
		on_attach = on_attach,
		cmd = { 'clangd' },
		filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
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
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = { "*.go" },
		callback = function()
			local params = vim.lsp.util.make_range_params(nil, "utf-16")
			params.context = { only = { "source.organizeImports" } }
			local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
			for _, res in pairs(result or {}) do
				for _, r in pairs(res.result or {}) do
					if r.edit then
						vim.lsp.util.apply_workspace_edit(r.edit, "utf-16")
					else
						vim.lsp.buf.execute_command(r.command)
					end
				end
			end
		end,
	})

	return setup
end

return M
