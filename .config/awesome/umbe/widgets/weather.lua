local naughty = require("naughty")
local wibox = require('wibox')
local watch = require('awful.widget.watch')
local spawn = require('awful').spawn

local HOME = os.getenv("HOME")

local weather_widget = {}
local function worker(user_args)
    local args = user_args or {}
    local font = "Weather Icons 10"
    local margin_left = args.margin_left or 0
    local margin_right = args.margin_right or 0
    local timeout = args.timeout or 60 * 60 * 2

    local w = wibox.widget {
        font = font,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    weather_widget = wibox.widget {w, layout = wibox.layout.fixed.horizontal}

    local _, timer = watch(HOME .. "/.local/bin/openweatherwidget", timeout,
                           function(widget, stdout) widget.text = stdout end, w)

    -- TODO: try to create a pop-up with lua ans spawn the weather command
    -- instead of calling an external bash script.
    w:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then
            spawn.easy_async_with_shell(HOME ..
                                            "/.scripts/openweatherwidget_choose_city",
                                        function(stdout, _, _, exit_code)
                if exit_code == 0 then
                    naughty.notify {
                        title = "OpenWeather Widget",
                        text = "City changed to " .. stdout
                    }
                    timer:emit_signal("timeout")
                end
            end)
        end
    end)

    return wibox.container.margin(weather_widget, margin_left, margin_right)
end

return setmetatable(weather_widget,
                    {__call = function(_, ...) return worker(...) end})
