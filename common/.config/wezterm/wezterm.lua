-- https://wezfurlong.org/wezterm/config/lua/general.html
local wezterm = require("wezterm")
local act = wezterm.action
local utils = require("utils")
local utils_vim = require("utils-vim")
local workspaces = require("workspaces")

local mod = "SUPER"
local leader_mod = "LEADER|" .. mod

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
config.leader = { key = "k", mods = mod, timeout_milliseconds = 2000 }
config.keys = {
	-- Wezterm
	-- Disable defaults
	utils.disable_default(mod, "k"),
	utils.disable_default(mod, "w"),
	utils.disable_default(mod, "n"),
	utils.disable_default(mod, "f"),
	utils.disable_default(mod, "+"),
	utils.disable_default(mod, "-"),
	utils.disable_default(mod, "r"),
	-- Sessions
	{
		mods = mod,
		key = "Backspace",
		action = workspaces.toggle_workspace(),
	},
	{
		mods = leader_mod,
		key = "p",
		action = workspaces.choose_project(),
	},
	{
		mods = "CTRL",
		key = "F1",
		action = workspaces.save_workspace(1),
	},
	{
		mods = "CTRL",
		key = "F2",
		action = workspaces.save_workspace(2),
	},
	{
		mods = "CTRL",
		key = "F3",
		action = workspaces.save_workspace(3),
	},
	{
		mods = "CTRL",
		key = "F4",
		action = workspaces.save_workspace(4),
	},
	{
		mods = mod,
		key = "F1",
		action = workspaces.switch_to_saved_workspace(1),
	},
	{
		mods = mod,
		key = "F2",
		action = workspaces.switch_to_saved_workspace(2),
	},
	{
		mods = mod,
		key = "F3",
		action = workspaces.switch_to_saved_workspace(3),
	},
	{
		mods = mod,
		key = "F4",
		action = workspaces.switch_to_saved_workspace(4),
	},
	-- Tabs
	{
		mods = leader_mod,
		key = "n",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = leader_mod,
		key = "1",
		action = act.ActivateTab(0),
	},
	{
		mods = leader_mod,
		key = "2",
		action = act.ActivateTab(1),
	},
	{
		mods = leader_mod,
		key = "3",
		action = act.ActivateTab(2),
	},
	{
		mods = leader_mod,
		key = "4",
		action = act.ActivateTab(3),
	},
	{
		mods = leader_mod,
		key = "5",
		action = act.ActivateTab(4),
	},

	-- OpenCode
	utils.key_map_mix(mod, "i", act.SendKey({ mods = "CTRL", key = "x" })),

	-- Wezterm & Neovim
	-- Panes
	utils_vim.key_map_vim_mix_pane_vertical_split(leader_mod, "-"),
	utils_vim.key_map_vim_mix_pane_horizontal_split(leader_mod, "\\"),
	utils_vim.key_map_vim_mix_pane_close(leader_mod, "w"),
	utils_vim.key_map_vim_mix_pane_zoom(leader_mod, "f"),
	utils_vim.key_map_vim_mix_pane_zoom_out(leader_mod, "g"),
	utils_vim.key_map_vim_mix_pane_navigation(leader_mod, "h", "Left"),
	utils_vim.key_map_vim_mix_pane_navigation(leader_mod, "j", "Down"),
	utils_vim.key_map_vim_mix_pane_navigation(leader_mod, "k", "Up"),
	utils_vim.key_map_vim_mix_pane_navigation(leader_mod, "l", "Right"),

	-- Neovim
	-- Telescope file finder
	utils_vim.key_map_vim_mix(
		mod,
		"p",
		act.Multiple({
			act.SendKey({ key = " " }),
			act.SendKey({ key = "f" }),
			act.SendKey({ key = "f" }),
		})
	),
	-- Telescope lsp symbol finder
	utils_vim.key_map_vim_mix(
		mod,
		"o",
		act.Multiple({
			act.SendKey({ key = " " }),
			act.SendKey({ key = "f" }),
			act.SendKey({ key = "o" }),
		})
	),
	-- Harpoon navigation
	utils_vim.key_map_vim_mix(mod, "h", act.SendKey({ mods = "CTRL", key = "h" })),
	utils_vim.key_map_vim_mix(mod, "1", act.SendKey({ mods = "CTRL", key = "!" })),
	utils_vim.key_map_vim_mix(mod, "2", act.SendKey({ mods = "CTRL", key = "@" })),
	utils_vim.key_map_vim_mix(mod, "3", act.SendKey({ mods = "CTRL", key = "#" })),
	utils_vim.key_map_vim_mix(mod, "4", act.SendKey({ mods = "CTRL", key = "$" })),
	utils_vim.key_map_vim_mix(mod, "5", act.SendKey({ mods = "CTRL", key = "%" })),
	-- Multi cursor
	utils_vim.key_map_vim_mix(mod, "d", act.SendKey({ mods = "CTRL", key = "n" })),
}

return config
