#!/bin/sh
set -eu

main_options=(" Shutdown" " Reboot" "鈴 Suspend" " Lock" " Kill")

choice=$(printf '%s\n' "${main_options[@]}" | wofi --dmenu --prompt "󰛸 System:" --lines 5)
[ -z "$choice" ] && exit 0

case "$choice" in
    " Shutdown") systemctl poweroff ;;
    " Reboot") systemctl reboot ;;
    "󰒲 Suspend") systemctl suspend ;;
    " Lock")
        if command -v swaylock >/dev/null 2>&1; then
            swaylock
        else
            notify-send "Lock screen not found"
        fi
        ;;
    "󰚌 Kill")
        processes=$(ps -e -o pid,comm --sort=comm | awk '$2 !~ /(systemd|init|sway|wofi)/ {print $1 " " $2}')
        [ -z "$processes" ] && { notify-send "No killable processes"; exit 0; }

        kill_choice=$(printf '%s\n' "$processes" | wofi --dmenu --prompt "󰚌 Kill process:")
        [ -z "$kill_choice" ] && exit 0

        pid=$(echo "$kill_choice" | awk '{print $1}')
        kill -9 "$pid"
        notify-send " Killed process: $kill_choice"
        ;;
esac
