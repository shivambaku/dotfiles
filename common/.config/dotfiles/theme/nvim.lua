local colors = {
	base = "#0a0c10",
	win_separator = "#7aa2f7",
	dap_breakpoint = "#993939",
	dap_stopped = "#98c379",
	dap_stopped_background = "#31353f",
	flash_current = "#ff0000",
	multicursor_foreground = "#12131b",
	multicursor_background = "#868dac",
}

return {
	colors = colors,
	highlights = {
		dap_breakpoint = { ctermbg = 0, fg = colors.dap_breakpoint },
		dap_stopped = { ctermbg = 0, fg = colors.dap_stopped, bg = colors.dap_stopped_background },
		flash_current = { bold = true, fg = colors.flash_current },
		multicursor = { fg = colors.multicursor_foreground, bg = colors.multicursor_background },
	},
	plugin = {
		{
			"catppuccin/nvim",
			lazy = false,
			priority = 1000,
			config = function()
				require("catppuccin").setup({
					no_italic = true,
					transparent_background = true,
					float = {
						transparent = true,
					},
					color_overrides = {
						mocha = {
							base = colors.base,
							mantle = colors.base,
							crust = colors.base,
						},
					},
				})

				vim.cmd.colorscheme("catppuccin")
				vim.api.nvim_set_hl(0, "WinSeparator", { fg = colors.win_separator })
			end,
		},
	},
}
