#!/bin/sh
set -eu

# detik
SCREEN_OFF=300
LOCK=600
SUSPEND=1200

xidlehook \
    --not-when-fullscreen \
    --not-when-audio \
    --timer $SCREEN_OFF \
    'xset dpms force off' \
    'xset dpms force on' \
    --timer $LOCK \
    'betterlockscreen -l dimblur' \
    '' \
    --timer $SUSPEND \
    'systemctl suspend' \
    ''
