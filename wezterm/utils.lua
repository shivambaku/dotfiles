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

return module
