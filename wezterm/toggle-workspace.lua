local wezterm = require("wezterm")
local module = {}

local last_workspace = nil

function module.toggle_workspace()
	return wezterm.action_callback(function(window, pane)
		local current_workspace = window:active_workspace()

		if last_workspace then
			window:perform_action(wezterm.action.SwitchToWorkspace({ name = last_workspace }), pane)
		end

		last_workspace = current_workspace
	end)
end

return module
