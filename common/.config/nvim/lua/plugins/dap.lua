return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-neotest/nvim-nio",
		"williamboman/mason.nvim",
		"julianolf/nvim-dap-lldb",
	},
	keys = { "<leader>dd", "<leader>db", "<F53>", "<F54>", "<F57>", "<F58>", "<F59>", "<s-F11>" },
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		dapui.setup()

		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close

		vim.keymap.set("n", "<leader>dd", dapui.toggle, { desc = "Toggle debugger UI" })
		vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
		vim.keymap.set("n", "<leader>dc", dap.run_to_cursor, { desc = "Run to cursor" })
		vim.keymap.set("n", "<leader>dK", require("dap.ui.widgets").hover, { desc = "Inspect" })
		vim.keymap.set("n", "<leader>dC", dap.clear_breakpoints, { desc = "Clear all breakpoints" })
		vim.keymap.set("n", "<F53>", dap.continue, { desc = "Continue" }) -- Option-F5
		vim.keymap.set("n", "<F17>", dap.terminate, { desc = "Terminate" }) -- Shift-F5
		vim.keymap.set("n", "<F54>", dap.pause, { desc = "Pause" }) -- Option-F6
		vim.keymap.set("n", "<F57>", dap.toggle_breakpoint, { desc = "Toggle breakpoint" }) -- Option-F9
		vim.keymap.set("n", "<F58>", dap.step_over, { desc = "Step over" }) -- Option-F10
		vim.keymap.set("n", "<F59>", dap.step_into, { desc = "Step into" }) -- Option-F11
		vim.keymap.set("n", "<s-F11>", dap.step_out, { desc = "Step out" }) -- Shift-F11

		vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939" })
		vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })
		vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint" })
		vim.fn.sign_define(
			"DapStopped",
			{ text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
		)

		require("nvim-dap-virtual-text").setup()

		dap.adapters.coreclr = {
			type = "executable",
			command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
			args = { "--interpreter=vscode" },
		}

		dap.configurations.cs = {
			{
				type = "coreclr",
				name = "Launch .NET",
				request = "launch",
				program = function()
					return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopAtEntry = false,
			},
		}

		local dap_lldb = require("dap-lldb")
		dap_lldb.setup()
	end,
}
