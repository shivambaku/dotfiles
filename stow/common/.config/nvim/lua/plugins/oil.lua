return {
	"stevearc/oil.nvim",
	config = function()
		require("oil").setup({
			view_options = {
				show_hidden = false,
				is_hidden_file = require("custom.oil_git_visibility").is_hidden,
			},
			skip_confirm_for_simple_edits = true,
		})

		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	end,
}
