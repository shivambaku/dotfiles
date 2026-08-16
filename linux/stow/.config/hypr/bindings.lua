local main_mod = "SUPER"
local terminal = "wezterm start --always-new-process"
local noctalia = "noctalia msg "
local launcher = noctalia .. "panel-toggle launcher"
local file_manager = "nautilus"
local screenshot = noctalia .. "screenshot-region"
local clipboard = noctalia .. "panel-toggle clipboard"
local control_center = noctalia .. "panel-toggle control-center"
local window_search = noctalia .. "panel-open launcher /win"
local recorder = noctalia .. "plugin noctalia/screen_recorder:service all toggle"
local dictation = "voxtype record toggle"

local command_bindings = {}
local zen_command_bindings = {}

local function add_command_binding(keys, output_mods, key, bindings)
	local target = "activewindow"
	local binding = hl.bind(keys, function()
		hl.dispatch(hl.dsp.send_key_state({ mods = output_mods, key = key, state = "down", window = target }))
		hl.dispatch(hl.dsp.send_key_state({ mods = output_mods, key = key, state = "up", window = target }))
	end)

	table.insert(bindings, binding)
end

for _, key in ipairs({ "A", "C", "F", "K", "L", "O", "R", "S", "T", "V", "W", "X", "Y", "Z" }) do
	add_command_binding("ALT + " .. key, "CTRL", key, command_bindings)
	add_command_binding("ALT + SHIFT + " .. key, "CTRL|SHIFT", key, command_bindings)
end

for _, key in ipairs({ "N", "P" }) do
	add_command_binding("ALT + " .. key, "CTRL", key, zen_command_bindings)
	add_command_binding("ALT + SHIFT + " .. key, "CTRL|SHIFT", key, zen_command_bindings)
end

local function set_bindings_enabled(bindings, enabled)
	for _, binding in ipairs(bindings) do
		binding:set_enabled(enabled)
	end
end

local function update_command_bindings(window)
	local class = window and window.class or ""
	set_bindings_enabled(command_bindings, class ~= "" and class ~= "org.wezfurlong.wezterm")
	set_bindings_enabled(zen_command_bindings, class == "app.zen_browser.zen")
end

hl.on("window.active", update_command_bindings)
update_command_bindings(hl.get_active_window())

hl.bind(main_mod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(main_mod .. " + SPACE", hl.dsp.exec_cmd(launcher))
hl.bind(main_mod .. " + TAB", hl.dsp.exec_cmd(window_search))
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(file_manager))
hl.bind(main_mod .. " + V", hl.dsp.exec_cmd(clipboard))
hl.bind(main_mod .. " + C", hl.dsp.exec_cmd(control_center))
hl.bind(main_mod .. " + D", hl.dsp.exec_cmd(dictation))
hl.bind(main_mod .. " + Q", hl.dsp.window.close())
hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(main_mod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + CTRL + L", hl.dsp.exec_cmd(noctalia .. "session lock"))
hl.bind(main_mod .. " + CTRL + I", hl.dsp.exec_cmd(noctalia .. "caffeine-toggle"))
hl.bind(main_mod .. " + SHIFT + E", hl.dsp.exec_cmd(noctalia .. "panel-toggle session"))
hl.bind(main_mod .. " + S", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(main_mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratchpad" }))
hl.bind(main_mod .. " + SHIFT + R", hl.dsp.exec_cmd(recorder))

hl.bind(main_mod .. " + H", hl.dsp.layout("focus l"))
hl.bind(main_mod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(main_mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + L", hl.dsp.layout("focus r"))

hl.bind(main_mod .. " + SHIFT + H", hl.dsp.layout("swapcol l"))
hl.bind(main_mod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))
hl.bind(main_mod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind(main_mod .. " + SHIFT + L", hl.dsp.layout("swapcol r"))

hl.bind(main_mod .. " + R", hl.dsp.layout("colresize +conf"))
hl.bind(main_mod .. " + bracketleft", hl.dsp.window.move({ direction = "left" }))
hl.bind(main_mod .. " + bracketright", hl.dsp.layout("promote"))

for workspace = 1, 4 do
	hl.bind(main_mod .. " + " .. workspace, hl.dsp.focus({ workspace = workspace }))
	hl.bind(main_mod .. " + SHIFT + " .. workspace, hl.dsp.window.move({ workspace = workspace }))
end

hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("PRINT", hl.dsp.exec_cmd(screenshot))
hl.bind("ALT + SHIFT + 4", hl.dsp.exec_cmd(screenshot))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(noctalia .. "volume-up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(noctalia .. "volume-down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(noctalia .. "volume-mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(noctalia .. "mic-mute"), { locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(noctalia .. "brightness-up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(noctalia .. "brightness-down"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd(noctalia .. "media next"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(noctalia .. "media toggle"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(noctalia .. "media toggle"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(noctalia .. "media previous"), { locked = true })
