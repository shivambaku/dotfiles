return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "" },
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "branch", "diff", "location" },
				lualine_y = { "" },
				lualine_z = { "" },
			},
			options = {
				section_separators = "",
				component_separators = "",
				globalstatus = true,
			},
		})
	end,
}
