hl.config({
	input = {
		kb_layout = "us",
		kb_options = "caps:escape",
		follow_mouse = 1,
		sensitivity = 0,
		force_no_accel = true,
		touchpad = {
			natural_scroll = false,
			scroll_factor = 0.5,
			tap_to_click = true,
			disable_while_typing = true,
		},
	},
	gestures = {
		workspace_swipe_invert = false,
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})
