# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from Xlib import display as xdisplay
from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.lazy import lazy
from libqtile import layout, bar, widget

from typing import List  # noqa: F401

from umbe.widgets import ShellScript
from umbe.weather import Weather

import xrp
xrdb = xrp.parse_file('.cache/wal/colors.Xresources', encoding='UTF8')

# this import requires python-xlib to be installed


def get_num_monitors():
    num_monitors = 0
    try:
        display = xdisplay.Display()
        screen = display.screen()
        resources = screen.root.xrandr_get_screen_resources()

        for output in resources.outputs:
            monitor = display.xrandr_get_output_info(
                output, resources.config_timestamp)
            preferred = False
            if hasattr(monitor, "preferred"):
                preferred = monitor.preferred
            elif hasattr(monitor, "num_preferred"):
                preferred = monitor.num_preferred
            if preferred:
                num_monitors += 1
    except Exception as e:
        # always setup at least one monitor
        return 1
    else:
        return num_monitors


num_monitors = get_num_monitors()

mod = "mod4"

keys = [
    # Switch between windows in current stack pane
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "l", lazy.layout.right()),

    Key([mod], "i", lazy.layout.grow()),
    Key([mod], "s", lazy.layout.shrink()),
    Key([mod], "n", lazy.layout.normalize()),
    Key([mod], "m", lazy.layout.maximize()),

    Key([mod], "f", lazy.window.toggle_floating()),
    # Move windows up or down in current stack
    Key([mod, "control"], "k", lazy.layout.shuffle_down()),
    Key([mod, "control"], "j", lazy.layout.shuffle_up()),

    # Switch window focus to other pane(s) of stack
    Key([mod], "space", lazy.next_layout()),

    # Swap panes of split stack
    Key([mod, "shift"], "space", lazy.layout.rotate()),

    Key([mod], "b", lazy.hide_show_bar()),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split()),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.layout.next()),
    Key([mod], "q", lazy.window.kill()),

    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod], "period", lazy.next_screen()),
    Key([mod], "comma", lazy.prev_screen()),
    # Key([mod, "shift"], "period", lazy.window.toscreen(1)),
    # Key([mod, "shift"], "comma", lazy.window.toscreen(0)),
]

#groups = [Group(i) for i in "1234567890"]
groups = [
    Group("1", label="1"),
    Group("2", label="2"),
    Group("3", label="3"),
    Group("4", label="4"),
    Group("5", label="5"),
    Group("6", label="6"),
    Group("7", label="7"),
    Group("8", label="8"),
    Group("9", label="9"),
    Group("0", label="0"),
    Group("01", label="01"),
    Group("02", label="02"),
    Group("03", label="03"),
    Group("04", label="04"),
    Group("05", label="05"),
    Group("06", label="06"),
    Group("07", label="07"),
    Group("08", label="08"),
    Group("09", label="09"),
    Group("00", label="00"),
]

for i in "1234567890":
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i,
            lazy.to_screen(0),
            lazy.group[i].toscreen(toggle=False)),
        Key(["mod1"], i,
            lazy.to_screen(1),
            lazy.group['0' + i].toscreen(toggle=False)),
        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], i,
            lazy.window.togroup(i),
            lazy.to_screen(0)),
        Key(["mod1", "shift"], i,
            lazy.window.togroup("0" + i),
            lazy.to_screen(1)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
    ])

layoutConfigs = dict(
    border_normal='#000000',
    border_focus=xrdb.resources['*color12'],
    border_width=2,
)

layouts = [
    layout.MonadTall(**layoutConfigs),
    layout.Tile(ratio=0.5, add_on_top=False,
                add_after_last=True, **layoutConfigs),
    layout.Max(**layoutConfigs),
    # layout.Stack(num_stacks=2),
    # Try more layouts by unleashing below layouts.
    # layout.Bsp(),
    # layout.Columns(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    layout.TreeTab(
        bg_color=xrdb.resources['*background'],
        active_bg=xrdb.resources['*color4'],
        inactive_bg=xrdb.resources['*color1'],
        active_fg=xrdb.resources['*foreground'],
        inactive_fg=xrdb.resources['*foreground'],
        **layoutConfigs),
    # layoutVerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font='Fira Code',
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

groupbox_config = dict(
    highlight_method='line',
    highlight_color=[xrdb.resources['*color1']],
    inactive=xrdb.resources['*color4'],
    rounded=False,
    this_current_screen_border=xrdb.resources['*color12'],
    active=xrdb.resources['*foreground'],
)

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayoutIcon(),
                widget.GroupBox(visible_groups=[
                                '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'], **groupbox_config),
                widget.WindowName(),
                widget.TextBox(text="[M 1]"),
                widget.TextBox(text='['),
                widget.PulseVolume(),
                widget.Sep(),
                Weather(update_interval=10, padding=1),
                widget.Sep(),
                widget.Clock(format='%d/%m/%Y %H:%M'),
                widget.Sep(),
                widget.TextBox(text=']'),
                widget.Systray(),
            ],
            24,
            background=xrdb.resources['*background']
        ),
    ),
]

if num_monitors > 1:
    for m in range(num_monitors - 1):
        screens.append(
            Screen(
                top=bar.Bar(
                    [
                        widget.CurrentLayoutIcon(),
                        widget.GroupBox(visible_groups=[
                                        '01', '02', '03', '04', '05', '06', '07', '08', '09', '00'], **groupbox_config),
                        widget.WindowName(),
                        widget.TextBox(text="[M 2]"),
                        widget.TextBox(text='['),
                        Weather(update_interval=10, padding=1),
                        widget.Sep(),
                        widget.Clock(format='%d/%m/%Y %H:%M'),
                        widget.Sep(),
                        widget.TextBox(text=']'),
                    ],
                    24,
                    background=xrdb.resources['*background']
                ),
            ),
        )
# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
    {'wmclass': 'zenity'},  # Zenity
], **layoutConfigs)
auto_fullscreen = True
focus_on_window_activation = "smart"

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
