#!/bin/sh
set -e
dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"

file="$dir/Screenshot_sel_$(date +%Y-%m-%d_%H-%M-%S).png"

if maim -s "$file"; then
    notify-send "Screenshot Saved" "Saved selection to $file"
else
    notify-send "Screenshot Canceled" "Selection canceled, no file saved"
    [ -f "$file" ] && rm -f "$file"
fi

