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
        undecorate_window()
        maximize()
    end
end

if class == 'Roxterm' or class == 'Xfce4-terminal' then
    set_window_workspace(1)
    -- The 'Pref' check is a hack to avoid maximizing the preference
    -- dialog of xfce4-terminal (which BTW is *not* a dialog).
    -- Better would be to check for a transient parent... after having
    -- implemented that on devilspie2 I would use something like:
    -- if get_window_property('WM_TRANSIENT_FOR') ~= '' then
    if type ~= 'WINDOW_TYPE_DIALOG' and name:sub(1,4) ~= 'Pref' then
        undecorate_window()
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
        undecorate_window()
        maximize()
    end
end

if class == 'crawl-tiles' then
    maximize()
end
