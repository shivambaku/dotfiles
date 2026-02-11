local module = {}
local wezterm = require("wezterm")
local act = wezterm.action

local function is_vim(pane)
	local process_info = pane:get_foreground_process_info()
	local process_name = process_info and process_info.name
	return process_name == "nvim" or process_name == "vim"
end

function module.key_map_vim_mix(mods, key, vim_action, non_vim_action)
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

function module.key_map_vim_mix_pane_vertical_split(mods, key)
	return module.key_map_vim_mix(
		mods,
		key,
		act.Multiple({
			act.SendKey({ key = "w", mods = "CTRL" }),
			act.SendKey({ key = "s" }),
		}),
		act.SplitVertical({ domain = "CurrentPaneDomain" })
	)
end

function module.key_map_vim_mix_pane_horizontal_split(mods, key)
	return module.key_map_vim_mix(
		mods,
		key,
		act.Multiple({
			act.SendKey({ key = "w", mods = "CTRL" }),
			act.SendKey({ key = "v" }),
		}),
		act.SplitHorizontal({ domain = "CurrentPaneDomain" })
	)
end

function module.key_map_vim_mix_pane_close(mods, key)
	return module.key_map_vim_mix(
		mods,
		key,
		act.Multiple({
			act.SendKey({ key = "w", mods = "CTRL" }),
			act.SendKey({ key = "q" }),
		}),
		act.CloseCurrentPane({ confirm = true })
	)
end

function module.key_map_vim_mix_pane_zoom(mods, key)
	return module.key_map_vim_mix(
		mods,
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

function module.key_map_vim_mix_pane_zoom_out(mods, key)
	return module.key_map_vim_mix(
		mods,
		key,
		act.Multiple({
			act.SetPaneZoomState(false),
			act.SendKey({ key = "w", mods = "CTRL" }),
			act.SendKey({ key = "=" }),
		}),
		act.SetPaneZoomState(false)
	)
end

function module.key_map_vim_mix_pane_navigation(mods, key, direction)
	return module.key_map_vim_mix(
		mods,
		key,
		act.Multiple({
			act.SendKey({ key = "w", mods = "CTRL" }),
			act.SendKey({ key = key }),
		}),
		act.ActivatePaneDirection(direction)
	)
end

return module
