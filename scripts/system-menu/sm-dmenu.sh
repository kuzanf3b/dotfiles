#!/bin/sh
set -eu

menu_flags="-i -l 10 -p"

# Step 1: Menu utama
main_options=" Shutdown\n Reboot\n󰒲 Suspend\n󰌾 Lock\n󰚌 Kill"
choice=$(printf '%b\n' "$main_options" | dmenu $menu_flags "Power Menu:")
[ -z "$choice" ] && exit 0

case "$choice" in
    " Shutdown") systemctl poweroff ;;
    " Reboot") systemctl reboot ;;
    "󰒲 Suspend") systemctl suspend ;;
    " Lock")
        if command -v swaylock >/dev/null 2>&1; then
            swaylock
        elif command -v slock >/dev/null 2>&1; then
            slock
        else
            notify-send -a "Power Menu" "Lock screen not found"
        fi
        ;;
    "󰚌 Kill")
        processes=$(ps -e -o pid,comm --sort=comm | awk '$1 != 1 && $2 !~ /(systemd|init|Xorg|sway|dmenu)/ {print $1 " " $2}')
        [ -z "$processes" ] && { notify-send -a "Power Menu" "No killable processes"; exit 0; }

        kill_choice=$(printf '%s\n' "$processes" | dmenu $menu_flags "󰚌 Kill process:")
        [ -z "$kill_choice" ] && exit 0

        pid=$(echo "$kill_choice" | awk '{print $1}')
        kill "$pid" || kill -9 "$pid"
        notify-send -a "Power Menu" " Killed process: $kill_choice"
        ;;
esac
