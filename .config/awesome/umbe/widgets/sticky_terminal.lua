local naughty = require("naughty")
local wibox = require('wibox')
local awful = require('awful')
local spawn = require('awful').spawn
local client = client

local HOME = os.getenv("HOME")

local terminal = "kitty --class umbe_sticky_terminal"
local c = nil
local sticky_terminal_widget = {mt = {}}
local w = {}
local raise_terminal = function()
    if c == nil then
        spawn(terminal, {
            name = "umbe_sticky_terminal",
            floating = true,
            sticky = true,
            ontop = true,
            width = awful.screen.focused().geometry.width * 0.98,
            height = awful.screen.focused().geometry.height * 0.95,
            skip_taskbar = true,
            placement = awful.placement.centered + awful.placement.no_offscreen,
            callback = function(clt)
                clt:connect_signal("unmanage", function(u_clt)
                    c = nil
                    w:set_markup('<span foreground="#EBCB8B"></span>')
                end)
                clt:connect_signal("property::hidden", function(h_clt)
                    if not c.hidden then
                        c.placement = awful.placement.centered +
                                          awful.placement.no_offscreen
                        client.focus = c
                    end
                end)
                c = clt
                w:set_markup('<span foreground="#EBCB8B">車</span>')
            end
        })
    else
        c.hidden = not c.hidden
        w:set_markup(c.hidden and '<span foreground="#EBCB8B"></span>' or
                         '<span foreground="#EBCB8B">車</span>')
    end
end

function sticky_terminal_widget:toggle() raise_terminal() end

local worker = function(user_args)
    local args = user_args or {}
    if args.terminal_cmd then terminal = args.terminal_cmd end
    local font = "Ubuntu Nerd Font Mono 10"

    w = wibox.widget {
        font = font,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    sticky_terminal_widget = wibox.widget {
        w,
        layout = wibox.layout.fixed.horizontal
    }

    w:set_markup('<span foreground="#EBCB8B"></span>')

    w:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then raise_terminal() end
    end)

    return sticky_terminal_widget

end

function sticky_terminal_widget.mt.__call(_, ...) return worker(...) end

return setmetatable(sticky_terminal_widget, sticky_terminal_widget.mt)

