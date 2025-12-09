#!/bin/bash

pkill waybar
waybar &

pkill mako
mako &

swayidle -w \
  timeout 300 'makoctl mode -a away && swaylock -f --config ~/.config/swaylock/config' \
  resume 'makoctl mode -r away' \
  timeout 600 'swaymsg "output * dpms off"' \
  resume 'swaymsg "output * dpms on"' \
  before-sleep 'swaylock -f --config ~/.config/swaylock/config' &
