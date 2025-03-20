return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "" },
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "branch", "location" },
				lualine_y = { require("custom.lualine-codecompanion") },
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
