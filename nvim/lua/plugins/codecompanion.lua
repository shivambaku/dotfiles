return {
	"olimorris/codecompanion.nvim",
	event = "VeryLazy",
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
			adapters = {
				ollama = function()
					return require("codecompanion.adapters").extend("openai_compatible", {
						env = {
							url = "http://localhost:1234",
						},
						schema = {
							model = {
								default = "qwen2.5-coder-7b-instruct-mlx@4bit",
							},
							temperature = {
								default = 0.2,
							},
						},
					})
				end,
			},
			display = {
				chat = {
					auto_scroll = false,
					window = {
						position = "right",
						opts = {
							-- wrap = false,
						},
					},
				},
				diff = {
					enabled = true,
					provider = "mini_diff",
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
