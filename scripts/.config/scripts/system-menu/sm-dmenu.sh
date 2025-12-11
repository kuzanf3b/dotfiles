#!/bin/sh
set -eu

menu_flags="-i -l 10"

prompt() {
    dmenu $menu_flags -p "$1"
}

main_options=" Shutdown
 Reboot
󰒲 Suspend
󰌾 Lock
󰚌 Kill"

choice=$(printf '%b\n' "$main_options" | prompt "Power Menu:")
[ -z "$choice" ] && exit 0

case "$choice" in
    " Shutdown") systemctl poweroff ;;
    " Reboot") systemctl reboot ;;
    "󰒲 Suspend") systemctl suspend ;;
    "󰌾 Lock")
        if command -v betterlockscreen >/dev/null 2>&1; then
            betterlockscreen -l dimblur
        elif command -v slock >/dev/null 2>&1; then
            slock
        else
            notify-send "Power Menu" "Lock screen not found"
        fi
        ;;
    "󰚌 Kill")
        processes=$(ps -e -o pid,comm --sort=comm | awk '$1 != 1 && $2 !~ /(systemd|init|Xorg|sway|dmenu)/ {print $1 " " $2}')
        [ -z "$processes" ] && { notify-send "Power Menu" "No killable processes"; exit 0; }

        kill_choice=$(printf '%s\n' "$processes" | prompt "Kill process:")
        [ -z "$kill_choice" ] && exit 0

        pid=$(echo "$kill_choice" | awk '{print $1}')
        kill "$pid" || kill -9 "$pid"
        notify-send "Power Menu" "Killed: $kill_choice"
        ;;
esac
