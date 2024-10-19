-- https://wezfurlong.org/wezterm/config/lua/general.html
local wezterm = require 'wezterm'
local config = {}

-- Window 
config.window_decorations = "RESIZE"

-- Styling
config.color_scheme = 'Tokyo Night'

-- Fonts
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 14

-- Tabs
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

return config
