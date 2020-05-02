local awful = require('awful')
local gears = require("gears")
local wibox = require('wibox')

local widget = wibox.widget {
    resize = true,
    widget = wibox.widget.textbox
}


widget:buttons(gears.table.join(
    awful.button({  }, 1,
        function ()
            awful.spawn.easy_async("polybar_weather_click", function (stdout, stderr, exitreason, exitcode)
                --do nothing
            end)
        end)
))

local weather = awful.widget.watch(
    "polybar_weather",
    10,
    function (widget, stdout) 
        widget:set_text (stdout)
    end,
    widget
)

return weather
