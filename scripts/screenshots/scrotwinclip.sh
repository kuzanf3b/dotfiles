#!/bin/sh
set -e

if maim --window $(xdotool getactivewindow) | xclip -selection clipboard -t image/png; then
    notify-send "Screenshot" "Window copied to clipboard!"
else
    notify-send "Screenshot Canceled" "Window canceled, nothing copied"
fi
