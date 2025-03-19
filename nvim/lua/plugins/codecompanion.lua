return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("codecompanion").setup({
			strategies = {
				chat = { adapter = "ollama" },
				inline = { adapter = "ollama" },
			},
			display = {
				chat = {
					window = {
						position = "right",
					},
				},
			},
		})

		local opts = function(desc)
			return { desc = desc, noremap = true, silent = true }
		end

		vim.keymap.set({ "n", "v" }, "<leader>ia", "<cmd>CodeCompanionActions<cr>", opts("Companion actions"))
		vim.keymap.set({ "n", "v" }, "<leader>in", "<cmd>CodeCompanionChat<cr>", opts("Open a new assistant chat"))
		vim.keymap.set({ "n", "v" }, "<leader>ic", "<cmd>CodeCompanionChat Toggle<cr>", opts("Toggle assistant chat"))
		vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", opts("Companion add to chat"))

		-- Expand 'cc' into 'CodeCompanion' in the command line
		vim.cmd([[cab cc CodeCompanion]])
	end,
}
