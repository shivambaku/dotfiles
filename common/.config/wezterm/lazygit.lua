local wezterm = require("wezterm")
local utils_session = require("utils-session")

local module = {}

function module.open()
	return wezterm.action_callback(function(_, pane)
		local cwd = utils_session.current_path(pane)
		local lazygit_pane = pane:split({
			direction = "Bottom",
			top_level = true,
			size = 0.85,
			cwd = cwd,
			args = { "/bin/zsh", "-lc", "lazygit" },
		})

		lazygit_pane:activate()
		lazygit_pane:tab():set_zoomed(true)
	end)
end

return module
