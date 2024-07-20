local capabilities = vim.lsp.protocol.make_client_capabilities()
local jdtls = require('jdtls')
require('dap.ext.vscode').load_launchjs()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true


local home = os.getenv("HOME")
local jdtls_path = home .. "/Documents/jdtls"
local lombok_path = home .. "/Documents/jdtls/lombok.jar"
local jar_path = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')


local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.expand('$HOME/Sandbox/workspace/') .. project_name
os.execute("mkdir -p " .. workspace_dir)

local function get_config_dir()
	if vim.fn.has('linux') == 1 then
		return jdtls_path .. '/config_linux'
	elseif vim.fn.has('mac') == 1 then
		return jdtls_path .. '/config_mac'
	else
		return jdtls_path .. '/config_win'
	end
end

local jdlts_cmd = {
	'java',
	'-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=1044',
	'-Dosgi.bundles.defaultStartLevel=4',
	'-Declipse.product=org.eclipse.jdt.ls.core.product',
	'-Dlog.protocol=true',
	'-Dlog.level=ALL',
	'-Xmx1g',
	"-javaagent:" .. lombok_path,
	'--add-modules=ALL-SYSTEM',
	'--add-opens', 'java.base/java.util=ALL-UNNAMED',
	'--add-opens', 'java.base/java.lang=ALL-UNNAMED',
	'-jar', jar_path,
	'-configuration', get_config_dir(),
	'-data', workspace_dir,
	'--add-modules=ALL-SYSTEM --add-opens java.base/java.util=ALL-UNNAMED --add-opens java.base/java.lang=ALL-UNNAMED'
}



local on_attach = function(client, bufnr)
	--print(vim.inspect(client.server_capabilities))
	vim.o.updatetime = 250
	vim.cmd [[autocmd! CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})]]

	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(bufnr, true)

		local group = vim.api.nvim_create_augroup("ShowInlayHint", { clear = true })
		vim.api.nvim_create_autocmd("InsertEnter",
			{
				group = group,
				callback = function()
					vim.lsp.inlay_hint.enable(bufnr, true)
				end,
			})
		vim.api.nvim_create_autocmd("InsertLeave",
			{
				group = group,
				callback = function()
					vim.lsp.inlay_hint.enable(bufnr, false)
				end,
			})
	end

	if client.server_capabilities.codeLensProvider then
		vim.lsp.codelens.refresh()
	end

	if client.server_capabilities.documentHightlightProvider then
		vim.api.nvim_exec(
			[[
				hi LspReferenceRead cterm=bold ctermbg=red guibg=#282f45
				hi LspReferenceText cterm=bold ctermbg=red guibg=#282f45
				hi LspReferenceWrite cterm=bold ctermbg=red guibg=#282f45
				augroup lsp_document_highlight
				autocmd! * <buffer>
				autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
				autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
				augroup END
			]],
			false
		)
	end
	if client.server_capabilities.signatureHelpProvider then
		vim.cmd [[autocmd! CursorHoldI * lua vim.lsp.buf.signature_help(nil, {focus=false})]]
		vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
			vim.lsp.handlers.signature_help,
			{
				border = 'rounded',
				close_events = { "CursorMoved", "BufHidden", "InsertCharPre" },
			}
		)
	end

	vim.lsp.handlers['window/showMessage'] = function(_, result, ctx)
		local lvl = ({
			'ERROR',
			'WARN',
			'INFO',
			'DEBUG',
		})[result.type]
		notify({ result.message }, lvl, {
			title = 'LSP | ' .. client.name,
			timeout = 10000,
			keep = function()
				return lvl == 'ERROR' or lvl == 'WARN'
			end,
		})
	end

	vim.lsp.handlers["textDocument/references"] = function(_, _, _)
		require("telescope.builtin").lsp_references()
	end
	local _, _ = pcall(vim.lsp.codelens.refresh)
	require('jdtls').setup_dap({ hotcodereplace = 'auto' })
	local status_ok, jdtls_dap = pcall(require, "jdtls.dap")
	if status_ok then
		jdtls_dap.setup_dap_main_class_configs()
	end

	vim.notify('lsp server (jdtls) attached')
end

local config = {
	-- cmd = { 'jdtls' },
	cmd = jdlts_cmd,
	root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
	single_file_support = true,
	on_attach = on_attach,
	settings = {
		flags = {
			allow_incremental_sync = true,
		},
		init_options = {
		},
	},
	signatureHelp = { enabled = true },
	contentProvider = { preferred = 'fernflower' },
	sources = {
		organizeImports = {
			starThreshold = 9999,
			staticStarThreshold = 9999,
		},
	},
	eclipse = {
		downloadSources = true,
	},
	maven = {
		downloadSources = true,
	},
	implementationsCodeLens = {
		enabled = true,
	},
	referencesCodeLens = {
		enabled = true,
	},
	references = {
		includeDecompiledSources = true,
	},
	capabilities = capabilities,
	inlayHints = {
		parameterNames = {
			enabled = "all", -- literals, all, none
		},
	},
	completion = {
		favoriteStaticMembers = {
			"org.hamcrest.MatcherAssert.assertThat",
			"org.hamcrest.Matchers.*",
			"org.hamcrest.CoreMatchers.*",
			"org.junit.jupiter.api.Assertions.*",
			"java.util.Objects.requireNonNull",
			"java.util.Objects.requireNonNullElse",
			"org.mockito.Mockito.*",
			"java.util.stream.Collectors.*",
			"org.assertj.core.api.Assertions.*"
		},
		filteredTypes = {
			"com.sun.*",
			"io.micrometer.shaded.*",
			"java.awt.*",
			"jdk.*", "sun.*",
		},
	},
	codeGeneration = {
		toString = {
			template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
		},
		hashCodeEquals = {
			useJava7Objects = true,
		},
		useBlocks = true,
	},
	extendedClientCapabilities = extendedClientCapabilities
}


jdtls.start_or_attach(config)
