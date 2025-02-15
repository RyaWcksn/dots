local lsp = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
}

vim.lsp.set_log_level(vim.log.levels.ERROR)

local signs = { Error = "E ", Warn = "W ", Hint = "H ", Info = "I " }
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

function force_signature_help()
	_G.signature_help_forced = true
	vim.lsp.buf.signature_help()
end

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
		vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold" }, {
			buffer = bufnr,
			callback = function()
				vim.lsp.codelens.refresh()
			end
		})
	end
	if client.server_capabilities.definitionProvider then
		vim.lsp.handlers["textDocument/definition"] = function(_, result, ctx)
			if not result or vim.tbl_isempty(result) then
				return vim.api.nvim_echo({ { "Lsp: Could not find definition" } }, false, {})
			end

			if vim.isarray(result) then
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
	rust_analyzer = require('configs.lspconfig.languages.rust-analyzer').rust_analyzer(capabilities, on_attach),
	ts_ls = require('configs.lspconfig.languages.tsserver').tsserver(capabilities, on_attach),
	tailwindcss = require('configs.lspconfig.languages.tailwindcss').tailwind(capabilities, on_attach),
	lua_ls = require('configs.lspconfig.languages.lua-ls').lua_ls(capabilities, on_attach),
	texlab = require('configs.lspconfig.languages.texlab').texlab(capabilities, on_attach),
	jdtls = require('configs.lspconfig.languages.jdtls').jdtls(capabilities, on_attach),
	nixd = require('configs.lspconfig.languages.nixd').nixd(capabilities, on_attach),
	protols = require('configs.lspconfig.languages.protols').protols(capabilities, on_attach),
	pyright = require('configs.lspconfig.languages.pyright').pyright(capabilities, on_attach),
	dartls = require('configs.lspconfig.languages.dartls').dartls(capabilities, on_attach)
}

require('configs.lspconfig.languages.rust-analyzer').rust_tools(capabilities, on_attach)
for server, cfg in pairs(servers) do
	lsp[server].setup(cfg)
end

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('lsp', { clear = true }),
	callback = function()
		local opt = { silent = true, noremap = true }
		local map = function(key, action, desc)
			vim.keymap.set('n', '<leader>' .. key, action, { desc = "LSP: " .. desc })
		end

		local key = vim.keymap.set
		key('n', '<C-k>', '<cmd>lua force_signature_help()<CR>', opt)
		key('i', '<C-k>', '<cmd>lua force_signature_help()<CR>', opt)

		map("K", vim.lsp.buf.hover, "Hover")
		map('[', vim.diagnostic.goto_prev, "Prev diag")
		map(']', vim.diagnostic.goto_next, "Next diag")
		map('lf', vim.lsp.buf.format, "Format")
		map('lc', vim.lsp.buf.code_action, "Code Action")
		map('ls', vim.lsp.buf.signature_help, "Signature Help")
		map('ld', vim.lsp.buf.definition, "Goto Definition")
		map('li', vim.lsp.buf.implementation, "Code Implementation")
		map('lw', vim.lsp.buf.references, "Code References")
		map('ll', vim.lsp.codelens.run, "Codelens Run")
		map('lL', vim.lsp.codelens.refresh, "Codelens Refresh")
		map('lr', vim.lsp.buf.rename, "Rename")
		map('lr', vim.lsp.buf.rename, "Rename")
		map('lt', vim.diagnostic.setqflist, "Diagnostics")
	end
})
