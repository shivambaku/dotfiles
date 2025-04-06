local wezterm = require("wezterm")
local module = {}

local notes_dir_from_home = "/Documents/Notes"
local editor_path = "/opt/homebrew/bin/nvim"

local function notes_paths()
	local notes = {}
	for _, file in ipairs(wezterm.glob(wezterm.home_dir .. notes_dir_from_home .. "/*.md")) do
		table.insert(notes, file)
	end
	return notes
end

function module.choose_note()
	return wezterm.action_callback(function(window, pane)
		local choices = {}
		for _, value in ipairs(notes_paths()) do
			local filename = value:match("^.+/(.+)$") or value
			local label = filename:gsub("%.md$", "")
			table.insert(choices, { id = value, label = label })
		end

		window:perform_action(
			wezterm.action.InputSelector({
				title = "Notes",
				choices = choices,
				fuzzy = true,
				fuzzy_description = "Notes: ",
				action = wezterm.action_callback(function(child_window, child_pane, id, label)
					if not id then
						return
					end

					child_window:perform_action(
						wezterm.action.SwitchToWorkspace({
							name = "Notes: " .. label,
							spawn = {
								cwd = wezterm.home_dir .. notes_dir_from_home,
								args = { editor_path, id },
							},
						}),
						child_pane
					)
				end),
			}),
			pane
		)
	end)
end

function module.create_note()
	return wezterm.action_callback(function(window, pane)
		window:perform_action(
			wezterm.action.PromptInputLine({
				description = "Enter a name for the new note:",
				initial_value = "",
				action = wezterm.action_callback(function(_, _, note_name)
					if note_name and note_name ~= "" then
						if not note_name:match("%.md$") then
							note_name = note_name .. ".md"
						end

						local note_path = wezterm.home_dir .. notes_dir_from_home .. "/" .. note_name

						window:perform_action(
							wezterm.action.SwitchToWorkspace({
								name = "Notes: " .. note_name,
								spawn = {
									cwd = wezterm.home_dir .. notes_dir_from_home,
									args = { editor_path, note_path },
								},
							}),
							pane
						)
					end
				end),
			}),
			pane
		)
	end)
end

return module
