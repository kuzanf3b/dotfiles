#!/bin/sh
set -eu

wall_dir="$HOME/Pictures/Wallpapers"
cache_file="$HOME/.cache/last_wallpaper"

[ ! -d "$wall_dir" ] && notify-send " Wallpaper" "Directory $wall_dir not found." && exit 1

mapfile -t files < <(find "$wall_dir" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) | sort)
[ ${#files[@]} -eq 0 ] && notify-send " Wallpaper" "No images found" && exit 1

main_options=(" Random" "󰋅 Choose manually")
choice=$(printf '%s\n' "${main_options[@]}" | wofi --dmenu --prompt "󰸉 :" --font "JetBrainsMono Nerd Font 20" --lines 4)
[ -z "$choice" ] && exit

case "$choice" in
    " Random")
        chosen="${files[$RANDOM % ${#files[@]}]}"
        ;;
    "󰋅 Choose manually")
        names=()
        for f in "${files[@]}"; do
            names+=("󰟾 $(basename "$f")")
        done
        chosen_name=$(printf '%s\n' "${names[@]}" | wofi --dmenu --prompt "󰟾 Choose wallpaper:" --font "JetBrainsMono Nerd Font 16" --lines 8)
        [ -z "$chosen_name" ] && exit
        for f in "${files[@]}"; do
            if [ "$(basename "$f")" = "${chosen_name#󰟾 }" ]; then
                chosen="$f"
                break
            fi
        done
        ;;
esac

[ -z "${chosen:-}" ] && notify-send " Wallpaper" "No wallpaper selected." && exit 1

# === Replace swaybg with swww ===
# Pastikan daemon hidup; kalau belum, ini akan menyalakan
swww init 2>/dev/null || true

# Set wallpaper dengan transisi biar manis
swww img "$chosen" --transition-type grow --transition-step 80 --transition-fps 60

echo "$chosen" > "$cache_file"
notify-send "Wallpaper changed" "$(basename "$chosen")"
