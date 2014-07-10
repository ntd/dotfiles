-- Size of the sidebar where to put xnots and conky
local side_strut = 240

local terminal	 = 'roxterm'
local browser	 = 'firefox'
local email	 = 'sylpheed'
local filer	 = 'thunar'
local editor	 = 'gvim +Project'


local gears	 = require 'gears'
local awful	 = require 'awful'
awful.rules	 = require 'awful.rules'
		   require 'awful.autofocus'
local wibox	 = require 'wibox'
local beautiful	 = require 'beautiful'
local naughty	 = require 'naughty'
local menubar	 = require 'menubar'

local function debug(message)
    naughty.notify {
	preset = naughty.config.presets.low,
	title = 'Debug message',
	text = message
    }
end

if awesome.startup_errors then
    naughty.notify {
	preset = naughty.config.presets.critical,
	title = 'Oops, there were errors during startup!',
	text = awesome.startup_errors
    }
end

do
    local in_error = false
    awesome.connect_signal('debug::error', function (err)
	-- Make sure we don't go into an endless error loop
	if in_error then return end
	in_error = true
	naughty.notify {
	    preset = naughty.config.presets.critical,
	    title = 'Oops, an error happened!',
	    text = err
	}
	in_error = false
    end)
end

beautiful.init(awful.util.getdir('config') .. '/theme.lua')

local main
do
    local util = require 'awful.util'
    main = awful.widget.launcher {
	image = beautiful.awesome_icon,
	command = 'xfce4-appfinder -r'
    }
    local logout = function () awful.util.spawn('xfce4-session-logout') end
    local action = awful.button({}, 3, nil, logout)
    main:buttons(awful.util.table.join(main:buttons(), action))
end

-- Menubar configuration
menubar.utils.terminal = terminal

-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
modkey = 'Mod4'
mywibox = {}
mypromptbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
awful.button({ }, 1, awful.tag.viewonly),
awful.button({ modkey }, 1, awful.client.movetotag),
awful.button({ }, 3, awful.tag.viewtoggle),
awful.button({ modkey }, 3, awful.client.toggletag),
awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
awful.button({ }, 1, function (c)
    if c == client.focus then
	c.minimized = true
    else
	-- Without this, the following
	-- :isvisible() makes no sense
	c.minimized = false
	if not c:isvisible() then
	    awful.tag.viewonly(c:tags()[1])
	end
	-- This will also un-minimize
	-- the client, if needed
	client.focus = c
	c:raise()
    end
end),
awful.button({ }, 3, function ()
    if instance then
	instance:hide()
	instance = nil
    else
	instance = awful.menu.clients({
	    theme = { width = 250 }
	})
    end
end),
awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
    if client.focus then client.focus:raise() end
end),
awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
    if client.focus then client.focus:raise() end
end))

tags = {}
for s = 1, screen.count() do
    -- Set the wallpaper
    if beautiful.wallpaper then
	gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end

    -- Set the left strut for the sidebar
    awful.screen.padding(screen[s], { left = side_strut })

    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 'Shell', 'Web', 'Email', 'Spare' }, s, awful.layout.suit.tile)

    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()

    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox {
	position = 'top',
	screen = s
    }

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(main)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end

globalkeys = awful.util.table.join(
awful.key({ modkey,           }, 'h', awful.tag.viewprev       ),
awful.key({ modkey,           }, 'l', awful.tag.viewnext       ),
awful.key({ modkey,           }, 'Escape', awful.tag.history.restore),

awful.key({ modkey,           }, 'j',
function ()
    awful.client.focus.byidx( 1)
    if client.focus then client.focus:raise() end
end),
awful.key({ modkey,           }, 'k',
function ()
    awful.client.focus.byidx(-1)
    if client.focus then client.focus:raise() end
end),

-- Layout manipulation
awful.key({ modkey, 'Shift'   }, 'j', function () awful.client.swap.byidx(  1)    end),
awful.key({ modkey, 'Shift'   }, 'k', function () awful.client.swap.byidx( -1)    end),
awful.key({ modkey, 'Control' }, 'k', function () awful.screen.focus_relative(-1) end),
awful.key({ modkey,           }, 'u', awful.client.urgent.jumpto),
awful.key({ modkey,           }, 'Tab',
function ()
    awful.client.focus.history.previous()
    if client.focus then
	client.focus:raise()
    end
end),

-- External programs
awful.key({ modkey,           }, 't', function () awful.util.spawn(terminal) end),
awful.key({ modkey,           }, 'w', function () awful.util.spawn(browser) end),
awful.key({ modkey,           }, 'm', function () awful.util.spawn(email) end),
awful.key({ modkey,           }, 'f', function () awful.util.spawn(filer) end),
awful.key({ modkey,           }, 'e', function () awful.util.spawn(editor) end),
awful.key({ modkey,           }, '.', function () awful.util.spawn('galculator') end),

-- Standard program
awful.key({ modkey, 'Control' }, 'r', awesome.restart),
awful.key({ modkey, 'Shift'   }, 'q', awesome.quit),

awful.key({ modkey, 'Shift'   }, 'h', function () awful.tag.incnmaster( 1)      end),
awful.key({ modkey, 'Shift'   }, 'l', function () awful.tag.incnmaster(-1)      end),

awful.key({ modkey, 'Control' }, 'n', awful.client.restore),

-- Prompt
awful.key({ modkey },            'r',     function () mypromptbox[mouse.screen]:run() end),

awful.key({ modkey }, 'x',
function ()
    awful.prompt.run({ prompt = 'Run Lua code: ' },
    mypromptbox[mouse.screen].widget,
    awful.util.eval, nil,
    awful.util.getdir('cache') .. '/history_eval')
end),
-- Menubar
awful.key({ modkey }, 'p', function() menubar.show() end)
)

local function sendToTagAt(client, delta)
    local tag = client:tags()[1]
    if not tag then return end

    local idx
    for n, t in ipairs(tags[client.screen]) do
	if t.name == tag.name then
	    idx = n
	    break
	end
    end
    if not idx then return end

    idx = idx + delta
    if idx <= 0 then idx = #tags[client.screen] end

    awful.client.movetotag(tags[client.screen][idx])
end

clientkeys = awful.util.table.join(
awful.key({ modkey,           }, 'f',      function (c) c.fullscreen = not c.fullscreen  end),
awful.key({ modkey,           }, 'c',      function (c) c:kill()                         end),
awful.key({ modkey, 'Control' }, 'space',  awful.client.floating.toggle                     ),
awful.key({ modkey, 'Control' }, 'Return', function (c) c:swap(awful.client.getmaster()) end),
awful.key({ modkey, 'Control' }, 'l',      function (c) sendToTagAt(c,  1)               end),
awful.key({ modkey, 'Control' }, 'h',      function (c) sendToTagAt(c, -1)               end),
awful.key({ modkey,           }, 'n',      function (c)
    -- The client currently has the input focus, so it cannot be
    -- minimized, since minimized clients can't have the focus.
    c.minimized = true
end),
awful.key({ modkey,           }, 'z',      function (c)
    c.maximized_horizontal = not c.maximized_horizontal
    c.maximized_vertical   = not c.maximized_vertical
end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, '#' .. i + 9,
    function ()
	local screen = mouse.screen
	local tag = awful.tag.gettags(screen)[i]
	if tag then
	    awful.tag.viewonly(tag)
	end
    end),
    -- Toggle tag.
    awful.key({ modkey, 'Control' }, '#' .. i + 9,
    function ()
	local screen = mouse.screen
	local tag = awful.tag.gettags(screen)[i]
	if tag then
	    awful.tag.viewtoggle(tag)
	end
    end),
    -- Move client to tag.
    awful.key({ modkey, 'Shift' }, '#' .. i + 9,
    function ()
	if client.focus then
	    local tag = awful.tag.gettags(client.focus.screen)[i]
	    if tag then
		awful.client.movetotag(tag)
	    end
	end
    end),
    -- Toggle tag.
    awful.key({ modkey, 'Control', 'Shift' }, '#' .. i + 9,
    function ()
	if client.focus then
	    local tag = awful.tag.gettags(client.focus.screen)[i]
	    if tag then
		awful.client.toggletag(tag)
	    end
	end
    end))
end

clientbuttons = awful.util.table.join(
awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
awful.button({ modkey }, 1, awful.mouse.client.move),
awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)

do
    -- Override the focus filter to skip Conky and XNots clients too
    local old_filter = awful.client.focus.filter
    function awful.client.focus.filter(c)
	-- c.focusable ~= false is not enough, god knows why
	if c.class ~= 'Conky' and c.class ~= 'XNots' then
	    return old_filter(c)
	end
    end
end

-- Callback for centering clients
local function centering(c)
    awful.client.floating.set(c, true)
    c.maximized = false
    awful.placement.centered(c)
end

-- Rules to apply to new clients (through the 'manage' signal).
awful.rules.rules = {
    {
	rule_any = { class = { 'Conky', 'XNots' } },
	properties = {
	    floating = true,
	    focusable = false,
	    sticky = true,
	    width = side_strut,
	    border_width = 0,
	    buttons = clientbuttons
	}
    }, {
	rule = { class = 'Conky' },
	properties = {
	    size_hints = {
		win_gravity = 'south_west'
	    }
	},
    }, {
	rule = { class = 'XNots' },
	properties = {
	    height = 500,
	    size_hints = {
		win_gravity = 'north_west'
	    }
	},
    }, {
	rule = {}, except_any = { class = { 'Conky', 'XNots' } },
	properties = {
	    border_width = beautiful.border_width,
	    border_color = beautiful.border_normal,
	    focus = awful.client.focus.filter,
	    raise = true,
	    keys = clientkeys,
	    buttons = clientbuttons
	},
	callback = function (c)
	    if c.transient_for then return end
	    c.floating = false
	    c.maximized = false
	end
    }, {
	rule = { class = 'Firefox' },
	properties = { tag = tags[1][2] }
    }, {
	rule = { class = 'Sylpheed' },
	properties = { tag = tags[1][3] }
    }, {
	rule = { class = 'Galculator' },
	callback = centering
    }, {
	rule = { class = 'gimp' },
	properties = { floating = true }
    }, {
	rule = { class = 'Xfce4-appfinder' },
	properties = {
	    floating = true,
	    x = 40, y = 24
	},
}}

-- Signal function to execute when a new client appears.
client.connect_signal('manage', function (c, startup)
    -- Enable sloppy focus
    c:connect_signal('mouse::enter', function(c)
	if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
	    and awful.client.focus.filter(c) then
	    client.focus = c
	end
    end)

    if not startup then
	-- Put windows in a smart way, only if they does not set an initial position.
	if not c.size_hints.user_position and not c.size_hints.program_position then
	    awful.placement.no_overlap(c)
	    awful.placement.no_offscreen(c)
	end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == 'normal' or c.type == 'dialog') then
	-- buttons for the titlebar
	local buttons = awful.util.table.join(
	awful.button({ }, 1, function()
	    client.focus = c
	    c:raise()
	    awful.mouse.client.move(c)
	end),
	awful.button({ }, 3, function()
	    client.focus = c
	    c:raise()
	    awful.mouse.client.resize(c)
	end)
	)

	-- Widgets that are aligned to the left
	local left_layout = wibox.layout.fixed.horizontal()
	left_layout:add(awful.titlebar.widget.iconwidget(c))
	left_layout:buttons(buttons)

	-- Widgets that are aligned to the right
	local right_layout = wibox.layout.fixed.horizontal()
	right_layout:add(awful.titlebar.widget.floatingbutton(c))
	right_layout:add(awful.titlebar.widget.maximizedbutton(c))
	right_layout:add(awful.titlebar.widget.stickybutton(c))
	right_layout:add(awful.titlebar.widget.ontopbutton(c))
	right_layout:add(awful.titlebar.widget.closebutton(c))

	-- The title goes in the middle
	local middle_layout = wibox.layout.flex.horizontal()
	local title = awful.titlebar.widget.titlewidget(c)
	title:set_align('center')
	middle_layout:add(title)
	middle_layout:buttons(buttons)

	-- Now bring it all together
	local layout = wibox.layout.align.horizontal()
	layout:set_left(left_layout)
	layout:set_right(right_layout)
	layout:set_middle(middle_layout)

	awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal('focus', function(c) c.border_color = beautiful.border_focus end)
client.connect_signal('unfocus', function(c) c.border_color = beautiful.border_normal end)

local function run_once(process, cmd)
    local found = false
    local h = io.popen('nl /proc/*/cmdline')
    for l in h:lines() do
	found = l:find(process)
	if found then break end
    end
    h:close()

    -- Do not spawn the process if already started
    return not found and awful.util.spawn(cmd or process)
end

run_once('conky')
run_once('xnots')
run_once(terminal)
run_once(browser)
run_once(email)
run_once('liferea')
