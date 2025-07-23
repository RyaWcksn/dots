local M = {}

M.rust_analyzer = function(capabilities, on_attach)
	local setup = {
		capabilities = capabilities,
		on_attach = on_attach,
		cmd = { "rust-analyzer" },
		filetypes = { "rust" },
		root_markers = { "Cargo.toml" },
		settings = {
			['rust-analyzer'] = {
				diagnostics = {
					enable = false,
				},
				cargo = {
					allFeatures = true,
				},
				inlayHints = {
					bindingModeHints = {
						enable = true
					},
					chainingHints = {
						enable = true
					},
					closingBraceHints = {
						enable = true
					}
				},
				lens = {
					references = {
						adt = {
							enable = true
						}
					}
				}
			}
		},
	}
	return setup
end

return M
