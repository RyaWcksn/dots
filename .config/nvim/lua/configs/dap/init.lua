local dap, dapui = require("dap"), require("dapui")
require('dap.ext.vscode').load_launchjs(nil, {})
require('dap').set_log_level('TRACE') -- Helps when configuring DAP, see logs with :DapShowLog
dapui.setup()

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
}


dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
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
