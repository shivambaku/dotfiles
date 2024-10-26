-- https://wezfurlong.org/wezterm/config/lua/general.html
local wezterm = require("wezterm")
local act = wezterm.action
local config = {}
print("Cat")
-- Helpers
local function is_vim(pane)
	local process_info = pane:get_foreground_process_info()
	local process_name = process_info and process_info.name
	return process_name == "nvim" or process_name == "vim"
end

local function key_map_pane_navigation(key, direction)
	return {
		key = key,
		mods = "LEADER|CMD",
		action = wezterm.action_callback(function(window, pane)
			if is_vim(pane) then
				window:perform_action(
					act.Multiple({
						act.SendKey({ key = "w", mods = "CTRL" }),
						act.SendKey({ key = key }),
					}),
					pane
				)
			else
				window:perform_action(act.ActivatePaneDirection(direction), pane)
			end
		end),
	}
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

	-- Disable defaults
	{
		mods = "CMD",
		key = "k",
		action = act.DisableDefaultAssignment,
	},
	{
		mods = "CMD",
		key = "n",
		action = act.DisableDefaultAssignment,
	},
	{
		mods = "CMD",
		key = "f",
		action = act.DisableDefaultAssignment,
	},
	{
		mods = "CMD",
		key = "+",
		action = act.DisableDefaultAssignment,
	},
	{
		mods = "CMD",
		key = "-",
		action = act.DisableDefaultAssignment,
	},
	-- Wezterm
	-- Panes
	{
		mods = "CMD",
		key = "w",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "-",
		mods = "LEADER|CMD",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "\\",
		mods = "LEADER|CMD",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	key_map_pane_navigation("h", "Left"),
	key_map_pane_navigation("j", "Down"),
	key_map_pane_navigation("k", "Up"),
	key_map_pane_navigation("l", "Right"),
	{
		key = "f",
		mods = "LEADER|CMD",
		action = act.TogglePaneZoomState,
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
	-- Neovim
	-- Telescope fuzzy file finder
	{
		mods = "CMD",
		key = "p",
		action = act.Multiple({
			act.SendKey({ key = " " }),
			act.SendKey({ key = "f" }),
			act.SendKey({ key = "f" }),
		}),
	},
	-- Telescope fuzzy lsp symbol finder
	{
		mods = "CMD",
		key = "o",
		action = act.Multiple({
			act.SendKey({ key = " " }),
			act.SendKey({ key = "f" }),
			act.SendKey({ key = "o" }),
		}),
	},
	-- Harpoon navigation
	{
		mods = "CMD",
		key = "1",
		action = act.SendKey({ mods = "ALT", key = "!" }),
	},
	{
		mods = "CMD",
		key = "2",
		action = act.SendKey({ mods = "ALT", key = "@" }),
	},
	{
		mods = "CMD",
		key = "3",
		action = act.SendKey({ mods = "ALT", key = "#" }),
	},
	{
		mods = "CMD",
		key = "4",
		action = act.SendKey({ mods = "ALT", key = "$" }),
	},
	{
		mods = "CMD",
		key = "5",
		action = act.SendKey({ mods = "ALT", key = "%" }),
	},
	{
		mods = "CMD",
		key = "h",
		action = act.SendKey({ mods = "ALT", key = "h" }),
	},
}

return config
