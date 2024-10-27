-- https://wezfurlong.org/wezterm/config/lua/general.html
local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

-- Helpers
local function disable_default(mods, key)
	return {
		mods = mods,
		key = key,
		action = act.DisableDefaultAssignment,
	}
end

local function is_vim(pane)
	local process_info = pane:get_foreground_process_info()
	local process_name = process_info and process_info.name
	return process_name == "nvim" or process_name == "vim"
end

local function key_map_vim_mix(mods, key, vim_action, non_vim_action)
	return {
		key = key,
		mods = mods,
		action = wezterm.action_callback(function(window, pane)
			if is_vim(pane) then
				window:perform_action(vim_action, pane)
			else
				window:perform_action(non_vim_action, pane)
			end
		end),
	}
end

local function key_map_vim_mix_pane_vertical_split(key)
	return key_map_vim_mix(
		"LEADER|CMD",
		key,
		act.Multiple({
			act.SendKey({ key = "w", mods = "CTRL" }),
			act.SendKey({ key = "s" }),
		}),
		act.SplitVertical({ domain = "CurrentPaneDomain" })
	)
end

local function key_map_vim_mix_pane_horizontal_split(key)
	return key_map_vim_mix(
		"LEADER|CMD",
		key,
		act.Multiple({
			act.SendKey({ key = "w", mods = "CTRL" }),
			act.SendKey({ key = "v" }),
		}),
		act.SplitHorizontal({ domain = "CurrentPaneDomain" })
	)
end

local function key_map_vim_mix_pane_close(key)
	return key_map_vim_mix(
		"LEADER|CMD",
		key,
		act.Multiple({
			act.SendKey({ key = "w", mods = "CTRL" }),
			act.SendKey({ key = "q" }),
		}),
		act.CloseCurrentPane({ confirm = true })
	)
end

local function key_map_vim_mix_pane_zoom(key)
	return key_map_vim_mix(
		"LEADER|CMD",
		key,
		act.Multiple({
			act.SetPaneZoomState(true),
			act.SendKey({ key = "w", mods = "CTRL" }),
			act.SendKey({ key = "|" }),
			act.SendKey({ key = "w", mods = "CTRL" }),
			act.SendKey({ key = "_" }),
		}),
		act.SetPaneZoomState(true)
	)
end

local function key_map_vim_mix_pane_zoom_out(key)
	return key_map_vim_mix(
		"LEADER|CMD",
		key,
		act.Multiple({
			act.SetPaneZoomState(false),
			act.SendKey({ key = "w", mods = "CTRL" }),
			act.SendKey({ key = "=" }),
		}),
		act.SetPaneZoomState(false)
	)
end

local function key_map_vim_mix_pane_navigation(key, direction)
	return key_map_vim_mix(
		"LEADER|CMD",
		key,
		act.Multiple({
			act.SendKey({ key = "w", mods = "CTRL" }),
			act.SendKey({ key = key }),
		}),
		act.ActivatePaneDirection(direction)
	)
end

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
	disable_default("CMD", "k"),
	disable_default("CMD", "w"),
	disable_default("CMD", "n"),
	disable_default("CMD", "f"),
	disable_default("CMD", "+"),
	disable_default("CMD", "-"),
	disable_default("CMD", "k"),
	disable_default("CMD", "k"),
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
	key_map_vim_mix_pane_vertical_split("-"),
	key_map_vim_mix_pane_horizontal_split("\\"),
	key_map_vim_mix_pane_close("w"),
	key_map_vim_mix_pane_zoom("f"),
	key_map_vim_mix_pane_zoom_out("g"),
	key_map_vim_mix_pane_navigation("h", "Left"),
	key_map_vim_mix_pane_navigation("j", "Down"),
	key_map_vim_mix_pane_navigation("k", "Up"),
	key_map_vim_mix_pane_navigation("l", "Right"),

	-- Neovim
	-- Telescope file finder
	key_map_vim_mix(
		"CMD",
		"p",
		act.Multiple({
			act.SendKey({ key = " " }),
			act.SendKey({ key = "f" }),
			act.SendKey({ key = "f" }),
		})
	),
	-- Telescope lsp symbol finder
	key_map_vim_mix(
		"CMD",
		"o",
		act.Multiple({
			act.SendKey({ key = " " }),
			act.SendKey({ key = "f" }),
			act.SendKey({ key = "o" }),
		})
	),
	-- Harpoon navigation
	key_map_vim_mix("CMD", "h", act.SendKey({ mods = "ALT", key = "h" })),
	key_map_vim_mix("CMD", "1", act.SendKey({ mods = "ALT", key = "!" })),
	key_map_vim_mix("CMD", "2", act.SendKey({ mods = "ALT", key = "@" })),
	key_map_vim_mix("CMD", "3", act.SendKey({ mods = "ALT", key = "#" })),
	key_map_vim_mix("CMD", "4", act.SendKey({ mods = "ALT", key = "$" })),
	key_map_vim_mix("CMD", "5", act.SendKey({ mods = "ALT", key = "%" })),
}

return config
