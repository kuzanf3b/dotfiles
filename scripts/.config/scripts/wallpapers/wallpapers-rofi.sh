#!/bin/sh
set -eu

wall_dir="$HOME/Pictures/Wallpapers"
cache_file="$HOME/.cache/last_wallpaper"
rofi_theme="$HOME/.config/rofi/wall.rasi"

# === Check directory ===
[ ! -d "$wall_dir" ] && notify-send "Wallpaper Error" "Directory $wall_dir not found." && exit 1

# === Collect images ===
mapfile -t files < <(
    find "$wall_dir" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) | sort
)

[ ${#files[@]} -eq 0 ] && notify-send "Wallpaper Error" "No images found." && exit 1

# === Rofi Base Command (theme applied) ===
ROFI_CMD="rofi -dmenu -i -theme $rofi_theme"

# === Main Options (no hardcoded icons) ===
main_options="Random\nChoose manually"

choice=$(printf "%b" "$main_options" | $ROFI_CMD -p "Wallpaper" -l 4)
[ -z "$choice" ] && exit 0

# === Handle choice ===
case "$choice" in
    "Random")
        chosen="${files[$RANDOM % ${#files[@]}]}"
        ;;
    "Choose manually")
        names=""
        for f in "${files[@]}"; do
            names="${names}$(basename "$f")\n"
        done

        chosen_name=$(printf "%b" "$names" | $ROFI_CMD -p "Choose wallpaper" -l 12)
        [ -z "$chosen_name" ] && exit 0

        for f in "${files[@]}"; do
            if [ "$(basename "$f")" = "$chosen_name" ]; then
                chosen="$f"
                break
            fi
        done
        ;;
    *)
        notify-send "Wallpaper Error" "Invalid choice." && exit 1
        ;;
esac

# === Ensure swww daemon running ===
if ! pgrep -x swww-daemon >/dev/null 2>&1; then
    swww-daemon &
    sleep 0.3
fi

# === Apply wallpaper with swww ===
[ -z "${chosen:-}" ] && notify-send "Wallpaper Error" "No wallpaper selected." && exit 1

swww img "$chosen" \
    --transition-type grow \
    --transition-step 80 \
    --transition-fps 60

# Save to cache
echo "$chosen" > "$cache_file"

# Notify user
notify-send "Wallpaper Changed" "$(basename "$chosen")"
