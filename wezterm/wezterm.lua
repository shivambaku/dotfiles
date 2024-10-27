-- https://wezfurlong.org/wezterm/config/lua/general.html
local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local utils = require("utils")
local utils_vim = require("utils-vim")

local config = {}

-- Window
config.window_decorations = "RESIZE"
config.window_padding = {
	top = 0,
	left = 5,
	right = 5,
	bottom = 0,
}

-- Tabs
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

-- Panes
config.inactive_pane_hsb = {
	saturation = 1.0,
	brightness = 0.5,
}

-- Styling
config.color_scheme = "Tokyo Night"

-- Fonts
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 16

-- Keymapping
config.leader = { key = "k", mods = "CMD", timeout_milliseconds = 2000 }
config.keys = {
	-- Wezterm
	-- Disable defaults
	utils.disable_default("CMD", "k"),
	utils.disable_default("CMD", "w"),
	utils.disable_default("CMD", "n"),
	utils.disable_default("CMD", "f"),
	utils.disable_default("CMD", "+"),
	utils.disable_default("CMD", "-"),
	utils.disable_default("CMD", "r"),
	-- Sessions
	{
		key = "p",
		mods = "LEADER|CMD",
		action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
	},
	{
		key = "r",
		mods = "LEADER|CMD",
		action = act.PromptInputLine({
			description = "Rename current workspace",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					mux.rename_workspace(window:mux_window():get_workspace(), line)
				end
			end),
		}),
	},
	-- Tabs
	{
		mods = "LEADER|CMD",
		key = "n",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = "LEADER|CMD",
		key = "1",
		action = act.ActivateTab(0),
	},
	{
		mods = "LEADER|CMD",
		key = "2",
		action = act.ActivateTab(1),
	},
	{
		mods = "LEADER|CMD",
		key = "3",
		action = act.ActivateTab(2),
	},
	{
		mods = "LEADER|CMD",
		key = "4",
		action = act.ActivateTab(3),
	},
	{
		mods = "LEADER|CMD",
		key = "5",
		action = act.ActivateTab(4),
	},

	-- Wezterm & Neovim
	-- Panes
	utils_vim.key_map_vim_mix_pane_vertical_split("LEADER|CMD", "-"),
	utils_vim.key_map_vim_mix_pane_horizontal_split("LEADER|CMD", "\\"),
	utils_vim.key_map_vim_mix_pane_close("LEADER|CMD", "w"),
	utils_vim.key_map_vim_mix_pane_zoom("LEADER|CMD", "f"),
	utils_vim.key_map_vim_mix_pane_zoom_out("LEADER|CMD", "g"),
	utils_vim.key_map_vim_mix_pane_navigation("LEADER|CMD", "h", "Left"),
	utils_vim.key_map_vim_mix_pane_navigation("LEADER|CMD", "j", "Down"),
	utils_vim.key_map_vim_mix_pane_navigation("LEADER|CMD", "k", "Up"),
	utils_vim.key_map_vim_mix_pane_navigation("LEADER|CMD", "l", "Right"),

	-- Neovim
	-- Telescope file finder
	utils_vim.key_map_vim_mix(
		"CMD",
		"p",
		act.Multiple({
			act.SendKey({ key = " " }),
			act.SendKey({ key = "f" }),
			act.SendKey({ key = "f" }),
		})
	),
	-- Telescope lsp symbol finder
	utils_vim.key_map_vim_mix(
		"CMD",
		"o",
		act.Multiple({
			act.SendKey({ key = " " }),
			act.SendKey({ key = "f" }),
			act.SendKey({ key = "o" }),
		})
	),
	-- Harpoon navigation
	utils_vim.key_map_vim_mix("CMD", "h", act.SendKey({ mods = "ALT", key = "h" })),
	utils_vim.key_map_vim_mix("CMD", "1", act.SendKey({ mods = "ALT", key = "!" })),
	utils_vim.key_map_vim_mix("CMD", "2", act.SendKey({ mods = "ALT", key = "@" })),
	utils_vim.key_map_vim_mix("CMD", "3", act.SendKey({ mods = "ALT", key = "#" })),
	utils_vim.key_map_vim_mix("CMD", "4", act.SendKey({ mods = "ALT", key = "$" })),
	utils_vim.key_map_vim_mix("CMD", "5", act.SendKey({ mods = "ALT", key = "%" })),
}

return config
