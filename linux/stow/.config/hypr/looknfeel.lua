hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
	general = {
		gaps_in = 1,
		gaps_out = 1,
		border_size = 1,
		["col.active_border"] = "rgb(89b4fa)",
		["col.inactive_border"] = "rgb(313244)",
		layout = "scrolling",
	},
	decoration = {
		rounding = 2,
	},
	animations = {
		enabled = true,
	},
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		force_default_wallpaper = 0,
		background_color = "rgb(0a0c10)",
	},
	scrolling = {
		fullscreen_on_one_column = true,
		column_width = 0.5,
		focus_fit_method = 1,
		follow_focus = true,
		explicit_column_widths = "0.5, 1.0",
		wrap_focus = false,
		wrap_swapcol = false,
	},
})

hl.curve("quickFade", { type = "bezier", points = { { 0.2, 0 }, { 0, 1 } } })
hl.animation({ leaf = "windows", enabled = true, speed = 1, bezier = "quickFade" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1, bezier = "quickFade" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1, bezier = "quickFade" })
hl.animation({ leaf = "workspaces", enabled = false })

for workspace = 1, 4 do
	hl.workspace_rule({ workspace = tostring(workspace), persistent = true })
end

hl.window_rule({ match = { class = "^org\\.satty\\.satty$" }, float = true })
hl.window_rule({ match = { class = "^org\\.satty\\.satty$" }, center = true })

hl.window_rule({ match = { class = "^lounge-todos$" }, float = true })
hl.window_rule({ match = { class = "^lounge-todos$" }, center = true })
hl.window_rule({ match = { class = "^lounge-todos$" }, size = { 900, 700 } })

hl.window_rule({ match = { class = "^xdg-desktop-portal-gtk$" }, float = true })
hl.window_rule({ match = { class = "^xdg-desktop-portal-gtk$" }, center = true })
hl.window_rule({ match = { class = "^xdg-desktop-portal-gtk$" }, size = { 1000, 700 } })

hl.window_rule({ match = { class = "^hyprland-share-picker$" }, float = true })
hl.window_rule({ match = { class = "^hyprland-share-picker$" }, center = true })
hl.window_rule({ match = { class = "^hyprland-share-picker$" }, size = { 800, 500 } })
