local wezterm = require("wezterm")
local workspaces = require("workspaces")
local utils_session = require("utils-session")

local module = {}
local live_state_max_age_ms = 60 * 1000
local workspace_prefix = "path:"
local status_priority = {
	blocked = 1,
	error = 2,
	working = 3,
	idle = 4,
	running = 5,
	stopped = 6,
}

local function opencode_db_path()
	local data_home = os.getenv("XDG_DATA_HOME") or utils_session.join_path(wezterm.home_dir, ".local", "share")
	return utils_session.join_path(data_home, "opencode", "opencode.db")
end

local function opencode_session_state_dir()
	local state_home = os.getenv("XDG_STATE_HOME") or utils_session.join_path(wezterm.home_dir, ".local", "state")
	return utils_session.join_path(state_home, "opencode", "wezterm-sessions")
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

local function status_parts(state)
	if not state then
		return "⚪", "stopped"
	end

	if state.status == "working" then
		return "🔵", "working"
	elseif state.status == "blocked" then
		return "🟡", "blocked"
	elseif state.status == "idle" then
		return "🟢", "idle"
	elseif state.status == "error" then
		return "🔴", "error"
	end

	return "⚫", "running"
end

local function session_label(session, state)
	local icon, status = status_parts(state)
	local age = relative_time(session.time_updated)
	local project = project_label(session)
	local title = wezterm.truncate_right(clean_label_text(session.title), 120)

	return string.format("%s  %-8s %-7s %-32s %s", icon, status, age, project, title)
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

local function read_json_file(path)
	local file = io.open(path, "r")
	if not file then
		return nil
	end

	local content = file:read("*a")
	file:close()

	if not content or content == "" then
		return nil
	end

	local ok, decoded = pcall(wezterm.json_parse, content)
	if not ok or type(decoded) ~= "table" then
		return nil
	end

	return decoded
end

local function recent_state(state)
	local updated_at = tonumber(state and state.updated_at)
	if not updated_at then
		return false
	end

	local age = math.max(0, os.time() * 1000 - updated_at)
	return age <= live_state_max_age_ms
end

local function stored_session_states()
	local states = {}
	for _, path in ipairs(wezterm.glob(opencode_session_state_dir() .. "/*.json")) do
		local state = read_json_file(path)
		local session_id = state and state.session_id
		if type(session_id) == "string" and session_id ~= "" then
			states[session_id] = state
		end
	end

	return states
end

local function live_session_states()
	local states = {}

	for session_id, state in pairs(stored_session_states()) do
		if recent_state(state) then
			if type(state.workspace) ~= "string" or state.workspace == "" then
				if type(state.directory) == "string" and state.directory ~= "" then
					state.workspace = workspace_prefix .. state.directory
				end
			end

			states[session_id] = state
		end
	end

	return states
end

local function session_sort_priority(session, state)
	if not state then
		return status_priority.stopped
	end

	return status_priority[state.status] or status_priority.running
end

local function sorted_sessions(sessions, live_states)
	local sorted = {}
	for _, session in ipairs(sessions) do
		table.insert(sorted, session)
	end

	table.sort(sorted, function(a, b)
		local a_priority = session_sort_priority(a, live_states[a.session_id])
		local b_priority = session_sort_priority(b, live_states[b.session_id])
		if a_priority ~= b_priority then
			return a_priority < b_priority
		end

		return (tonumber(a.time_updated) or 0) > (tonumber(b.time_updated) or 0)
	end)

	return sorted
end

local function focus_live_session(window, pane, selected)
	if selected.workspace then
		workspaces.switch_to_workspace(window, pane, selected.workspace)
	end

	if not selected.pane_id then
		return selected.workspace ~= nil
	end

	return selected.workspace ~= nil
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

		local live_states = live_session_states()
		local choices = {}
		for _, session in ipairs(sorted_sessions(sessions, live_states)) do
			if type(session.directory) == "string" and session.directory ~= "" and type(session.session_id) == "string" then
				local state = live_states[session.session_id]
				table.insert(choices, {
					label = session_label(session, state),
					id = wezterm.json_encode({
						session_id = session.session_id,
						directory = session.directory,
						pane_id = state and state.pane_id or nil,
						workspace = state and state.workspace or nil,
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

					if selected.pane_id or selected.workspace then
						if focus_live_session(child_window, child_pane, selected) then
							return
						end
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
