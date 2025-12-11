#!/bin/sh
set -eu

# === Rofi Config ===
ROFI_CMD="rofi -dmenu -i -p '' -no-show-icons"
FONT="JetBrainsMono Nerd Font 14"

# === Main Options ===
main_options=" Shutdown\n Reboot\n󰒲 Suspend\n Lock\n󰚌 Kill"
choice=$(printf "%b" "$main_options" | $ROFI_CMD "󰛸 System" -font "$FONT" -l 5)
[ -z "$choice" ] && exit 0

# === Handle Choice ===
case "$choice" in
    " Shutdown")
        systemctl poweroff
        ;;
    " Reboot")
        systemctl reboot
        ;;
    "󰒲 Suspend")
        systemctl suspend
        ;;
    " Lock")
        if command -v swaylock >/dev/null 2>&1; then
            swaylock
        elif command -v i3lock >/dev/null 2>&1; then
            i3lock
        else
            notify-send "Lock Error" "No lock screen command found."
        fi
        ;;
    "󰚌 Kill")
        processes=$(ps -e -o pid,comm --sort=comm | awk '$2 !~ /(systemd|init|rofi)/ {print $1 " " $2}')
        [ -z "$processes" ] && { notify-send "Process Manager" "No killable processes found."; exit 0; }

        kill_choice=$(printf '%s\n' "$processes" | $ROFI_CMD "󰚌 Kill" -font "$FONT" -l 12)
        [ -z "$kill_choice" ] && exit 0

        pid=$(echo "$kill_choice" | awk '{print $1}')
        kill -9 "$pid" && notify-send "Process Killed" "$kill_choice"
        ;;
esac
