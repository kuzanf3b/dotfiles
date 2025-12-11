#!/bin/bash
OUTPUT="$HOME/Pictures/Screenshots/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"

mkdir -p "$HOME/Pictures/Screenshots"

grim -g "$(slurp)" "$OUTPUT"

wl-copy < "$OUTPUT"

notify-send "Screenshot area taken" "$FILENAME"
