return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-telescope/telescope-live-grep-args.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		"debugloop/telescope-undo.nvim",
	},
	event = "VeryLazy",
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		telescope.setup({
			defaults = {
				mappings = {
					i = {
						["<esc>"] = actions.close,
					},
				},
			},
			extensions = {
				fzf = {},
				["ui-select"] = {},
			},
		})

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
		vim.keymap.set("n", "<leader>fa", function()
			builtin.find_files({
				find_command = {
					"rg",
					"--files",
					"--hidden",
					"--glob=!**/.git/*",
					"--glob=!**/*-lock.json",
				},
			})
		end, { desc = "Find all files" })
		vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Find files (excluding git ingores)" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help" })
		vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Find diagnostics" })
		vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Find references" })
		vim.keymap.set("n", "<leader>fo", builtin.lsp_document_symbols, { desc = "Find symbols" })
		vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Go to definition" })

		telescope.load_extension("live_grep_args")
		vim.keymap.set("n", "<leader>fs", telescope.extensions.live_grep_args.live_grep_args, { desc = "Search" })

		telescope.load_extension("undo")
		vim.keymap.set("n", "<leader>fu", telescope.extensions.undo.undo, { desc = "Undo history" })

		telescope.load_extension("ui-select")
	end,
}
