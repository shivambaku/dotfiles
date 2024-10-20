-- https://wezfurlong.org/wezterm/config/lua/general.html
local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

-- Window 
config.window_decorations = "RESIZE"
config.window_padding = {
  bottom = 0
}

-- Styling
config.color_scheme = 'Tokyo Night'

-- Fonts
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 14

-- Tabs
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

-- Keymapping 
config.leader = { key = "k", mods = "CMD", timeout_milliseconds = 2000 }
config.keys = {

  -- Disable defaults
  {
    mods = 'CMD',
    key = 'k',
    action = act.DisableDefaultAssignment,
  },
  {
    mods = 'CMD',
    key = 'n',
    action = act.DisableDefaultAssignment,
  },
  -- Wezterm 
  {
    mods = 'LEADER | CMD',
    key = 'n',
    action = act.SpawnTab "CurrentPaneDomain",
  },
  {
    mods = 'LEADER | CMD',
    key = '1',
    action = act.ActivateTab(0),
  },
  {
    mods = 'LEADER | CMD',
    key = '2',
    action = act.ActivateTab(1),
  },
  {
    mods = 'LEADER | CMD',
    key = '3',
    action = act.ActivateTab(2),
  },
  {
    mods = 'LEADER | CMD',
    key = '4',
    action = act.ActivateTab(3),
  },
  {
    mods = 'LEADER | CMD',
    key = '5',
    action = act.ActivateTab(4),
  },
  -- Neovim
  -- Telescope fuzzy file finder
  {
    mods = 'CMD',
    key = 'p',
    action = act.Multiple {
      act.SendKey { key = ' ' },
      act.SendKey { key = 'f' },
      act.SendKey { key = 'f' },
    },
  },
  -- Telescope fuzzy lsp symbol finder
  {
    mods = 'CMD',
    key = 'o',
    action = act.Multiple {
      act.SendKey { key = ' ' },
      act.SendKey { key = 'f' },
      act.SendKey { key = 's' },
    },
  },
  -- Harpoon navigation
  {
    mods = 'CMD',
    key = '1',
    action = act.SendKey { mods = 'ALT', key = '!' },
  },
  {
    mods = 'CMD',
    key = '2',
    action = act.SendKey { mods = 'ALT', key = '@' },
  },
  {
    mods = 'CMD',
    key = '3',
    action = act.SendKey { mods = 'ALT', key = '#' },
  },
  {
    mods = 'CMD',
    key = '4',
    action = act.SendKey { mods = 'ALT', key = '$' },
  },
  {
    mods = 'CMD',
    key = '5',
    action = act.SendKey { mods = 'ALT', key = '%' },
  },
  {
    mods = 'CMD',
    key = 'h',
    action = act.SendKey { mods = 'ALT', key = 'h' },
  }
}

return config
