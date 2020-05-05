#/bin/sh

if [ -e $WM ]; then
    WM="awesome"
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
