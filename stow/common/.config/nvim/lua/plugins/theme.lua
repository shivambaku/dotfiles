return {
	"catppuccin/nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			no_italic = true,
			color_overrides = {
				mocha = {
					base = "#0a0c10",
					mantle = "#0a0c10",
					crust = "#0a0c10",
				},
			},
		})

		vim.cmd.colorscheme("catppuccin")
		vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#7aa2f7" })
	end,
}
