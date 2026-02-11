-- https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki
return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		require("render-markdown").setup({
			file_types = { "markdown" },
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
					youtube = { icon = "" },
				},
			},
		})
	end,
}
