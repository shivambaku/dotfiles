local wezterm = require("wezterm")
local session_utils = require("session_utils")
local module = {}

local dotfiles_dir = wezterm.home_dir .. "/dotfiles"
local downloads_dir = wezterm.home_dir .. "/Downloads"
local notes_dir = wezterm.home_dir .. "/Documents/Notes"
local project_dir = wezterm.home_dir .. "/Documents/Projects"
local workspace_prefix = "path:"
local slot_file_name = "workspace-slots.json"
local is_windows = wezterm.target_triple:find("windows") ~= nil
local is_macos = wezterm.target_triple:find("apple%-darwin") ~= nil

local last_workspace = nil

local function escape_pattern(text)
	return text:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
end

local function project_dirs()
	local projects = { wezterm.home_dir, dotfiles_dir, downloads_dir, notes_dir, project_dir }

	for _, dir in ipairs(wezterm.glob(project_dir .. "/*")) do
		table.insert(projects, dir)
	end
	for _, dir in ipairs(wezterm.glob(project_dir .. "/*/*")) do
		table.insert(projects, dir)
	end
	return projects
end

local function slots_file()
	if is_windows then
		return nil
	end

	local data_home
	if is_macos then
		data_home = session_utils.join_path(wezterm.home_dir, "Library", "Application Support")
	else
		data_home = os.getenv("XDG_DATA_HOME") or session_utils.join_path(wezterm.home_dir, ".local", "share")
	end

	return session_utils.join_path(data_home, "wezterm", slot_file_name)
end

local function load_saved_workspaces()
	local path = slots_file()
	if not path then
		return {}
	end

	local file = io.open(path, "r")
	if not file then
		return {}
	end

	local content = file:read("*a")
	file:close()

	if not content or content == "" then
		return {}
	end

	local ok, decoded = pcall(wezterm.json_parse, content)
	if not ok or type(decoded) ~= "table" then
		return {}
	end

	return decoded
end

local function save_saved_workspaces(saved_workspaces)
	local path = slots_file()
	if not path then
		return true
	end

	local dir = session_utils.dirname(path)
	if not dir then
		return false
	end

	local success = wezterm.run_child_process({ "mkdir", "-p", dir })
	if not success then
		return false
	end

	local file = io.open(path, "w")
	if not file then
		return false
	end

	file:write(wezterm.json_encode(saved_workspaces))
	file:close()

	return true
end

local function workspace_name_for_path(path)
	return workspace_prefix .. path
end

function module.path_for_workspace_name(name)
	if type(name) ~= "string" or name:sub(1, #workspace_prefix) ~= workspace_prefix then
		return nil
	end

	return name:sub(#workspace_prefix + 1)
end

local function path_label(path)
	local label = path
	label = label:gsub("^" .. escape_pattern(notes_dir), "/Notes")
	label = label:gsub("^" .. escape_pattern(project_dir), "/Projects")
	label = label:gsub("^" .. escape_pattern(wezterm.home_dir), "")
	label = label:gsub("^/", "")

	if label == "" then
		return "~"
	end

	return label
end

local function workspace_label(name)
	local path = module.path_for_workspace_name(name)
	if path then
		return path_label(path)
	end

	return name
end

local function remember_last_workspace(window, target_workspace)
	local current_workspace = window:active_workspace()
	if current_workspace ~= target_workspace then
		last_workspace = current_workspace
	end
end

function module.switch_to_workspace(window, pane, workspace_name)
	remember_last_workspace(window, workspace_name)

	local action = { name = workspace_name }
	local path = module.path_for_workspace_name(workspace_name)
	if path then
		action.spawn = { cwd = path }
	end

	window:perform_action(wezterm.action.SwitchToWorkspace(action), pane)
end

function module.switch_to_path_workspace(window, pane, path)
	module.switch_to_workspace(window, pane, workspace_name_for_path(path))
end

function module.choose_project()
	return wezterm.action_callback(function(window, pane)
		local choices = {}
		for _, full_path in ipairs(project_dirs()) do
			table.insert(choices, {
				label = path_label(full_path),
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

					module.switch_to_path_workspace(child_window, child_pane, id)
				end),
			}),
			pane
		)
	end)
end

function module.choose_workspace()
	return wezterm.action_callback(function(window, pane)
		local current_workspace = window:active_workspace()
		local workspaces = wezterm.mux.get_workspace_names()
		local choices = {}

		table.sort(workspaces, function(a, b)
			return workspace_label(a) < workspace_label(b)
		end)

		for _, name in ipairs(workspaces) do
			local label = workspace_label(name)
			if name == current_workspace then
				label = label .. " (current)"
			end

			table.insert(choices, {
				label = label,
				id = name,
			})
		end

		window:perform_action(
			wezterm.action.InputSelector({
				title = "Workspaces",
				choices = choices,
				fuzzy = true,
				fuzzy_description = "Workspace: ",
				action = wezterm.action_callback(function(child_window, child_pane, id, _)
					if not id then
						return
					end

					module.switch_to_workspace(child_window, child_pane, id)
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
			module.switch_to_workspace(window, pane, last_workspace)
		end
		last_workspace = current_workspace
	end)
end

function module.save_workspace(slot)
	return wezterm.action_callback(function(window, _)
		if is_windows then
			return
		end

		local saved_workspaces = load_saved_workspaces()
		local current_workspace = window:active_workspace()
		saved_workspaces[tostring(slot)] = current_workspace

		local ok = save_saved_workspaces(saved_workspaces)
		if not ok then
			return
		end

		session_utils.notify("Workspace", window, "Saved " .. workspace_label(current_workspace) .. " to slot " .. slot)
	end)
end

function module.switch_to_saved_workspace(slot)
	return wezterm.action_callback(function(window, pane)
		if is_windows then
			return
		end

		local saved_workspaces = load_saved_workspaces()
		local workspace_name = saved_workspaces[tostring(slot)]
		if type(workspace_name) ~= "string" then
			session_utils.notify("Workspace", window, "No workspace saved in slot " .. slot)
			return
		end

		module.switch_to_workspace(window, pane, workspace_name)
		session_utils.notify("Workspace", window, "Opened slot " .. slot .. ": " .. workspace_label(workspace_name))
	end)
end

return module
