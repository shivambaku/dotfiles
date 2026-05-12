local wezterm = require("wezterm")
local workspaces = require("workspaces")
local utils_session = require("utils-session")

local module = {}

local function opencode_db_path()
	local data_home = os.getenv("XDG_DATA_HOME") or utils_session.join_path(wezterm.home_dir, ".local", "share")
	return utils_session.join_path(data_home, "opencode", "opencode.db")
end

local function relative_time(ms)
	ms = tonumber(ms)
	if not ms then
		return "?"
	end

	local delta = math.max(0, os.time() * 1000 - ms)
	local minute = 60 * 1000
	local hour = 60 * minute
	local day = 24 * hour

	if delta < minute then
		return "now"
	elseif delta < hour then
		return tostring(math.floor(delta / minute)) .. "m"
	elseif delta < day then
		return tostring(math.floor(delta / hour)) .. "h"
	elseif delta < 7 * day then
		return tostring(math.floor(delta / day)) .. "d"
	end

	return os.date("%b %d", math.floor(ms / 1000))
end

local function clean_label_text(text)
	if type(text) ~= "string" or text == "" then
		return "Untitled"
	end

	return text:gsub("[\r\n]+", " ")
end

local function project_label(session)
	local label = utils_session.basename(session.directory) or utils_session.basename(session.worktree) or "unknown"
	return wezterm.truncate_right(clean_label_text(label), 40)
end

local function session_label(session)
	local age = relative_time(session.time_updated)
	local project = project_label(session)
	local title = wezterm.truncate_right(clean_label_text(session.title), 120)

	return string.format("%-7s %-40s %s", age, project, title)
end

local function opencode_spawn(directory, session_id)
	local shell = os.getenv("SHELL") or "/bin/zsh"
	local command = "opencode --session " .. wezterm.shell_quote_arg(session_id)

	return {
		cwd = directory,
		args = { shell, "-lc", command },
	}
end

local function recent_sessions()
	local query = [[
select
  s.id as session_id,
  s.title as title,
  s.directory as directory,
  s.time_updated as time_updated,
  p.worktree as worktree
from session s
join project p on p.id = s.project_id
where s.time_archived is null
  and s.parent_id is null
order by s.time_updated desc
limit 25;
]]

	local success, stdout, stderr = wezterm.run_child_process({ "sqlite3", "-json", opencode_db_path(), query })
	if not success then
		return nil, (stderr and stderr ~= "" and stderr) or "Unable to read OpenCode sessions"
	end

	local ok, decoded = pcall(wezterm.json_parse, stdout or "[]")
	if not ok or type(decoded) ~= "table" then
		return nil, "Unable to parse OpenCode sessions"
	end

	return decoded
end

function module.choose_session()
	return wezterm.action_callback(function(window, pane)
		local sessions, err = recent_sessions()
		if not sessions then
			utils_session.notify("OpenCode", window, err, "warn")
			return
		end

		if #sessions == 0 then
			utils_session.notify("OpenCode", window, "No recent sessions found", "warn")
			return
		end

		local choices = {}
		for _, session in ipairs(sessions) do
			if type(session.directory) == "string" and session.directory ~= "" and type(session.session_id) == "string" then
				table.insert(choices, {
					label = session_label(session),
					id = wezterm.json_encode({
						session_id = session.session_id,
						directory = session.directory,
					}),
				})
			end
		end

		window:perform_action(
			wezterm.action.InputSelector({
				title = "Recent OpenCode Sessions",
				choices = choices,
				fuzzy = true,
				fuzzy_description = "OpenCode session: ",
				action = wezterm.action_callback(function(child_window, child_pane, id, _)
					if not id then
						return
					end

					local ok, selected = pcall(wezterm.json_parse, id)
					if not ok or type(selected) ~= "table" then
						return
					end

					workspaces.switch_to_path_workspace_with_spawn(
						child_window,
						child_pane,
						selected.directory,
						opencode_spawn(selected.directory, selected.session_id)
					)
				end),
			}),
			pane
		)
	end)
end

return module
