local startup_timer

local function sync_visualizer()
	local workspace = hl.get_workspace("5")
	local action = workspace and workspace.active and "show" or "hide"
	hl.exec_cmd("noctalia msg desktop-widgets-" .. action)
end

hl.on("workspace.active", sync_visualizer)
hl.on("workspace.move_to_monitor", sync_visualizer)

hl.on("hyprland.start", function()
	startup_timer = hl.timer(sync_visualizer, { timeout = 1000, type = "oneshot" })
end)
