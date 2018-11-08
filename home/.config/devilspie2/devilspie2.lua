-- Cache the most common terms
local name     = get_window_name()
local class    = get_window_class()
local role     = get_window_role()
local instance = get_class_instance_name()
local type     = get_window_type()

debug_print(
    'Name:     ' .. name     .. '\n' ..
    'Class:    ' .. class    .. '\n' ..
    'Role:     ' .. role     .. '\n' ..
    'Instance: ' .. instance .. '\n' ..
    'Type:     ' .. type     .. '\n'
)

-- Workaround because this code does not work:
--     maximize()
--     debug_print(get_window_is_maximized()) -- Print false
local is_maximized = get_window_is_maximized()
function real_maximize()
    maximize()
    is_maximized = true
end

if class == 'Firefox' or class == 'keepassxc' then
    set_window_workspace(2)
    if instance == 'Navigator' then
        real_maximize()
    end
end

-- This must be configured to show a tray icon
if class == 'keepassx' then
    pin_window()
    set_skip_tasklist(true)
end

if class == 'Roxterm' or class == 'Xfce4-terminal' or class == 'Lxterminal' or class == 'terminology' then
    set_window_workspace(1)
    if get_window_property('WM_TRANSIENT_FOR') == '' then
        real_maximize()
    end
end

if class == 'mpv' then
    set_window_fullscreen(true)
end

if class == 'Claws-mail' or class == 'Evolution' then
    set_window_workspace(3)
    change_workspace(3)
    if role == 'mainwindow' or get_window_property('WM_TRANSIENT_FOR') == '' then
        real_maximize()
    end
end

if class == 'crawl-tiles' then
    real_maximize()
end

if class == 'Zim' then
    set_window_workspace(4)
    change_workspace(4)
    maximize_horizontally()
end

if class == 'xpad' and role then
    set_window_above(true)
    pin_window()
    stick_window()
end

-- This must be configured to show a tray icon
if class == 'skypeforlinux' or class == 'TelegramDesktop' then
    pin_window()
    set_skip_tasklist(true)
end

if is_maximized then
    undecorate_window()
end
