-- https://wezfurlong.org/wezterm/config/lua/general.html
local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local utils = require("utils")
local utils_vim = require("utils-vim")
local workspaces = require("workspaces")

local config = {}

-- FPS
config.max_fps = 144
config.animation_fps = 144

-- Window
config.window_decorations = "RESIZE"
config.window_padding = {
	top = 15,
	left = 15,
	right = 15,
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
config.color_scheme = "Catppuccin Mocha"
config.colors = {
	background = "#0a0c10",
}

-- Fonts
config.font = wezterm.font("MesloLGS Nerd Font")
config.font_size = 15
config.line_height = 1.2

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
		key = "Backspace",
		mods = "CMD",
		action = workspaces.toggle_workspace(),
	},
	{
		key = "p",
		mods = "LEADER|CMD",
		action = workspaces.choose_project(),
	},
	{
		key = "s",
		mods = "LEADER|CMD",
		action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
	},
	{
		key = "r",
		mods = "LEADER|CMD",
		action = act.PromptInputLine({
			description = "Rename current workspace",
			action = wezterm.action_callback(function(window, _, line)
				if line then
					mux.rename_workspace(window:mux_window():get_workspace(), line)
				end
			end),
		}),
	},
	{
		key = "F1",
		mods = "CTRL",
		action = workspaces.save_workspace(1),
	},
	{
		key = "F2",
		mods = "CTRL",
		action = workspaces.save_workspace(2),
	},
	{
		key = "F3",
		mods = "CTRL",
		action = workspaces.save_workspace(3),
	},
	{
		key = "F4",
		mods = "CTRL",
		action = workspaces.save_workspace(4),
	},
	{
		key = "F1",
		mods = "CMD",
		action = workspaces.switch_to_saved_workspace(1),
	},
	{
		key = "F2",
		mods = "CMD",
		action = workspaces.switch_to_saved_workspace(2),
	},
	{
		key = "F3",
		mods = "CMD",
		action = workspaces.switch_to_saved_workspace(3),
	},
	{
		key = "F4",
		mods = "CMD",
		action = workspaces.switch_to_saved_workspace(4),
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

	-- OpenCode
	utils.key_map_mix("CMD", "i", act.SendKey({ mods = "CTRL", key = "x" })),

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
	utils_vim.key_map_vim_mix("CMD", "h", act.SendKey({ mods = "CTRL", key = "h" })),
	utils_vim.key_map_vim_mix("CMD", "1", act.SendKey({ mods = "ALT", key = "!" })),
	utils_vim.key_map_vim_mix("CMD", "2", act.SendKey({ mods = "ALT", key = "@" })),
	utils_vim.key_map_vim_mix("CMD", "3", act.SendKey({ mods = "ALT", key = "#" })),
	utils_vim.key_map_vim_mix("CMD", "4", act.SendKey({ mods = "ALT", key = "$" })),
	utils_vim.key_map_vim_mix("CMD", "5", act.SendKey({ mods = "ALT", key = "%" })),
	-- Multi cursor
	utils_vim.key_map_vim_mix("CMD", "d", act.SendKey({ mods = "CTRL", key = "n" })),
}

return config
