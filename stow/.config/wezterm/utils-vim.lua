local module = {}
local wezterm = require("wezterm")

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
			elseif non_vim_action then
				window:perform_action(non_vim_action, pane)
			end
		end),
	}
end

return module
