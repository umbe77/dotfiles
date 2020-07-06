#/usr/bin/env bash

[ -f ~/.xprofile ] && . ~/.xprofile

case $WM in
    awesome)
        exec awesome
        ;;
    plasma)
        exec startplasma-x11
        ;;
    bspwm)
        exec bspwm
        ;;
    leftwm)
        exec leftwm
        ;;
    *)
        exec qtile 
        ;;
esac
