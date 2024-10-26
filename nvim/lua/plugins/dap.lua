return {
	"mfussenegger/nvim-dap",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-neotest/nvim-nio",
		"williamboman/mason.nvim",
		"julianolf/nvim-dap-lldb",
	},
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
		vim.keymap.set("n", "<F5>", dap.continue, { desc = "Continue" })
		vim.keymap.set("n", "<F17>", dap.terminate, { desc = "Terminate" })
		vim.keymap.set("n", "<F6>", dap.pause, { desc = "Pause" })
		vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
		vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step over" })
		vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step into" })
		vim.keymap.set("n", "<s-F11>", dap.step_out, { desc = "Step out" })

		vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939" })
		vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })
		vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint" })
		vim.fn.sign_define(
			"DapStopped",
			{ text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
		)

		require("nvim-dap-virtual-text").setup()
		require("mason").setup()

		local dap_lldb = require("dap-lldb")
		dap_lldb.setup()
	end,
}
