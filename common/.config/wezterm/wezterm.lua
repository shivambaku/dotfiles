-- https://wezfurlong.org/wezterm/config/lua/general.html
local wezterm = require("wezterm")
local act = wezterm.action
local utils_vim = require("utils-vim")
local workspaces = require("workspaces")
local worktrees = require("worktrees")

local mod = "SUPER"
local leader_mod = "LEADER|" .. mod

local bg = "#0a0c10"
local active_tab_bg = "#313244"

-- Shows the project name and the assigned group on the bottom right
wezterm.on("update-status", function(window, _)
	window:set_right_status(" " .. workspaces.status_text(window:active_workspace()) .. " ")
end)

-- Customize the tab bar so inactive tabs stay compact and the active tab keeps context.
wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
	local title = tab.tab_title
	if title == "" then
		title = tab.active_pane.title
	end

	local label = " " .. tab.tab_index + 1 .. " " .. title .. " "

	if tab.is_active then
		local available_width = math.max(1, max_width - 2)
		if #label > available_width then
			label = wezterm.truncate_right(label, available_width - 1) .. " "
		end
		return {
			{ Background = { Color = bg } },
			{ Foreground = { Color = active_tab_bg } },
			{ Text = "" },
			{ Background = { Color = active_tab_bg } },
			{ Foreground = { Color = "#b4befe" } },
			{ Attribute = { Intensity = "Bold" } },
			{ Text = label },
			{ Background = { Color = bg } },
			{ Foreground = { Color = active_tab_bg } },
			{ Text = "" },
		}
	end

	return {
		{ Background = { Color = bg } },
		{ Foreground = { Color = "#cdd6f4" } },
		{ Text = " " .. tab.tab_index + 1 .. " " },
	}
end)

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
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 48

-- Panes
config.inactive_pane_hsb = {
	saturation = 1.0,
	brightness = 0.5,
}

-- Styling
config.color_scheme = "Catppuccin Mocha"
config.colors = {
	background = bg,
	tab_bar = {
		background = bg,
	},
}

-- Fonts
config.font = wezterm.font("MesloLGS Nerd Font")
config.font_size = 15
config.line_height = 1.2

-- Keymapping
config.leader = { key = "k", mods = mod, timeout_milliseconds = 2000 }
config.keys = {
	-- Wezterm
	-- Sessions
	{
		mods = mod,
		key = "Backspace",
		action = workspaces.toggle_workspace(),
	},
	{
		mods = leader_mod,
		key = "o",
		action = worktrees.choose_worktree(),
	},
	{
		mods = leader_mod,
		key = "p",
		action = workspaces.choose_project(),
	},
	{
		mods = leader_mod,
		key = "s",
		action = workspaces.choose_workspace(),
	},
	-- Tabs
	{
		mods = leader_mod,
		key = "n",
		action = act.SpawnTab("CurrentPaneDomain"),
	},

	-- OpenCode
	{
		key = "i",
		mods = mod,
		action = act.SendKey({ mods = "CTRL", key = "x" }),
	},

	-- Wezterm & Neovim
	-- Panes
	utils_vim.key_map_vim_mix(
		leader_mod,
		"-",
		act.Multiple({
			act.SendKey({ key = "w", mods = "CTRL" }),
			act.SendKey({ key = "s" }),
		}),
		act.SplitVertical({ domain = "CurrentPaneDomain" })
	),
	utils_vim.key_map_vim_mix(
		leader_mod,
		"\\",
		act.Multiple({
			act.SendKey({ key = "w", mods = "CTRL" }),
			act.SendKey({ key = "v" }),
		}),
		act.SplitHorizontal({ domain = "CurrentPaneDomain" })
	),
	utils_vim.key_map_vim_mix(
		leader_mod,
		"w",
		act.Multiple({
			act.SendKey({ key = "w", mods = "CTRL" }),
			act.SendKey({ key = "q" }),
		}),
		act.CloseCurrentPane({ confirm = true })
	),
	utils_vim.key_map_vim_mix(
		leader_mod,
		"f",
		act.Multiple({
			act.SetPaneZoomState(true),
			act.SendKey({ key = "w", mods = "CTRL" }),
			act.SendKey({ key = "|" }),
			act.SendKey({ key = "w", mods = "CTRL" }),
			act.SendKey({ key = "_" }),
		}),
		act.SetPaneZoomState(true)
	),
	utils_vim.key_map_vim_mix(
		leader_mod,
		"g",
		act.Multiple({
			act.SetPaneZoomState(false),
			act.SendKey({ key = "w", mods = "CTRL" }),
			act.SendKey({ key = "=" }),
		}),
		act.SetPaneZoomState(false)
	),
	utils_vim.key_map_vim_mix(
		leader_mod,
		"h",
		act.Multiple({
			act.SendKey({ key = "w", mods = "CTRL" }),
			act.SendKey({ key = "h" }),
		}),
		act.ActivatePaneDirection("Left")
	),
	utils_vim.key_map_vim_mix(
		leader_mod,
		"j",
		act.Multiple({
			act.SendKey({ key = "w", mods = "CTRL" }),
			act.SendKey({ key = "j" }),
		}),
		act.ActivatePaneDirection("Down")
	),
	utils_vim.key_map_vim_mix(
		leader_mod,
		"k",
		act.Multiple({
			act.SendKey({ key = "w", mods = "CTRL" }),
			act.SendKey({ key = "k" }),
		}),
		act.ActivatePaneDirection("Up")
	),
	utils_vim.key_map_vim_mix(
		leader_mod,
		"l",
		act.Multiple({
			act.SendKey({ key = "w", mods = "CTRL" }),
			act.SendKey({ key = "l" }),
		}),
		act.ActivatePaneDirection("Right")
	),
	utils_vim.key_map_vim_mix(
		leader_mod,
		";",
		act.Multiple({
			act.SendKey({ mods = "CTRL", key = "w" }),
			act.SendKey({ key = "w" }),
		})
	),

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

for _, key in ipairs({ "k", "w", "n", "f", "+", "-", "r" }) do
	table.insert(config.keys, 1, {
		mods = mod,
		key = key,
		action = act.DisableDefaultAssignment,
	})
end

for slot = 1, 12 do
	table.insert(config.keys, {
		mods = "CTRL",
		key = "F" .. slot,
		action = workspaces.save_workspace(slot),
	})

	table.insert(config.keys, {
		mods = "NONE",
		key = "F" .. slot,
		action = workspaces.switch_to_saved_workspace(slot),
	})
end

for tab = 1, 9 do
	table.insert(config.keys, {
		mods = leader_mod,
		key = tostring(tab),
		action = act.ActivateTab(tab - 1),
	})
end

return config
