hl.config({
	input = {
		kb_layout = "us",
		kb_options = "caps:escape",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = false,
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
