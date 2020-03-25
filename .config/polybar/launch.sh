#!/usr/bin/env bash

killall -q polybar

echo "---" | tee -a /tmp/polybar1.log

polybar -r main >>/tmp/polybar1.log 2>&1 &

echo "bar launched"
