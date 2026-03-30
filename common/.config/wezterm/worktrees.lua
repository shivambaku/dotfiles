local wezterm = require("wezterm")
local workspaces = require("workspaces")
local session_utils = require("session_utils")
local module = {}

local function run_git(args, cwd)
	local command = { "git" }

	if cwd then
		table.insert(command, "-C")
		table.insert(command, cwd)
	end

	for _, arg in ipairs(args) do
		table.insert(command, arg)
	end

	local success, stdout, stderr = wezterm.run_child_process(command)
	stdout = stdout or ""
	stderr = stderr or ""
	stdout = stdout:gsub("[%s\r\n]+$", "")
	stderr = stderr:gsub("[%s\r\n]+$", "")

	return success, stdout, stderr
end

local function git_error_message(stdout, stderr)
	if stderr ~= "" then
		return stderr
	end

	if stdout ~= "" then
		return stdout
	end

	return "git command failed"
end
local function get_git_root(cwd)
	local success, stdout = run_git({ "rev-parse", "--show-toplevel" }, cwd)
	if not success or stdout == "" then
		return nil
	end

	return stdout
end

local function get_worktrees(git_root)
	local success, stdout, stderr = run_git({ "worktree", "list", "--porcelain" }, git_root)
	if not success then
		return nil, git_error_message(stdout, stderr)
	end

	local worktrees = {}
	local current_worktree = nil

	local function finish_worktree()
		if current_worktree and current_worktree.path then
			table.insert(worktrees, current_worktree)
		end

		current_worktree = nil
	end

	for line in (stdout .. "\n"):gmatch("(.-)\n") do
		if line == "" then
			finish_worktree()
		else
			local worktree_path = line:match("^worktree%s+(.+)$")
			if worktree_path then
				finish_worktree()
				current_worktree = { path = worktree_path, branch = nil, detached = false }
			elseif current_worktree then
				local branch = line:match("^branch%s+refs/heads/(.+)$")
				if branch then
					current_worktree.branch = branch
				elseif line == "detached" then
					current_worktree.detached = true
				end
			end
		end
	end

	finish_worktree()

	return worktrees
end

local function get_local_branches(git_root)
	local success, stdout, stderr = run_git({ "for-each-ref", "--format=%(refname:short)", "refs/heads" }, git_root)
	if not success then
		return nil, git_error_message(stdout, stderr)
	end

	local branches = {}
	for branch in stdout:gmatch("[^\r\n]+") do
		table.insert(branches, branch)
	end

	table.sort(branches)

	return branches
end

local function sanitize_branch_name(branch)
	return branch:gsub("[/%s]+", "-")
end

local function get_main_worktree_root(cwd)
	local success, stdout = run_git({ "rev-parse", "--path-format=absolute", "--git-common-dir" }, cwd)
	if not success or stdout == "" then
		return nil
	end

	return session_utils.dirname(stdout)
end

local function build_worktree_path(git_root, main_worktree_root, branch)
	local parent_dir = session_utils.dirname(git_root)
	local project_name = session_utils.basename(main_worktree_root or git_root)
	if not parent_dir or not project_name then
		return nil
	end

	return session_utils.join_path(parent_dir, project_name .. "-" .. sanitize_branch_name(branch))
end

local function worktree_label(worktree)
	local label = worktree.branch or session_utils.basename(worktree.path) or worktree.path

	if worktree.detached then
		label = label .. " (detached)"
	end

	return label
end

local function add_worktree(window, pane, git_root, main_worktree_root, branch, create_branch)
	local worktree_path = build_worktree_path(git_root, main_worktree_root, branch)
	if not worktree_path then
		session_utils.notify("Worktree", window, "Unable to determine the new worktree path", "warn")
		return
	end

	local args = { "worktree", "add" }

	if create_branch then
		table.insert(args, "-b")
		table.insert(args, branch)
		table.insert(args, worktree_path)
	else
		table.insert(args, worktree_path)
		table.insert(args, branch)
	end

	local success, stdout, stderr = run_git(args, git_root)
	if not success then
		session_utils.notify("Worktree", window, git_error_message(stdout, stderr), "warn")
		return
	end

	workspaces.switch_to_path_workspace(window, pane, worktree_path)
end

local function create_worktree(window, pane, git_root, main_worktree_root, worktrees)
	local branches, branch_error = get_local_branches(git_root)
	if not branches then
		session_utils.notify("Worktree", window, branch_error, "warn")
		return
	end

	local checked_out_branches = {}
	for _, worktree in ipairs(worktrees) do
		if worktree.branch then
			checked_out_branches[worktree.branch] = true
		end
	end

	local choices = {}
	for _, branch in ipairs(branches) do
		if not checked_out_branches[branch] then
			table.insert(choices, {
				label = branch,
				id = branch,
			})
		end
	end

	table.insert(choices, {
		label = "[New branch...]",
		id = "__new_branch__",
	})

	window:perform_action(
		wezterm.action.InputSelector({
			title = "Select Branch",
			choices = choices,
			fuzzy = true,
			fuzzy_description = "Branch: ",
			action = wezterm.action_callback(function(child_window, child_pane, id, _)
				if not id then
					return
				end

				if id == "__new_branch__" then
					child_window:perform_action(
						wezterm.action.PromptInputLine({
							description = "Enter name for new branch",
							action = wezterm.action_callback(function(prompt_window, prompt_pane, input)
								if not input or input == "" then
									return
								end

								add_worktree(prompt_window, prompt_pane, git_root, main_worktree_root, input, true)
							end),
						}),
						child_pane
					)
					return
				end

				add_worktree(child_window, child_pane, git_root, main_worktree_root, id, false)
			end),
		}),
		pane
	)
end

function module.choose_worktree()
	return wezterm.action_callback(function(window, pane)
		local cwd = session_utils.current_path(pane)
		if not cwd then
			session_utils.notify("Worktree", window, "Unable to determine the current directory", "warn")
			return
		end

		local git_root = get_git_root(cwd)
		if not git_root then
			session_utils.notify("Worktree", window, "Not in a git repository", "warn")
			return
		end

		local main_worktree_root = get_main_worktree_root(cwd) or git_root

		local worktrees, worktree_error = get_worktrees(git_root)
		if not worktrees then
			session_utils.notify("Worktree", window, worktree_error, "warn")
			return
		end

		local choices = {}
		local deletable_worktrees = {}

		for _, wt in ipairs(worktrees) do
			local label = worktree_label(wt)
			if wt.path == git_root then
				label = label .. " (current)"
			end

			if wt.path ~= main_worktree_root then
				table.insert(deletable_worktrees, wt)
			end

			table.insert(choices, {
				label = label,
				id = wt.path,
			})
		end

		table.insert(choices, {
			label = "[Create new worktree...]",
			id = "__create_new__",
		})

		if #deletable_worktrees > 0 then
			table.insert(choices, {
				label = "[Delete worktree...]",
				id = "__delete_worktree__",
			})
		end

		window:perform_action(
			wezterm.action.InputSelector({
				title = "Git Worktrees",
				choices = choices,
				fuzzy = true,
				fuzzy_description = "Worktree: ",
				action = wezterm.action_callback(function(child_window, child_pane, id, _)
					if not id then
						return
					end

					if id == "__create_new__" then
						create_worktree(child_window, child_pane, git_root, main_worktree_root, worktrees)
						return
					end

					if id == "__delete_worktree__" then
						local delete_choices = {}
						for _, wt in ipairs(deletable_worktrees) do
							table.insert(delete_choices, {
								label = worktree_label(wt) .. " (" .. wt.path .. ")",
								id = wt.path,
							})
						end

						child_window:perform_action(
							wezterm.action.InputSelector({
								title = "Delete Worktree",
								choices = delete_choices,
								fuzzy = true,
								fuzzy_description = "Delete worktree: ",
								action = wezterm.action_callback(function(del_window, _, del_id, _)
									if not del_id then
										return
									end

									local success, stdout, stderr = run_git({ "worktree", "remove", del_id }, git_root)
									if not success then
										session_utils.notify("Worktree", del_window, git_error_message(stdout, stderr), "warn")
									end
								end),
							}),
							child_pane
						)
						return
					end

					if id ~= git_root then
						workspaces.switch_to_path_workspace(child_window, child_pane, id)
					end
				end),
			}),
			pane
		)
	end)
end

return module
