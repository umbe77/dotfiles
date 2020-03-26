#!/usr/bin/env bash

CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)
STATUS=$(cat /sys/class/power_supply/BAT0/status)

dmw_battery() {
	if [ "$STATUS" = "Charging" ]; then
		printf "[🔌 %s%%]" "$CAPACITY"
	else
		printf "[🔋 %s%%]" "$CAPACITY"
	fi
}

dmw_battery
