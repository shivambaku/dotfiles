local wezterm = require("wezterm")
local utils_session = require("utils-session")

local module = {}

function module.open()
	return wezterm.action_callback(function(window, pane)
		local cwd = utils_session.current_path(pane)
		local ok, lazygit_pane = pcall(function()
			return pane:split({
				direction = "Bottom",
				size = 0.85,
				cwd = cwd,
				args = { "/bin/zsh", "-lic", "exec lazygit" },
			})
		end)
		if not ok or not lazygit_pane then
			utils_session.notify("Lazygit", window, "Unable to open lazygit pane", "warn")
			return
		end

		lazygit_pane:activate()
		lazygit_pane:tab():set_zoomed(true)
	end)
end

return module
