local module = {}
local wezterm = require("wezterm")
local act = wezterm.action

function module.disable_default(mods, key)
	return {
		mods = mods,
		key = key,
		action = act.DisableDefaultAssignment,
	}
end

function module.key_map_mix(mods, key, action)
	return {
		key = key,
		mods = mods,
		action = wezterm.action_callback(function(window, pane)
			window:perform_action(action, pane)
		end),
	}
end

return module
