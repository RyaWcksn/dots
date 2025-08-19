local capabilities = vim.lsp.protocol.make_client_capabilities()

vim.lsp.set_log_level(vim.log.levels.ERROR)

local signs = { Error = "E ", Warn = "W ", Hint = "H ", Info = "I " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end


local config = {
	virtual_text = {
		source = "always", -- Or "if_many"
		prefix = '>', -- Could be '●', '▎', 'x'
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
	},
}
vim.diagnostic.config(config)


-- Init servers config
vim.lsp.config.gopls = require('configs.lspconfig.languages.gopls').gopls(capabilities)
vim.lsp.config.golangci_lint_ls = require('configs.lspconfig.languages.golang-ci').golangci(capabilities)
vim.lsp.config.lua_ls = require('configs.lspconfig.languages.lua-ls').lua_ls(capabilities)
vim.lsp.config.rust_analyzer = require('configs.lspconfig.languages.rust-analyzer').rust_analyzer(capabilities)
vim.lsp.config.ts_ls = require('configs.lspconfig.languages.tsserver').tsserver(capabilities)
vim.lsp.config.tailwindcss = require('configs.lspconfig.languages.tailwindcss').tailwind(capabilities)
vim.lsp.config.texlab = require('configs.lspconfig.languages.texlab').texlab(capabilities)

local servers = {
	'gopls',
	'golangci_lint_ls',
	'lua_ls',
	'tailwindcss',
	'ts_ls',
	'rust_analyzer',
	'texlab',
}


vim.lsp.enable(servers)

vim.api.nvim_create_user_command("LspStart", function()
	vim.cmd.e()
end, { desc = "Starts LSP clients in the current buffer" })

vim.api.nvim_create_user_command("LspStop", function(opts)
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		if opts.args == "" or opts.args == client.name then
			client:stop(true)
			vim.notify(client.name .. ": stopped")
		end
	end
end, {
	desc = "Stop all LSP clients or a specific client attached to the current buffer.",
	nargs = "?",
	complete = function(_, _, _)
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		local client_names = {}
		for _, client in ipairs(clients) do
			table.insert(client_names, client.name)
		end
		return client_names
	end,
})

vim.api.nvim_create_user_command("LspRestart", function()
	local detach_clients = {}
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		client:stop(true)
		if vim.tbl_count(client.attached_buffers) > 0 then
			detach_clients[client.name] = { client, vim.lsp.get_buffers_by_client_id(client.id) }
		end
	end
	local timer = vim.uv.new_timer()
	if not timer then
		return vim.notify("Servers are stopped but havent been restarted")
	end
	timer:start(
		100,
		50,
		vim.schedule_wrap(function()
			for name, client in pairs(detach_clients) do
				local client_id = vim.lsp.start(client[1].config, { attach = false })
				if client_id then
					for _, buf in ipairs(client[2]) do
						vim.lsp.buf_attach_client(buf, client_id)
					end
					vim.notify(name .. ": restarted")
				end
				detach_clients[name] = nil
			end
			if next(detach_clients) == nil and not timer:is_closing() then
				timer:close()
			end
		end)
	)
end, {
	desc = "Restart all the language client(s) attached to the current buffer",
})

vim.api.nvim_create_user_command("LspLog", function()
	vim.cmd.vsplit(vim.lsp.log.get_filename())
end, {
	desc = "Get all the lsp logs",
})

vim.api.nvim_create_user_command("LspInfo", function()
	vim.cmd("silent checkhealth neko.lsp")
end, {
	desc = "Get all the information about all LSP attached",
})


vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('neko.lsp', {}),
	callback = function(ev)
		vim.o.updatetime = 250

		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

		local map = function(key, action, desc)
			vim.keymap.set('n', '<leader>' .. key, action, { desc = "LSP: " .. desc })
		end

		if client:supports_method('textDocument/inlayHint') then
			vim.api.nvim_create_autocmd({ "InsertEnter" }, {
				buffer = ev.buf,
				callback = function()
					vim.lsp.inlay_hint.enable(true)
				end
			})
			vim.api.nvim_create_autocmd({ "InsertLeave" }, {
				buffer = ev.buf,
				callback = function()
					vim.lsp.inlay_hint.enable(false)
				end
			})
		end

		if client:supports_method('textDocument/codeLens') then
			vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold" }, {
				buffer = ev.buf,
				callback = function()
					vim.lsp.codelens.refresh()
				end
			})
		end

		if client:supports_method('textDocument/definition') then
			vim.lsp.handlers["textDocument/definition"] = function(_, result, _)
				if not result or vim.tbl_isempty(result) then
					return vim.api.nvim_echo({ { "Lsp: Could not find definition" } }, false, {})
				end

				if vim.isarray(result) then
					local encoding = type(client.offset_encoding) == 'string' and
					    client.offset_encoding or
					    'utf-16'
					local results = vim.lsp.util.locations_to_items(result, encoding)
					local lnum, filename = results[1].lnum, results[1].filename
					for _, val in pairs(results) do
						if val.lnum ~= lnum or val.filename ~= filename then
							return vim.lsp.buf.definition()
						end
					end
					vim.lsp.util.show_document(result[1], { focusable = true }, encoding)
				else
					vim.lsp.util.show_document(result, { focusable = true }, encoding)
				end
			end
		end

		if client:supports_method('textDocument/documentHighlight') then
			vim.api.nvim_set_hl(ev.buf, 'LspReferenceRead', { link = 'Search' })
			vim.api.nvim_set_hl(ev.buf, 'LspReferenceText', { link = 'Search' })
			vim.api.nvim_set_hl(ev.buf, 'LspReferenceWrite', { link = 'Search' })
			vim.api.nvim_create_augroup('lsp_document_highlight', {
				clear = false
			})
			vim.api.nvim_clear_autocmds({
				buffer = ev.buf,
				group = 'lsp_document_highlight',
			})
			vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
				group = 'lsp_document_highlight',
				buffer = ev.buf,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
				group = 'lsp_document_highlight',
				buffer = ev.buf,
				callback = vim.lsp.buf.clear_references,
			})
		end



		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf)
		end

		if not client:supports_method('textDocument/willSaveWaitUntil') and client:supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = vim.api.nvim_create_augroup('neko.lsp', { clear = false }),
				buffer = ev.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end

		vim.api.nvim_create_autocmd("CursorHold", {
			buffer = ev.buf,
			callback = function()
				local opts = {
					focusable = false,
					close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
					border = 'rounded',
					source = 'always',
					prefix = ' ',
					scope = 'line',
				}
				vim.diagnostic.open_float(nil, opts)
			end
		})
vim.o.omnifunc = "v:lua.vim.lsp.omnifunc"

-- Auto trigger completion on typing
vim.api.nvim_create_autocmd("TextChangedI", {
  callback = function()
    local col = vim.fn.col(".") - 1
    if col > 0 then
      vim.fn.complete(col, vim.fn.getcompletion(vim.fn.expand("<cword>"), ''))
    end
  end
})


		map('lf', vim.lsp.buf.format, "Format")
		map('lc', vim.lsp.buf.code_action, "Code Action")
		map('ls', vim.lsp.buf.signature_help, "Signature Help")
		map('ld', vim.lsp.buf.definition, "Goto Definition")
		map('li', vim.lsp.buf.implementation, "Code Implementation")
		map('lw', vim.lsp.buf.references, "Code References")
		map('ll', vim.lsp.codelens.run, "Codelens Run")
		map('lL', vim.lsp.codelens.refresh, "Codelens Refresh")
		map('lr', vim.lsp.buf.rename, "Rename")
		map('lt', vim.diagnostic.setqflist, "Diagnostics")
		map('lo', vim.lsp.buf.document_symbol, "Diagnostics")
	end
})
