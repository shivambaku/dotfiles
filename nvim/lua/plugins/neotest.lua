return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"rouge8/neotest-rust",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		local neotest = require("neotest")
		neotest.setup({
			adapters = {
				require("neotest-rust"),
			},
		})

		vim.keymap.set("n", "<leader>tr", neotest.run.run, { desc = "Run test" })
		vim.keymap.set("n", "<leader>ts", neotest.run.stop, { desc = "Stop test" })
		vim.keymap.set("n", "<leader>to", neotest.output.open, { desc = "Show output" })
		vim.keymap.set("n", "<leader>tt", neotest.summary.toggle, { desc = "Show test summary" })
	end,
}
