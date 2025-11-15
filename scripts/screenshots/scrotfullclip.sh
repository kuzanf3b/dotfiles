#!/bin/sh
set -e
maim | xclip -selection clipboard -t image/png &&
notify-send "Screenshot" "Full screenshot copied to clipboard!"
