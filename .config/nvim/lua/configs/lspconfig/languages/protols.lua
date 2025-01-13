local M = {}

M.protols = function(capabilities, on_attach)
	local lsp = require('lspconfig')
	local setup = {
		capabilities = capabilities,
		on_attach = on_attach,
		cmd = { 'protols' },
		filetypes = { 'proto' },
		root_dir = function(fname)
			return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
		end,
		single_file_support = true,
		docs = {
			description = [[
https://github.com/coder3101/protols

`protols` can be installed via `cargo`:
```sh
cargo install protols
```

A Language Server for proto3 files. It uses tree-sitter and runs in single file mode.
]],
		},
	}

	return setup
end

return M
