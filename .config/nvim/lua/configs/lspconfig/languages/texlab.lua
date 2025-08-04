local M = {}

M.texlab = function(capabilities)
	local setup = {
		cmd = { "texlab" },
		filetypes = { "tex", "plaintex", "bib" },
		single_file_support = true,
		capabilities = capabilities,
		settings = {
			texlab = {
				auxDirectory = ".",
				bibtexFormatter = "texlab",
				build = {
					args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
					executable = "latexmk",
					forwardSearchAfter = false,
					onSave = false
				},
				chktex = {
					onEdit = false,
					onOpenAndSave = false
				},
				diagnosticsDelay = 300,
				formatterLineLength = 80,
				forwardSearch = {
					args = {}
				},
				latexFormatter = "latexindent",
				latexindent = {
					modifyLineBreaks = false
				}
			}
		},
	}

	return setup
end


return M
