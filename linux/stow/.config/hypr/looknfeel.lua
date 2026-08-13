hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
	general = {
		gaps_in = 1,
		gaps_out = 1,
		border_size = 1,
		["col.active_border"] = "rgb(89b4fa)",
		["col.inactive_border"] = "rgb(313244)",
		layout = "dwindle",
	},
	decoration = {
		rounding = 2,
	},
	animations = {
		enabled = false,
	},
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		force_default_wallpaper = 0,
		background_color = "rgb(0a0c10)",
	},
	dwindle = {
		preserve_split = true,
		force_split = 2,
	},
})

for workspace = 1, 4 do
	hl.workspace_rule({ workspace = tostring(workspace), persistent = true })
end

hl.window_rule({
	name = "waybar-tools",
	match = { class = "^waybar-tool-.*$" },
	float = true,
	center = true,
	size = "900 650",
})
