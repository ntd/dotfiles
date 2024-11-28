local wezterm = require 'wezterm'
local a = wezterm.action


local config = wezterm.config_builder()

-- MISCELLANEOUS SETTINGS
config.color_scheme = 'Monokai (dark) (terminal.sexy)'
config.cursor_thickness = 4
config.scrollback_lines = 10000
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "NONE"
config.inactive_pane_hsb = {
  brightness = 0.35,
}
config.text_background_opacity = 0.2

-- FONT SELECTION
config.font_size = 18

-- WINDOW PADDINGS
config.window_padding = {
  left = 4,
  right = 0,
  top = 4,
  bottom = 0,
}

-- Put in `cs` the active color scheme (I need it!)
local cs = wezterm.color.get_builtin_schemes()[config.color_scheme]

-- TERMINAL BACKGROUND
config.background = {
  {
    source = { Color = cs.background },
    width = '100%',
    height = '100%',
  }, {
    source = { File = '/home/nicola/docs/palude.jpeg' },
    repeat_x = 'NoRepeat',
    repeat_y = 'NoRepeat',
    opacity = 0.2,
  }
}

-- Custom signal for editing the scrollback contents,
-- directly borrowed from wezterm documentation
wezterm.on('trigger-scrollback-editing', function (window, pane)
  local name = os.tmpname()

  local f = io.open(name, 'w+')
  f:write(pane:get_lines_as_text())
  f:close()

  local cmd = os.getenv 'EDITOR' or 'vim'
  window:perform_action(
    a.SpawnCommandInNewTab {
      args = { cmd, name },
    },
    pane
  )

  wezterm.sleep_ms(1000)
  os.remove(name)
end)

-- KEYBINDINGS
config.keys = {
  -- Scrolling
  {
    mods = 'ALT',
    key = 'k',
    action = a.ScrollByLine(-1),
  }, {
    mods = 'SHIFT|ALT',
    key = 'k',
    action = a.ScrollByPage(-1),
  }, {
    mods = 'ALT',
    key = 'j',
    action = a.ScrollByLine(1),
  }, {
    mods = 'SHIFT|ALT',
    key = 'j',
    action = a.ScrollByPage(1),
  },

  -- Tab management
  {
    mods = 'ALT',
    key = 'n',
    action = a.SpawnTab 'CurrentPaneDomain',
  }, {
    mods = 'ALT',
    key = 'h',
    action = a.ActivateTabRelative(-1),
  }, {
    mods = 'ALT',
    key = 'l',
    action = a.ActivateTabRelative(1),
  }, {
    mods = 'CTRL|ALT',
    key = 'h',
    action = a.MoveTabRelative(-1),
  }, {
    mods = 'CTRL|ALT',
    key = 'l',
    action = a.MoveTabRelative(1),
  },

  -- Pane management
  {
    mods = 'CTRL|ALT',
    key = 'DownArrow',
    action = a.SplitVertical { domain = 'CurrentPaneDomain' },
  }, {
    mods = 'CTRL|ALT',
    key = 'RightArrow',
    action = a.SplitHorizontal { domain = 'CurrentPaneDomain' },
  }, {
    mods = 'ALT',
    key = 'LeftArrow',
    action = a.ActivatePaneDirection 'Left',
  }, {
    mods = 'ALT',
    key = 'RightArrow',
    action = a.ActivatePaneDirection 'Right',
  }, {
    mods = 'ALT',
    key = 'UpArrow',
    action = a.ActivatePaneDirection 'Up',
  }, {
    mods = 'ALT',
    key = 'DownArrow',
    action = a.ActivatePaneDirection 'Down',
  }, {
    mods = 'SHIFT|ALT',
    key = 'LeftArrow',
    action = a.AdjustPaneSize { 'Left', 4 },
  }, {
    mods = 'SHIFT|ALT',
    key = 'RightArrow',
    action = a.AdjustPaneSize { 'Right', 4 },
  }, {
    mods = 'SHIFT|ALT',
    key = 'UpArrow',
    action = a.AdjustPaneSize { 'Up', 4 },
  }, {
    mods = 'SHIFT|ALT',
    key = 'DownArrow',
    action = a.AdjustPaneSize { 'Down', 4 },
  },

  -- Other
  {
    mods = 'ALT',
    key = '+',
    action = a.IncreaseFontSize,
  }, {
    mods = 'ALT',
    key = '-',
    action = a.DecreaseFontSize,
  }, {
    mods = 'ALT',
    key = '0',
    action = a.ResetFontSize,
  }, {
    mods = 'SHIFT|ALT',
    key = 'l',
    action = a.ClearScrollback 'ScrollbackAndViewport',
  }, {
    mods = 'ALT',
    key = 'e',
    action = a.EmitEvent 'trigger-scrollback-editing',
  }, {
    mods = 'ALT',
    key = 's',
    action = a.Search { CaseInSensitiveString = '' },
  }, {
    mods = 'ALT',
    key = 'c',
    action = a.ActivateCopyMode,
  },
}

return config
