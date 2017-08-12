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

if class == 'Firefox' then
    set_window_workspace(2)
    if instance == 'Navigator' then
        maximize()
    end
end

if class == 'Roxterm' or class == 'Xfce4-terminal' or class == 'Lxterminal' then
    set_window_workspace(1)
    -- Maximize only the main windows (not the preference dialogs)
    if get_window_property('WM_TRANSIENT_FOR') == '' then
        maximize()
    end
end

if class == 'mpv' then
    set_window_fullscreen(true)
end

if class == 'Claws-mail' then
    set_window_workspace(3)
    change_workspace(3)
    if role == 'mainwindow' then
        maximize()
    end
end

if class == 'crawl-tiles' then
    maximize()
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

if class == 'skypeforlinux' then
    pin_window()
    set_skip_tasklist(true)
end

if get_window_is_maximized() then
    undecorate_window()
end
