local beautiful= require('beautiful')
local naughty = require("naughty")

local ui = {
    original_gap = 0,
    show_no_gap = false
}

function ui:init()
    return self
end

function ui:toggle_gaps ()

    if (self.show_no_gap) then
        beautiful.useless_gap = 0
        self.show_no_gap = false
    else
        beautiful.useless_gap = 3
        self.show_no_gap = true
    end
end

return ui:init()
