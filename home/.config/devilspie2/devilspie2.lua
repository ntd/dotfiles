-- Cache the most common terms
local name     = get_window_name()
local class    = get_window_class()
local role     = get_window_role()
local instance = get_class_instance_name()

-- `elapsed` contains the number of seconds elapsed from the start
local elapsed
if _G.start_timestamp then
    elapsed = os.time() - _G.start_timestamp
else
    elapsed = 0
    _G.start_timestamp = os.time()
end

debug_print(
    'Name:     ' .. name     .. '\n' ..
    'Class:    ' .. class    .. '\n' ..
    'Role:     ' .. role     .. '\n' ..
    'Instance: ' .. instance .. '\n' ..
    'Elapsed:  ' .. elapsed  .. ' seconds\n'
)

local is_maximized = get_window_is_maximized()

-- Workaround because get_window_is_maximized() always returns `false`
local function real_maximize()
    maximize()
    is_maximized = true
end

local function put_in_workspace(n)
    set_window_workspace(n)

    -- Change workspace and focus the window only **after** arranging
    -- the desktop environment for the first time. I start a firefox
    -- instance with a 5 seconds delay, so consider the desktop
    -- environment "arranged" only after 10 seconds.
    if elapsed > 10 then
        change_workspace(n)
        -- XXX: crashes the application with the following error:
        --     BadMatch (invalid parameter attributes)
        -- focus_window()
    end
end

local function is_terminal()
    local valid_classes = {
        ['Roxterm'] = true,
        ['Xfce4-terminal'] = true,
        ['Lxterminal'] = true,
        ['terminology'] = true,
        ['kitty'] = true,
        ['org.wezfurlong.wezterm'] = true,
        ['Tilix'] = true,
        ['com.mitchellh.ghostty'] = true,
    }
    return valid_classes[class] or false
end

if class == 'Firefox' then
    put_in_workspace(2)
    if instance == 'Navigator' then
        real_maximize()
    end
elseif class == 'Luakit' then
    put_in_workspace(2)
    real_maximize()
elseif class == 'keepassxc' then
    -- This must be configured to show a tray icon
    pin_window()
    set_skip_tasklist(true)
    maximize_window_horisontally()
elseif is_terminal() then
    put_in_workspace(1)
    if get_window_property('WM_TRANSIENT_FOR') == '' then
        real_maximize()
    end
elseif class == 'mpv' then
    set_window_fullscreen(true)
elseif class == 'Claws-mail' or class == 'Evolution' then
    put_in_workspace(3)
    -- I use a trayicon on both
    set_skip_tasklist(true)
    if role == 'mainwindow' or get_window_property('WM_TRANSIENT_FOR') == '' then
        real_maximize()
    end
elseif class == 'crawl-tiles' then
    real_maximize()
elseif class == 'Zim' then
    put_in_workspace(4)
    maximize_horizontally()
elseif class == 'xpad' and role then
    set_window_above(true)
    pin_window()
    stick_window()
elseif class == 'Transmission-gtk' then
    -- I use a trayicon instead
    set_skip_tasklist(true)
    maximize_window_horisontally()
elseif class == 'skypeforlinux' or class == 'TelegramDesktop' then
    -- I use a trayicon on both
    pin_window()
    set_skip_tasklist(true)
end

if is_maximized then
    undecorate_window()
end
