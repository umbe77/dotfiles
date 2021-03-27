-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- Declarative object management
local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Object for global variables
local c_api = { screen = screen, tag = tag, client = client }

--- [[ Initialize remote procedures

require('umbe.remote.client_list').init()

--]]

local sticky_terminal = require('umbe.widgets.sticky_terminal')
local openweather_widget = require('umbe.widgets.weather')
local calendar_widget = require('awesome-wm-widgets.calendar-widget.calendar')
local batteryrc_widget = require(
                             'awesome-wm-widgets.batteryarc-widget.batteryarc')

local notfocusedfilter = function(c, s)
    if c.screen ~= s then return false end
    for _, t in ipairs(s.tags) do
        if t.selected then
            -- naughty.notify({
            --    title = "CLIENTS",
            --    text = tostring(t:tags())
            -- })
            for _, v in ipairs(c:tags()) do
                if v == t and client.focus ~= c then return true end
            end
        end
    end
    return false
end

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init(os.getenv("HOME") .. "/.config/awesome/umbe/theme/theme.lua")

-- This is used later as the default terminal and editor to run.
local terminal = "kitty"
local editor = os.getenv("EDITOR") or "nvim"
local editor_cmd = terminal .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Altr
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = "Mod4"
local altkey = "Mod1"
-- }}}

-- {{{ Tag
-- Table of layouts to cover with awful.layout.inc, order matters.
c_api.tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.max,
        awful.layout.suit.tile,
        awful.layout.suit.floating,
        -- awful.layout.suit.tile.left,
        -- awful.layout.suit.tile.bottom,
        -- awful.layout.suit.tile.top,
        -- awful.layout.suit.fair,
        -- awful.layout.suit.fair.horizontal,
        -- awful.layout.suit.spiral,
        -- awful.layout.suit.spiral.dwindle,
        -- awful.layout.suit.max.fullscreen,
        -- awful.layout.suit.magnifier,
        -- awful.layout.suit.corner.nw,
    })
end)

c_api.tag.connect_signal("property::layout", function(t)
    local name = awful.layout.getname(t.layout)
    local fn_titlebar = (name == "max" or name == "tile") and awful.titlebar.hide or awful.titlebar.show
    local clts = t:clients()
    for i in pairs(clts) do
       fn_titlebar(clts[i])
    end
end)
-- }}}

-- {{{ Wibar

-- Keyboard map indicator and switcher
local mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
local mytextclock = wibox.widget.textclock("%d/%m/%Y %H:%M")

local w_calendar = calendar_widget({
        theme = 'nord',
        placement = 'top_right',
        radius = 2
    })
mytextclock:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
        w_calendar.toggle()
    end
end)

local w_sticky_terminal = sticky_terminal({
    terminal_cmd = "kitty --class umbe_sticky_terminal tmux new -A -s sticky"
})


c_api.screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    awful.tag({ "", "", "", "", "旅", "", "切", "", "", "" }, s, awful.layout.layouts[1])

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox {
        screen  = s,
        buttons = {
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc(-1) end),
            awful.button({ }, 5, function () awful.layout.inc( 1) end),
        }
    }

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = {
            awful.button({ }, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1, function(t)
                                            if client.focus then
                                                client.focus:move_to_tag(t)
                                            end
                                        end),
            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                                            if client.focus then
                                                client.focus:toggle_tag(t)
                                            end
                                        end),
            awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
        }
    }

    -- Create a tasklist widget
    local tasklist_notfocus = awful.widget.tasklist {
        screen = s,
        filter = notfocusedfilter, -- awful.widget.tasklist.filter.minimizedcurrenttags,
        buttons = tasklist_buttons,
        layout = {spacing = 1, layout = wibox.layout.fixed.horizontal},
        -- Notice that there is *NO* wibox.wibox prefix, it is a template,
        -- not a widget instance.
        widget_template = {
            {
                {
                    {
                        {id = 'icon_role', widget = wibox.widget.imagebox},
                        margins = 5,
                        widget = wibox.container.margin
                    },
                    layout = wibox.layout.fixed.horizontal
                },
                -- left  = 10,
                -- right = 10,
                widget = wibox.container.margin
            },
            id = 'background_role',
            widget = wibox.container.background
        }
    }

    local tasklist_focused = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.focused,
        buttons = tasklist_buttons,
        layout = {spacing = 1, layout = wibox.layout.fixed.horizontal},
        -- Notice that there is *NO* wibox.wibox prefix, it is a template,
        -- not a widget instance.
        widget_template = {
            {
                {
                    {
                        {id = 'icon_role', widget = wibox.widget.imagebox},
                        margins = 5,
                        widget = wibox.container.margin
                    },
                    {id = 'text_role', widget = wibox.widget.textbox},
                    layout = wibox.layout.fixed.horizontal
                },
                -- left  = 10,
                -- right = 10,
                widget = wibox.container.margin
            },
            id = 'background_role',
            widget = wibox.container.background
        }
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, opacity = 0.80, bg = "#10151a" })

    -- Add widgets to the wibox
    local w_systray = wibox.widget.systray()
    w_systray["base_size"] = 18

    local w_power = wibox.widget {
        font = "Ubuntu Nerd Font Mono 10",
        markup = "<span foreground=\"#BF616A\">⏻</span>",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    w_power:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then
            awful.spawn.with_shell(os.getenv("HOME") ..
                                    "/.scripts/awesome_shutdown_ui")
        end
    end)

    s.mywibox.widget = {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mylayoutbox,
        },
        tasklist_focused,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            tasklist_notfocus,
            wibox.container.margin(w_sticky_terminal, 5, 5),
            mykeyboardlayout,
            -- batteryrc_widget({
            --        show_current_level = true,
            --        arc_thickness = 1
            --    }),
            openweather_widget({
                margin_left = 5,
                margin_right = 5,
            }),
            mytextclock,
            wibox.container.margin(w_power, 5, 5),
            wibox.container.margin(w_systray, 0, 5, 3),
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
-- awful.mouse.append_global_mousebindings({
--     awful.button({ }, 3, function () mymainmenu:toggle() end),
--     awful.button({ }, 4, awful.tag.viewprev),
--     awful.button({ }, 5, awful.tag.viewnext),
-- })
-- }}}

c_api.client.connect_signal("request::manage", function (c)
    if not awesome.startup then awful.client.setslave(c) end
end)

-- {{{ Key bindings

-- General Awesome keys
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "Applications"}),
    awful.key({ altkey }, "space", function () awful.spawn.with_shell("ulauncher-toggle") end,
              {description = "rofi launcher", group = "launcher"}),
    awful.key({ altkey }, "p", function () awful.spawn.with_shell("$HOME/.scripts/dmenu_run_colors") end,
              {description = "dmenu launcer", group = "launcher"}),
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    awful.key({ modkey }, ".", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey }, ",", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:activate { raise = true, context = "key.unminimize" }
                  end
              end,
              {description = "restore minimized", group = "client"}),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
})

-- Personal related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({modkey}, "d", function()
        sticky_terminal:toggle()
    end,
    {description = "toggle sticky terminal", group = "Applications"}),
    awful.key({modkey}, "e", function()
        awful.spawn("thunar")
    end,
    {description = "Open GUI file manager", group = "Applications"}),
})


awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local idx = index == 0 and 10 or index
            local tag = screen.tags[idx]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control" },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local idx = index == 0 and 10 or index
            local tag = screen.tags[idx]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },
    awful.key {
        modifiers = { modkey, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local idx = index == 0 and 10 or index
                local tag = client.focus.screen.tags[idx]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control", "Shift" },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local idx = index == 0 and 10 or index
                local tag = client.focus.screen.tags[idx]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function (index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    }
})

c_api.client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ modkey }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)

c_api.client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({  }, "F11",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "client"}),
        awful.key({ modkey }, "q",      function (c) c:kill()                         end,
                {description = "close", group = "client"}),
        awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
                {description = "toggle floating", group = "client"}),
        awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
                {description = "move to master", group = "client"}),
        awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
                {description = "move to screen", group = "client"}),
        awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
                {description = "toggle keep on top", group = "client"}),
        awful.key({ modkey,           }, "n",
            function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end ,
            {description = "minimize", group = "client"}),
        awful.key({ modkey,           }, "m",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end ,
            {description = "(un)maximize", group = "client"}),
        awful.key({ modkey, "Control" }, "m",
            function (c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end ,
            {description = "(un)maximize vertically", group = "client"}),
        awful.key({ modkey, "Shift"   }, "m",
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end ,
            {description = "(un)maximize horizontally", group = "client"}),
        awful.key({ modkey, "Shift" }, ".",
            function (c)
                c:move_to_screen(c.screen.index + 1)
            end,
            {description = "focus the previous screen", group = "screen"}),
        awful.key({ modkey, "Shift" }, ",",
            function (c)
                c:move_to_screen(c.screen.index - 1)
            end,
            {description = "focus the previous screen", group = "screen"}),
    })
end)

-- }}}

-- {{{ Rules
-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = { },
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    }

    -- Floating clients.
    ruled.client.append_rule {
        id       = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
            class    = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer",
                "Yad", "Ulauncher"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name    = {
                "Event Tester",  -- xev.
            },
            role    = {
                "AlarmWindow",    -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    }

    --Floating client with titlebars
    ruled.client.append_rule {
        id      = "floating_titlebar",
        rule_any = {
            class = {
                "Microsoft Teams - Preview",
                "Thunar",
                "openfortiGUI"
            }
        },
        properties = {
            floating = true,
            titlebars_enabled = true,
            placement = awful.placement.centered
        }
    }
    -- Add titlebars to normal clients and dialogs
    -- ruled.client.append_rule {
    --     id         = "titlebars",
    --     rule_any   = { type = { "normal", "dialog" } },
    --     properties = { titlebars_enabled = true      },
    --     callback =
    --         function(c)
    --             local t = c.first_tag
    --             local name = awful.layout.getname(t.layout)
    --             local fn_titlebar = (name == "max" or name == "tile") and awful.titlebar.hide or awful.titlebar.show
    --             fn_titlebar(c)
    --         end
    -- }

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- ruled.client.append_rule {
    --     rule       = { class = "Firefox"     },
    --     properties = { screen = 1, tag = "2" }
    -- }
end)

-- }}}

-- {{{ Notifications

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule       = { },
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
        }
    }
end)

naughty.connect_signal("request::display", function(n)
    naughty.layout.box { notification = n }
end)

-- }}}

-- {{{ run startup commands

awful.spawn.easy_async("setxkbmap -option grp:alt_shift_toggle us,it")
awful.spawn.easy_async("setxkbmap -option caps:escape")

-- }}}
