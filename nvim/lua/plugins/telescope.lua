return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-telescope/telescope-live-grep-args.nvim",
	},
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				mappings = {
					i = {
						["<esc>"] = require("telescope.actions").close,
					},
				},
			},
		})

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
		vim.keymap.set("n", "<leader>fp", builtin.git_files, { desc = "Find files (excluding git ingores)" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help" })
		vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Find references" })
		vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Find symbols" })
		vim.keymap.set("n", "<leader>fx", builtin.diagnostics, { desc = "Diagnostics" })

		telescope.load_extension("live_grep_args")
		vim.keymap.set("n", "<leader>fg", function()
			telescope.extensions.live_grep_args.live_grep_args()
		end, { desc = "Live grep" })
	end,
}
