#!/bin/sh

while read -r monitor; do
    bspc monitor "$monitor" -d  爵   旅  切   0
    # echo "bspc monitor "$monitor" -d 1 2 3 4 5 6 7 8 9 0"
done <<< $(bspc query -M --names)
