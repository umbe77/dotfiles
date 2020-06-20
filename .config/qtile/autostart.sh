#!/usr/bin/env bash

#~/.screenlayout/umbedesk.sh

unclutter -keystroke &

start-pulseaudio-x11 &

xrdb -merge ~/.Xresources &

#numlockx &

restorebg & 

xsetroot -cursor_name left_ptr &

#setxkbmap it

set_current_city 1 &

#map CapsLock to Escape key
setxkbmap -option caps:escape &

dunst &
picom &

xautolock -time 10 -locker locker &

sxhkd &

command -v blueman > /dev/null && blueman-applet &
command -v nm-applet > /dev/null && nm-applet &
command -v udiskie > /dev/null && udiskie -t -n &

