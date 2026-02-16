#!/bin/bash

cliphist list \
    | rofi -theme ~/.config/rofi/clip.rasi -dmenu -sync -display-columns 2 \
    | cliphist decode \
    | wl-copy
