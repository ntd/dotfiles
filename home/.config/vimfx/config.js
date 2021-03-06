let options = {
  "config_file_directory": "~/.config/vimfx",
  "mode.normal.history_back": "J",
  "mode.normal.history_forward": "K",
  "mode.normal.tab_select_previous": "H",
  "mode.normal.tab_select_next": "L"
}
Object.entries(options).forEach(([option, value]) => vimfx.set(option, value))
