local wezterm = require("wezterm")
local module = {}

local last_workspace = nil

local function project_dirs()
	local dotfiles_dir = wezterm.home_dir .. "/dotfiles"
	local project_dir = wezterm.home_dir .. "/Documents/Projects"
	local downloads_dir = wezterm.home_dir .. "/Downloads"

	local projects = { wezterm.home_dir, dotfiles_dir, downloads_dir, project_dir }
	for _, dir in ipairs(wezterm.glob(project_dir .. "/*")) do
		table.insert(projects, dir)
	end
	for _, dir in ipairs(wezterm.glob(project_dir .. "/*/*")) do
		table.insert(projects, dir)
	end
	return projects
end

-- CREDIT - https://alexplescan.com/posts/2024/08/10/wezterm/
function module.choose_project()
	return wezterm.action_callback(function(window, pane)
		local choices = {}
		for _, value in ipairs(project_dirs()) do
			table.insert(choices, { label = value })
		end

		window:perform_action(
			wezterm.action.InputSelector({
				title = "Projects",
				choices = choices,
				fuzzy = true,
				fuzzy_description = "Project: ",
				action = wezterm.action_callback(function(child_window, child_pane, _, label)
					if not label then
						return
					end

					last_workspace = child_window:active_workspace()
					child_window:perform_action(
						wezterm.action.SwitchToWorkspace({
							name = label:match("([^/]+)$"),
							spawn = { cwd = label },
						}),
						child_pane
					)
				end),
			}),
			pane
		)
	end)
end

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
