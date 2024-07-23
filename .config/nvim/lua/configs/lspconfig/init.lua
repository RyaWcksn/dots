local lsp = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
}

vim.lsp.set_log_level("debug")

local signs = { Error = "E ", Warn = " ", Hint = "H ", Info = "I " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end


local config = {
	virtual_text = {
		source = "always", -- Or "if_many"
		prefix = '▎', -- Could be '●', '▎', 'x'
	},
	signs = {
		active = signs,
	},
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
}
vim.diagnostic.config(config)

signature_help_window_opened = false
signature_help_forced = false
function my_signature_help_handler(handler)
	return function(...)
		if _G.signature_help_forced and _G.signature_help_window_opened then
			_G.signature_help_forced = false
			return handler(...)
		end
		if _G.signature_help_window_opened then
			return
		end
		local fbuf, fwin = handler(...)
		_G.signature_help_window_opened = true
		vim.api.nvim_exec("autocmd WinClosed " .. fwin .. " lua _G.signature_help_window_opened=false", false)
		return fbuf, fwin
	end
end

function force_signature_help()
	_G.signature_help_forced = true
	vim.lsp.buf.signature_help()
end

local key = vim.keymap.set
-- These mappings allow to focus on the floating window when opened.
key('n', '<C-k>', '<cmd>lua force_signature_help()<CR>', opts)
key('i', '<C-k>', '<cmd>lua force_signature_help()<CR>', opts)

local on_attach = function(client, bufnr)
	vim.o.updatetime = 250
	vim.api.nvim_create_autocmd("CursorHold", {
		buffer = bufnr,
		callback = function()
			local opts = {
				focusable = false,
				close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
				border = 'rounded',
				source = 'always',
				prefix = ' ',
				scope = 'cursor',
			}
			vim.diagnostic.open_float(nil, opts)
		end
	})

	if client.server_capabilities.inlayHintProvider then
		vim.api.nvim_create_autocmd({ "InsertEnter" }, {
			buffer = bufnr,
			callback = function()
				vim.lsp.inlay_hint.enable(true)
			end
		})
		vim.api.nvim_create_autocmd({ "InsertLeave" }, {
			buffer = bufnr,
			callback = function()
				vim.lsp.inlay_hint.enable(false)
			end
		})
	end

	if client.server_capabilities.codeLensProvider then
		-- vim.lsp.codelens.on_codelens = function(err, results, ctx, _)
		-- 	local clients = vim.lsp.get_clients()
		-- 	for _, client_id in ipairs(clients) do
		-- 		print(client_id.id)
		-- 	end
		-- 	if err then
		-- 		vim.notify("CodeLens error: " .. err.message, vim.log.levels.ERROR)
		-- 		return
		-- 	end

		-- 	if not results or vim.tbl_isempty(results) then
		-- 		vim.notify("No CodeLens results", vim.log.levels.INFO)
		-- 		return
		-- 	end

		-- 	-- Iterate over each CodeLens item in the result
		-- 	for _, client_id in ipairs(clients) do
		-- 		vim.lsp.codelens.display(results, bufnr, client_id.id)
		-- 		vim.lsp.codelens.display
		-- 	end
		-- end
		vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
			buffer = bufnr,
			callback = function()
				vim.lsp.codelens.refresh()
			end
		})
	end

	if client.server_capabilities.documentFormattingProvider then
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format()
			end
		})
	end

	if client.server_capabilities.signatureHelpProvider then
		vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
			my_signature_help_handler(vim.lsp.handlers.signature_help),
			{}
		)
	end
	-- if client.server_capabilities.documentSymbolProvider then
	-- 	local ns_id = vim.api.nvim_create_namespace("lsp_references_count")

	-- 	local function show_references_count(bufnr, row, col)
	-- 		local params = { textDocument = vim.lsp.util.make_text_document_params(), position = { line = row, character = col } }
	-- 		vim.lsp.buf_request(bufnr, 'textDocument/references', params, function(err, result, ctx, config)
	-- 			print(err)
	-- 			print(result)
	-- 			if err ~= nil or result == nil then
	-- 				print("No references found")
	-- 				return
	-- 			end
	-- 			local count = #result

	-- 			vim.api.nvim_buf_clear_namespace(bufnr, ns_id, row, row + 1)

	-- 			vim.api.nvim_buf_set_extmark(bufnr, ns_id, row, col, {
	-- 				virt_text = { { "[" .. count .. " references]", "WarningMsg" } }, -- You can change the highlight group
	-- 				virt_text_pos = 'eol'
	-- 			})
	-- 		end)
	-- 	end

	-- 	local function set_virtual_text_for_all(bufnr)
	-- 		vim.lsp.buf_request(bufnr, 'textDocument/documentSymbol',
	-- 			{ textDocument = vim.lsp.util.make_text_document_params() },
	-- 			function(err, result, ctx, config)
	-- 				if err then
	-- 					vim.notify("Got error " .. err.message, vim.log.levels.ERROR)
	-- 					return
	-- 				end
	-- 				if not result then
	-- 					vim.notify("Got no result from buf request ", vim.log.levels.ERROR)
	-- 					return
	-- 				end
	-- 				for _, symbol in ipairs(result) do
	-- 					if symbol.kind == 6 or symbol.kind == 13 then -- Interface (6) or Variable (13)
	-- 						local range = symbol.selectionRange
	-- 						local row = range.start.line
	-- 						local col = range.start.character
	-- 						show_references_count(bufnr, row, col)
	-- 					end
	-- 				end
	-- 			end)
	-- 	end
	-- 	set_virtual_text_for_all(bufnr)

	-- 	vim.api.nvim_create_autocmd({ "BufWritePost", "TextChanged", "BufEnter" }, {
	-- 		buffer = bufnr,
	-- 		callback = function()
	-- 			set_virtual_text_for_all(bufnr)
	-- 		end,
	-- 	})
	-- end

	if client.server_capabilities.definitionProvider then
		vim.lsp.handlers["textDocument/definition"] = function(_, result, ctx)
			if not result or vim.tbl_isempty(result) then
				return vim.api.nvim_echo({ { "Lsp: Could not find definition" } }, false, {})
			end

			if vim.tbl_islist(result) then
				local results = vim.lsp.util.locations_to_items(result, client.offset_encoding)
				local lnum, filename = results[1].lnum, results[1].filename
				for _, val in pairs(results) do
					if val.lnum ~= lnum or val.filename ~= filename then
						return require("telescope.builtin").lsp_definitions()
					end
				end
				vim.lsp.util.jump_to_location(result[1], client.offset_encoding, false)
			else
				vim.lsp.util.jump_to_location(result, client.offset_encoding, false)
			end
		end
	end


	if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_set_hl(bufnr, 'LspReferenceRead', { link = 'Search' })
		vim.api.nvim_set_hl(bufnr, 'LspReferenceText', { link = 'Search' })
		vim.api.nvim_set_hl(bufnr, 'LspReferenceWrite', { link = 'Search' })
		vim.api.nvim_create_augroup('lsp_document_highlight', {
			clear = false
		})
		vim.api.nvim_clear_autocmds({
			buffer = bufnr,
			group = 'lsp_document_highlight',
		})
		vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
			group = 'lsp_document_highlight',
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
			group = 'lsp_document_highlight',
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end

	if not client.server_capabilities.semanticTokensProvider then
		local semantic = client.config.capabilities.textDocument.semanticTokens
		client.server_capabilities.semanticTokensProvider = {
			full = true,
			legend = {
				tokenTypes = semantic.tokenTypes,
				tokenModifiers = semantic.tokenModifiers,
			},
			range = true,
		}
	end
end
vim.lsp.util.apply_text_document_edit = function(text_document_edit, index, offset_encoding)
	local text_document = text_document_edit.textDocument
	local bufnr = vim.uri_to_bufnr(text_document.uri)
	if offset_encoding == nil then
		vim.notify_once('apply_text_document_edit must be called with valid offset encoding', vim.log.levels
			.WARN)
	end

	vim.lsp.util.apply_text_edits(text_document_edit.edits, bufnr, offset_encoding)
end

local servers = {
	gopls = require('configs.lspconfig.languages.gopls').gopls(capabilities, on_attach),
	golangci_lint_ls = require('configs.lspconfig.languages.golang-ci').golangci(capabilities, on_attach),
	pyright = require('configs.lspconfig.languages.pyright').pyright(capabilities, on_attach),
	--rust_analyzer = require('configs.lspconfig.languages.rust-analyzer').rust_analyzer(capabilities, on_attach),
	--basedpyright = require('configs.lspconfig.languages.basedpyright').basedpyright(capabilities, on_attach),
	tsserver = require('configs.lspconfig.languages.tsserver').tsserver(capabilities, on_attach),
	tailwindcss = require('configs.lspconfig.languages.tailwindcss').tailwind(capabilities, on_attach),
	lua_ls = require('configs.lspconfig.languages.lua-ls').lua_ls(capabilities, on_attach),
	intelephense = require('configs.lspconfig.languages.intelephense').intelephense(capabilities, on_attach),
	texlab = require('configs.lspconfig.languages.texlab').texlab(capabilities, on_attach),
	kotlin_language_server = require('configs.lspconfig.languages.kotlin').kotlin(capabilities, on_attach),
	terraformls = require('configs.lspconfig.languages.terraformls').terraformls(capabilities, on_attach),
	yamlls = require('configs.lspconfig.languages.yamlls').yamlls(capabilities, on_attach),
	prismals = require('configs.lspconfig.languages.prismals').prismals(capabilities, on_attach),
	-- jdtls = require('configs.lspconfig.languages.jdtls').jdtls(capabilities, on_attach)
	svelte = require('configs.lspconfig.languages.svelte').svelte(capabilities, on_attach),
	clangd = require('configs.lspconfig.languages.clangd').clangd(capabilities, on_attach)
}

require('configs.lspconfig.languages.rust-analyzer').rust_tools(capabilities, on_attach)

for server, cfg in pairs(servers) do
	lsp[server].setup(cfg)
end
