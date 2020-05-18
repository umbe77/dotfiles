#/bin/sh

[ -f ~/.xprofile ] && . ~/.xprofile

case $WM in
    qtile)
        exec qtile
        ;;
    bspwm)
        exec bspwm
        ;;
    *)
        exec awsome 
        ;;
esac
