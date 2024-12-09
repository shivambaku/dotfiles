return {
	"stevearc/oil.nvim",
	opts = {},
	config = function()
		require("oil").setup({
			view_options = {
				show_hidden = true,
			},
			skip_confirm_for_simple_edits = true,
		})

		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	end,
}
