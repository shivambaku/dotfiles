local wezterm = require("wezterm")
local module = {}

local notes_dir_from_home = "/Documents/Notes"
local project_dir_from_home = "/Documents/Projects"
local last_workspace = nil

local function project_dirs()
	local dotfiles_dir = wezterm.home_dir .. "/dotfiles"
	local downloads_dir = wezterm.home_dir .. "/Downloads"
	local notes_dir = wezterm.home_dir .. notes_dir_from_home
	local project_dir = wezterm.home_dir .. project_dir_from_home

	local projects = { wezterm.home_dir, dotfiles_dir, downloads_dir, notes_dir, project_dir }

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
		for _, full_path in ipairs(project_dirs()) do
			local label = full_path:gsub("^" .. wezterm.home_dir, "")
			label = label:gsub("^" .. notes_dir_from_home, "/Notes")
			label = label:gsub("^" .. project_dir_from_home, "/Projects")
			label = label:gsub("^/", "")

			if label == "" then
				label = "~"
			end

			table.insert(choices, {
				label = label,
				id = full_path,
			})
		end

		window:perform_action(
			wezterm.action.InputSelector({
				title = "Projects",
				choices = choices,
				fuzzy = true,
				fuzzy_description = "Project: ",
				action = wezterm.action_callback(function(child_window, child_pane, id, _)
					if not id then
						return
					end

					last_workspace = child_window:active_workspace()
					child_window:perform_action(
						wezterm.action.SwitchToWorkspace({
							name = id:match("([^/]+)$"),
							spawn = { cwd = id },
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
