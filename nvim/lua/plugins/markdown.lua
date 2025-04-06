return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		require("render-markdown").setup({
			file_types = { "markdown", "codecompanion" },
			win_options = {
				wrap = { default = false, rendered = false },
			},
			sign = {
				enabled = false,
			},
			heading = {
				icons = { "", "", "", "", "", "" },
				position = "inline",
				backgrounds = {},
			},
			link = {
				image = "",
				email = "",
				hyperlink = "",
				custom = {
					web = { icon = "" },
				},
			},
		})
	end,
}
