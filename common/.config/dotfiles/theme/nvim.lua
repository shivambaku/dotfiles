local colors = {
	base = "#05070A",
	mantle = "#0A0D11",
	surface0 = "#13181E",
	surface1 = "#1B232B",
	surface2 = "#223246",
	selection = "#223246",
	border = "#3A4652",
	text = "#E1E8EC",
	secondary = "#B8C3CA",
	muted = "#7D8992",
	blue = "#7FB5E5",
	ice = "#A9CCE8",
	distant_blue = "#6F9FD0",
	cyan = "#78BBC4",
	green = "#9CB68E",
	violet = "#B3A1D6",
	peach = "#D0A17E",
	warning = "#D3B26F",
	error = "#D9858B",
}

return {
	colors = colors,
	highlights = {
		dap_breakpoint = { ctermbg = 0, fg = colors.error },
		dap_stopped = { ctermbg = 0, fg = colors.green, bg = colors.selection },
		flash_current = { bold = true, fg = colors.error },
		multicursor = { fg = colors.base, bg = colors.blue },
	},
	lualine = {
		normal = {
			a = { fg = colors.base, bg = colors.blue, gui = "bold" },
			b = { fg = colors.secondary, bg = colors.surface1 },
			c = { fg = colors.secondary, bg = colors.mantle },
		},
		insert = {
			a = { fg = colors.base, bg = colors.green, gui = "bold" },
			b = { fg = colors.secondary, bg = colors.surface1 },
			c = { fg = colors.secondary, bg = colors.mantle },
		},
		visual = {
			a = { fg = colors.base, bg = colors.violet, gui = "bold" },
			b = { fg = colors.secondary, bg = colors.surface1 },
			c = { fg = colors.secondary, bg = colors.mantle },
		},
		replace = {
			a = { fg = colors.base, bg = colors.error, gui = "bold" },
			b = { fg = colors.secondary, bg = colors.surface1 },
			c = { fg = colors.secondary, bg = colors.mantle },
		},
		command = {
			a = { fg = colors.base, bg = colors.warning, gui = "bold" },
			b = { fg = colors.secondary, bg = colors.surface1 },
			c = { fg = colors.secondary, bg = colors.mantle },
		},
		terminal = {
			a = { fg = colors.base, bg = colors.cyan, gui = "bold" },
			b = { fg = colors.secondary, bg = colors.surface1 },
			c = { fg = colors.secondary, bg = colors.mantle },
		},
		inactive = {
			a = { fg = colors.muted, bg = colors.mantle },
			b = { fg = colors.muted, bg = colors.mantle },
			c = { fg = colors.muted, bg = colors.mantle },
		},
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
					custom_highlights = function()
						return {
							PmenuSel = { fg = colors.text, bg = colors.selection, style = { "bold" } },
							PmenuKindSel = { fg = colors.text, bg = colors.selection, style = { "bold" } },
							PmenuExtraSel = { fg = colors.text, bg = colors.selection, style = { "bold" } },
							BlinkCmpMenuSelection = { fg = colors.text, bg = colors.selection, style = { "bold" } },
							TelescopeResultsNormal = { fg = colors.muted },
							TelescopeSelection = { fg = colors.text, bg = colors.selection, style = { "bold" } },
							TelescopeSelectionCaret = { fg = colors.text, bg = colors.selection },
							HarpoonNormal = { fg = colors.muted },
							HarpoonSelection = { fg = colors.text, bg = colors.selection, style = { "bold" } },
						}
					end,
					color_overrides = {
						mocha = {
							rosewater = colors.ice,
							flamingo = colors.error,
							pink = colors.violet,
							mauve = colors.violet,
							red = colors.error,
							maroon = colors.error,
							peach = colors.peach,
							yellow = colors.warning,
							green = colors.green,
							teal = colors.cyan,
							sky = colors.ice,
							sapphire = colors.distant_blue,
							blue = colors.blue,
							lavender = colors.ice,
							text = colors.text,
							subtext1 = colors.secondary,
							subtext0 = colors.secondary,
							overlay2 = colors.muted,
							overlay1 = colors.muted,
							overlay0 = colors.border,
							surface2 = colors.surface2,
							surface1 = colors.surface1,
							surface0 = colors.surface0,
							base = colors.base,
							mantle = colors.mantle,
							crust = colors.base,
						},
					},
				})

				vim.cmd.colorscheme("catppuccin")
				vim.api.nvim_set_hl(0, "WinSeparator", { fg = colors.border })
			end,
		},
	},
}
