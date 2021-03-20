-------------------------------
--  "Nord" awesome theme     --
--  by hmix adapted from     --
--  zenburn theme            --
--    By Adrian C. (anrxc)   --
-------------------------------

local themes_path = os.getenv("HOME") .. "/.config/awesome/umbe/theme/"
local dpi = require("beautiful.xresources").apply_dpi

local nice = require("nice")
nice({
    titlebar_height = 25,
    titlebar_radius = 0,
    mb_resize = nice.MB_MIDDLE,
    mb_contextmenu = nice.MB_RIGHT,
    close_color = "#BF616A",
    maximize_color = "#A3BE8C",
    minimize_color = "#EBCB8B",
    sticky_color = "#B48EAD",
    titlebar_items = {
        left = {"close", "maximize", "minimize"},
        middle = "title",
        right = {"sticky"}
    }
})

-- {{{ Main
local theme = {}
-- }}}

-- {{{ Styles
theme.font      = "sans 10"
--theme.font      = "Ubuntu Nerd Font 10"
theme.taglist_font      = "Ubuntu Nerd Font Mono 8"

-- {{{ Colors
theme.fg_normal  = "#D8DEE9"
theme.fg_focus   = "#D8DEE9"
theme.fg_urgent  = "#D8DEE9"
theme.bg_normal  = "#10151A"
theme.bg_focus   = "#10151A"
theme.bg_urgent  = "#10151A"
-- }}}

-- {{ taglist
theme.taglist_fg_focus = "#D8DEE9"
theme.taglist_fg_occupied = "#D8DEE9"
theme.taglist_fg_empty = "#D8DEE9"
theme.taglist_fg_urgent = "#D8DEE9"
theme.taglist_bg_focus = "#4C566A"
theme.taglist_bg_occupied = "#10151A"
theme.urgent = "#BF616A"
-- }}

-- {{{ Borders
theme.useless_gap   = dpi(0)
theme.border_width  = dpi(1)
theme.border_normal = "#3B4252"
theme.border_focus  = "#4C566A"
theme.border_marked = "#D08770"
-- }}}

theme.bg_systray = theme.bg_normal
--theme.systray_icon_spacing = 2


-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#D08770"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#A3BE8C"
--theme.fg_center_widget = "#8FBCBB"
--theme.fg_end_widget    = "#BF616A"
--theme.bg_widget        = "#434C5E"
--theme.border_widget    = "#3B4252"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#D08770"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = themes_path .. "taglist/square_sel_nord.png"
theme.taglist_squares_sel_empty   = themes_path .. "taglist/square_sel_nord.png"
theme.taglist_squares_unsel = themes_path .. "taglist/square_unsel_nord.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = themes_path .. "awesome-icon.png"
theme.menu_submenu_icon      = themes_path .. "default/submenu.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = themes_path .. "layouts/tile.png"
theme.layout_tileleft   = themes_path .. "layouts/tileleft.png"
theme.layout_tilebottom = themes_path .. "layouts/tilebottom.png"
theme.layout_tiletop    = themes_path .. "layouts/tiletop.png"
theme.layout_fairv      = themes_path .. "layouts/fairv.png"
theme.layout_fairh      = themes_path .. "layouts/fairh.png"
theme.layout_spiral     = themes_path .. "layouts/spiral.png"
theme.layout_dwindle    = themes_path .. "layouts/dwindle.png"
theme.layout_max        = themes_path .. "layouts/max.png"
theme.layout_fullscreen = themes_path .. "layouts/fullscreen.png"
theme.layout_magnifier  = themes_path .. "layouts/magnifier.png"
theme.layout_floating   = themes_path .. "layouts/floating.png"
theme.layout_cornernw   = themes_path .. "layouts/cornernw.png"
theme.layout_cornerne   = themes_path .. "layouts/cornerne.png"
theme.layout_cornersw   = themes_path .. "layouts/cornersw.png"
theme.layout_cornerse   = themes_path .. "layouts/cornerse.png"
-- }}}


-- {{{ batteryarc_widget
theme.widget_main_color = "#88C0D0"
theme.widget_red = "#BF616A"
theme.widget_yellow = "#EBCB8B"
theme.widget_green = "#A3BE8C"
theme.widget_black = "#000000"
theme.widget_transparent = "#00000000"
-- }}}

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
