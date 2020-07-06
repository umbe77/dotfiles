#!/bin/sh

compton &

start-pulseaudio-x11 &

unclutter -keystroke &
xrdb -merge ~/.Xresources &

dunst &

command -v nm-applet > /dev/null && nm-applet &
command -v udiskie > /dev/null && udiskie -t -n &
