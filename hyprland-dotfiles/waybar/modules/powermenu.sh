#!/usr/bin/env bash

options=" Shutdown\n Reboot\n Lock\n Suspend\n Logout"

chosen=$(echo -e "$options" | wofi \
  --dmenu \
  --prompt "Power" \
  --style /home/kuzan/.config/wofi/style.css \
  --width 300 \
  --height 250 \
  --xoffset 810 \
  --yoffset 300 \
  --always_parse_args true \
  --layer overlay)

case $chosen in
" Shutdown") systemctl poweroff ;;
" Reboot") systemctl reboot ;;
" Lock") hyprlock ;; # ganti kalau pakai swaylock
" Suspend") systemctl suspend ;;
" Logout") hyprctl dispatch exit ;;
*) exit 0 ;;
esac
