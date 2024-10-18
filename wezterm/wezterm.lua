-- https://wezfurlong.org/wezterm/config/lua/general.html
local wezterm = require 'wezterm'
local config = {}

-- Window Appearance 
config.window_decorations = "RESIZE"

-- Styling
config.color_scheme = 'Tokyo Night'
config.font_size = 14

-- Tabs
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

return config
