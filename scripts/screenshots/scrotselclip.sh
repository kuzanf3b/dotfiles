#!/bin/sh
set -e

if maim -s | xclip -selection clipboard -t image/png; then
    notify-send "Screenshot" "Selection copied to clipboard!"
else
    notify-send "Screenshot Canceled" "Selection canceled, nothing copied"
fi
