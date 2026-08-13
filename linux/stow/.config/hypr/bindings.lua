local main_mod = "SUPER"
local terminal = "wezterm"
local launcher = "fuzzel"
local file_manager = "nautilus"
local screenshot = [[grim -g "$(slurp)" -t ppm - | satty --filename - --fullscreen --copy-command wl-copy]]
local clipboard = [[cliphist list | fuzzel --dmenu --minimal-lines | cliphist decode | wl-copy]]

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

for _, key in ipairs({ "A", "C", "F", "L", "O", "Q", "R", "S", "T", "V", "W", "X", "Y", "Z" }) do
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
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(file_manager))
hl.bind(main_mod .. " + V", hl.dsp.exec_cmd(clipboard))
hl.bind(main_mod .. " + Q", hl.dsp.window.close())
hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(main_mod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + CTRL + L", hl.dsp.exec_cmd("pidof hyprlock || hyprlock"))
hl.bind(main_mod .. " + SHIFT + E", hl.dsp.exit())

hl.bind(main_mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(main_mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + L", hl.dsp.focus({ direction = "right" }))

hl.bind(main_mod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind(main_mod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))
hl.bind(main_mod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind(main_mod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "right" }))

for workspace = 1, 4 do
	hl.bind(main_mod .. " + " .. workspace, hl.dsp.focus({ workspace = workspace }))
	hl.bind(main_mod .. " + SHIFT + " .. workspace, hl.dsp.window.move({ workspace = workspace }))
end

hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("PRINT", hl.dsp.exec_cmd(screenshot))

hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
