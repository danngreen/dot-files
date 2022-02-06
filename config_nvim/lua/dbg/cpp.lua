local dap = require("dap")

dap.adapters.lldb = {
	type = "executable",
	attach = { pidProperty = "pid", pidSelect = "ask" },
	command = "lldb-vscode",
	name = "lldb",
	env = { LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES" },
}

dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = '/Users/dann/bin/cpptools-osx-arm64/extension/debugAdapters/bin/OpenDebugAD7',
}


dap.configurations.cpp = {
	{
		name = "Launch",
		-- type = "cppdbg",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		--cwd = "${workspaceFolder}",
		cwd = "/Users/dann/4ms/vcv/Rack-x86",
		stopOnEntry = true,
		args = {},
		runInTerminal = false,
	},
	  -- {
		-- name = 'Attach to gdbserver :1234',
		-- type = 'cppdbg',
		-- request = 'launch',
		-- MIMode = 'gdb',
		-- MIDebuggerServerAddress = 'localhost:1234',
		-- MIDebuggerPath = '/opt/homebrew/opt/llvm/bin/lldb', --'/usr/bin/gdb',
		-- cwd = '${workspaceFolder}',
		-- program = function()
		  -- return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		-- end,
	  -- },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

