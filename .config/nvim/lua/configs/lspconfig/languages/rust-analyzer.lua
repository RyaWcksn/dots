local M = {}

M.rust_analyzer = function(capabilities, on_attach)
	local lsp = require('lspconfig')
	local setup = {
		capabilities = capabilities,
		on_attach = on_attach,
		cmd = { "rust-analyzer" },
		filetypes = { "rust" },
		root_dir = lsp.util.root_pattern("Cargo.toml"),
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

M.rust_tools = function(capabilities, on_attach)
	local lsp = require('lspconfig')
	local opts = {
		tools = {
			runnables = {
				use_telescope = true,
			},
			inlay_hints = {
				auto = true,
				show_parameter_hints = false,
				parameter_hints_prefix = "",
				other_hints_prefix = "",
			},
		},
		server = {
			capabilities = capabilities,
			on_attach = on_attach,
			cmd = { "rustup", "run", "stable", "rust-analyzer" },
			filetypes = { "rust" },
			root_dir = lsp.util.root_pattern("Cargo.toml"),
			settings = {
				["rust-analyzer"] = {
					checkOnSave = {
						command = "clippy",
						references = {
							adt = {
								enable = true
							}
						}
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
	}
	require("rust-tools").setup(opts)
end
return M
