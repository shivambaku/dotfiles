return {
	"HakonHarnes/img-clip.nvim",
	event = "VeryLazy",
	keys = {
		{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
	},
	config = function()
		require("img-clip").setup({
			prompt_for_file_name = false,
		})
	end,
}
