#/usr/bin/env bash

[ -f ~/.xprofile ] && . ~/.xprofile

case $WM in
    awesome)
        exec awesome
        ;;
    bspwm)
        exec bspwm
        ;;
    *)
        exec qtile 
        ;;
esac
