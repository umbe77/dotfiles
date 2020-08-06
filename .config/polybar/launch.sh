#!/usr/bin/env bash

# Kill all polybar instances
killall -q polybar

#Wait until all polybar are terminated
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

#set primary bar
polybar -r main >>/tmp/polybar_main.log 2>&1 &

PRIMARY=$(polybar --list-monitors | grep primary | cut -d ':' -f1)
if [ ! -z "$PRIMARY" ]; then
    for m in $(polybar --list-monitors | grep -v primary | cut -d ':' -f1); do
        MONITOR=$m polybar -r secondary >>/tmp/polybar_"$m".log 2>&1 &
    done
fi

echo "bar launched"
