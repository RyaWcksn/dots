local dap = require("dap")
require('dap.ext.vscode').load_launchjs(nil, {})
require('dap').set_log_level('TRACE') -- Helps when configuring DAP, see logs with :DapShowLog

dap.adapters.delve = function(callback, config)
	if config.mode == 'remote' and config.request == 'attach' then
		callback({
			type = 'server',
			host = config.host or '127.0.0.1',
			port = config.port or '38697'
		})
	else
		callback({
			type = 'server',
			port = '${port}',
			executable = {
				command = 'dlv',
				args = { 'dap', '-l', '127.0.0.1:${port}', '--log', '--log-output=dap' },
				detached = vim.fn.has("win32") == 0,
			}
		})
	end
end

dap.configurations.go = {
	{
		type = "delve",
		name = "Debug (Remote binary)",
		request = "launch",
		mode = "exec",
		hostName = "127.0.0.1",
		port = "38697",
		program = function()
			local argument_string = vim.fn.input "Path to binary: "
			vim.notify("Debugging binary: " .. argument_string)
			return vim.fn.split(argument_string, " ", true)[1]
		end,
	},
	{
		type = "delve",
		name = "Debug (Build binary)",
		request = "launch",
		mode = "exec",
		hostName = "127.0.0.1",
		port = "38697",
		program = function()
			local main_go_path = vim.fn.input("Path to main.go: ")
			local debug_name = "debug_dap"
			local cmd = string.format(
				'GOOS=linux GOARCH=amd64 go build -o %s -gcflags=all="-N -l" %s',
				debug_name,
				main_go_path
			)
			vim.notify("Running build command : " .. cmd)
			local ok = os.execute(cmd)
			if ok then
				vim.notify("Debug binary created at : " .. vim.fn.expand('%') .. debug_name)
			end
			vim.notify("Debugging binary: " .. debug_name)

			return debug_name
		end,
	},
	-- {
	-- 	type = "go",
	-- 	name = "Debug",
	-- 	request = "launch",
	-- 	program = "${file}",
	-- 	buildFlags = configs.delve.build_flags,
	-- 	outputMode = configs.delve.output_mode,
	-- },
	-- {
	-- 	type = "go",
	-- 	name = "Debug (Arguments)",
	-- 	request = "launch",
	-- 	program = "${file}",
	-- 	args = get_arguments,
	-- 	buildFlags = configs.delve.build_flags,
	-- 	outputMode = configs.delve.output_mode,
	-- },
	-- {
	-- 	type = "go",
	-- 	name = "Debug (Arguments & Build Flags)",
	-- 	request = "launch",
	-- 	program = "${file}",
	-- 	args = get_arguments,
	-- 	buildFlags = get_build_flags,
	-- 	outputMode = configs.delve.output_mode,
	-- },
	-- {
	-- 	type = "go",
	-- 	name = "Debug Package",
	-- 	request = "launch",
	-- 	program = "${fileDirname}",
	-- 	buildFlags = configs.delve.build_flags,
	-- 	outputMode = configs.delve.output_mode,
	-- },
	-- {
	-- 	type = "go",
	-- 	name = "Attach",
	-- 	mode = "local",
	-- 	request = "attach",
	-- 	processId = filtered_pick_process,
	-- 	buildFlags = configs.delve.build_flags,
	-- },
	-- {
	-- 	type = "go",
	-- 	name = "Debug test",
	-- 	request = "launch",
	-- 	mode = "test",
	-- 	program = "${file}",
	-- 	buildFlags = configs.delve.build_flags,
	-- 	outputMode = configs.delve.output_mode,
	-- },
	-- {
	-- 	type = "go",
	-- 	name = "Debug test (go.mod)",
	-- 	request = "launch",
	-- 	mode = "test",
	-- 	program = "./${relativeFileDirname}",
	-- 	buildFlags = configs.delve.build_flags,
	-- 	outputMode = configs.delve.output_mode,
	-- },
}


vim.fn.sign_define("DapBreakpoint", { text = "B=", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "S=", texthl = "", linehl = "", numhl = "" })

dap.configurations.scala = {
	{
		type = "scala",
		request = "launch",
		name = "RunOrTest",
		metals = {
			runType = "runOrTestFile",
			--args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
		},
	},
	{
		type = "scala",
		request = "launch",
		name = "Test Target",
		metals = {
			runType = "testTarget",
		},
	},
}
