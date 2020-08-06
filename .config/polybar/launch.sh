#!/usr/bin/env bash

# Kill all polybar instances
killall -q polybar

#Wait until all polybar are terminated
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar -r main1 >>/tmp/polybar1.log 2>&1 &
polybar -r main >>/tmp/polybar1.log 2>&1 &

echo "bar launched"
