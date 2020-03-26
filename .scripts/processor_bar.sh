#!/usr/bin/env bash

PROC=$(mpstat -u -P ALL 1 1 -o JSON | jq -r '.sysstat.hosts[0].statistics[0]."cpu-load"[] | select(.cpu!="all") | .idle')

ramp0=$(echo -n " ▁")
ramp1=$(echo -n " ▂")
ramp2=$(echo -n " ▃")
ramp3=$(echo -n " ▄")
ramp4=$(echo -n " ▅")
ramp5=$(echo -n " ▆")
ramp6=$(echo -n " ▇")
ramp7=$(echo -n " █")

echo -n "--"

while read -r item; do
    PERC=$(echo "scale=2; 100 - $item" | bc -l)

    echo -n " $PERC%"
    
    if [ $(echo "$PERC >= 0 && $PERC <= 12.8" | bc -l) -eq 1 ]; then
        echo -n "$ramp0"
    elif [ $(echo "$PERC > 12.8 && $PERC <= 25.6" | bc -l) -eq 1 ]; then
        echo -n "$ramp1"
    elif [ $(echo "$PERC > 25.6 && $PERC <= 38.4" | bc -l) -eq 1 ]; then
        echo -n "$ramp2"
    elif [ $(echo "$PERC > 38.4 && $PERC <= 51.2" | bc -l) -eq 1 ]; then
        echo -n "$ramp3"
    elif [ $(echo "$PERC > 51.2 && $PERC <= 64" | bc -l) -eq 1 ]; then
        echo -n "$ramp4"
    elif [ $(echo "$PERC > 61.4 && $PERC <= 76.8" | bc -l) -eq 1 ]; then
        echo -n "$ramp5"
    elif [ $(echo "$PERC > 76.8 && $PERC <= 89.6" | bc -l) -eq 1 ]; then
        echo -n "$ramp6"
    else
        echo -n "$ramp7"
    fi

done <<< "$PROC"

echo ""
