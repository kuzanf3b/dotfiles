#!/bin/bash

OUTPUT="$HOME/Pictures/Screenshots/full_$(date +%Y-%m-%d_%H-%M-%S).png"
mkdir -p "$HOME/Pictures/Screenshots"

grim "$OUTPUT"

wl-copy < "$OUTPUT"

FILENAME=$(basename "$OUTPUT")
notify-send "Fullscreen Screenshot taken" "$FILENAME"
