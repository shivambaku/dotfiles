-- CREDIT - https://alexplescan.com/posts/2024/08/10/wezterm/
local wezterm = require("wezterm")
local module = {}

local dotfiles_dir = wezterm.home_dir .. "/dotfiles"
local project_dir = wezterm.home_dir .. "/Documents/Projects"

local function project_dirs()
	local projects = { wezterm.home_dir, dotfiles_dir, project_dir }

	for _, dir in ipairs(wezterm.glob(project_dir .. "/*")) do
		table.insert(projects, dir)
	end

	for _, dir in ipairs(wezterm.glob(project_dir .. "/*/*")) do
		table.insert(projects, dir)
	end

	return projects
end

function module.choose_project()
	local choices = {}
	for _, value in ipairs(project_dirs()) do
		table.insert(choices, { label = value })
	end

	return wezterm.action.InputSelector({
		title = "Projects",
		choices = choices,
		fuzzy = true,
		action = wezterm.action_callback(function(child_window, child_pane, _, label)
			if not label then
				return
			end

			child_window:perform_action(
				wezterm.action.SwitchToWorkspace({
					name = label:match("([^/]+)$"),
					spawn = { cwd = label },
				}),
				child_pane
			)
		end),
	})
end

return module
