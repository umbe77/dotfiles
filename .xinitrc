#/bin/sh

[ -f ~/.xprofile ] && . ~/.xprofile

exec ssh-agent bspwm
