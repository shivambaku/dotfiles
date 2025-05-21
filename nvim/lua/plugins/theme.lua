return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("tokyonight").setup({
			styles = {
				keywords = { italic = false },
			},
		})
		vim.cmd.colorscheme("tokyonight-night")
		vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#7aa2f7" })
	end,
}
