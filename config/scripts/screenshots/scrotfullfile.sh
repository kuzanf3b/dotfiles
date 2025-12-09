#!/bin/sh
set -e
dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"
file="$dir/Screenshot_full_$(date +%Y-%m-%d_%H-%M-%S).png"
maim "$file" &&
notify-send "Screenshot Saved" "Saved full screenshot to $file"
