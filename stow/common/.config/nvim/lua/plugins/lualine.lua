return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require("lualine").setup({
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "" },
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "branch", "location" },
				lualine_y = { "" },
				lualine_z = { "" },
			},
			options = {
				icons_enabled = false,
				section_separators = "",
				component_separators = "",
				globalstatus = true,
			},
		})
	end,
}
