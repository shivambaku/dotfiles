return {
	"nvim-lualine/lualine.nvim",
	config = function()
		local theme = require("theme")

		require("lualine").setup({
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "" },
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "branch", "location" },
				lualine_y = { { "searchcount", maxcount = 999999 } },
				lualine_z = {
					function()
						return require("faf").statusline()
					end,
				},
			},
			options = {
				theme = theme.lualine,
				icons_enabled = false,
				section_separators = "",
				component_separators = "",
				globalstatus = true,
			},
		})
	end,
}
