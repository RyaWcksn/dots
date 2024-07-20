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



local M = {}

M.jdtls = function(capabilities, on_attach)
	local setup = {
		capabilities = capabilities,
		on_attach = on_attach,
		cmd = jdlts_cmd,
		filetypes = { "java" },
		root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
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

	return setup
end

return M
