#/bin/sh

if [ -e $WM ]; then
    WM="bspwm"
    export WM
fi

[ -f ~/.xprofile ] && . ~/.xprofile

case $WM in
    awesome)
        exec awesome
        ;;
    *)
        exec bspwm
        ;;
esac
