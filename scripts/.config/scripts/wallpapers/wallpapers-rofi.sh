#!/bin/sh
set -eu

wall_dir="$HOME/Pictures/Wallpapers"
cache_file="$HOME/.cache/last_wallpaper"

# === Check directory ===
[ ! -d "$wall_dir" ] && notify-send "Wallpaper Error" "Directory $wall_dir not found." && exit 1

# === Collect images ===
mapfile -t files < <(find "$wall_dir" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) | sort)
[ ${#files[@]} -eq 0 ] && notify-send "Wallpaper Error" "No images found." && exit 1

# === Rofi Config ===
ROFI_CMD="rofi -dmenu -i -p '' -no-show-icons"
FONT="JetBrainsMono Nerd Font 14"

# === Main Options ===
main_options=" Random\n󰋅 Choose manually"
choice=$(printf "%b" "$main_options" | $ROFI_CMD "󰸉 " -font "$FONT" -l 4)
[ -z "$choice" ] && exit 0

# === Handle choice ===
case "$choice" in
    " Random")
        chosen="${files[$RANDOM % ${#files[@]}]}"
        ;;
    "󰋅 Choose manually")
        names=""
        for f in "${files[@]}"; do
            names="${names}󰟾 $(basename "$f")\n"
        done
        chosen_name=$(printf "%b" "$names" | $ROFI_CMD "󰟾 Choose wallpaper:" -font "$FONT" -l 10)
        [ -z "$chosen_name" ] && exit 0

        for f in "${files[@]}"; do
            if [ "$(basename "$f")" = "${chosen_name#󰟾 }" ]; then
                chosen="$f"
                break
            fi
        done
        ;;
    *)
        notify-send "Wallpaper Error" "Invalid choice." && exit 1
        ;;
esac

# === Apply wallpaper with feh ===
[ -z "${chosen:-}" ] && notify-send "Wallpaper Error" "No wallpaper selected." && exit 1

# Set wallpaper using feh
feh --no-fehbg --bg-fill "$chosen"

# Save to cache
echo "$chosen" > "$cache_file"

# Notify user
notify-send "Wallpaper Changed" "$(basename "$chosen")"
