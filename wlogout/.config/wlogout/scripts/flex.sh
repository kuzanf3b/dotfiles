#!/usr/bin/env bash

A_1080=400
B_1080=400

if pgrep -x "wlogout" > /dev/null; then
    pkill -x "wlogout"
    exit 0
fi

resolution=$(wlr-randr | awk '/current/ {print $1}' | cut -d'x' -f2)

top_margin=$(awk "BEGIN {printf \"%.0f\", $A_1080 * 1080 / $resolution}")
bottom_margin=$(awk "BEGIN {printf \"%.0f\", $B_1080 * 1080 / $resolution}")

wlogout \
    -C $HOME/.config/wlogout/style.css \
    -l $HOME/.config/wlogout/layout \
    --protocol layer-shell \
    -b 5 \
    -T $top_margin \
    -B $bottom_margin &
