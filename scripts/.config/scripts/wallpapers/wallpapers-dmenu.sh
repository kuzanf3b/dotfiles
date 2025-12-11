#!/bin/sh
set -eu

wall_dir="$HOME/Pictures/Wallpapers"
cache_file="$HOME/.cache/last_wallpaper"

# Pastikan folder ada
[ ! -d "$wall_dir" ] && notify-send "Wallpaper Error" "Directory $wall_dir not found." && exit 1

# Kumpulkan file gambar
mapfile -t files < <(find "$wall_dir" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) | sort)
[ ${#files[@]} -eq 0 ] && notify-send "Wallpaper Error" "No images found." && exit 1

# Konfigurasi dmenu
DMENU="dmenu -i -l 10"

# ==== Menu utama ====
main_options=" Random
󰋅 Choose manually"

choice=$(printf "%b\n" "$main_options" | $DMENU -p "Wallpaper:")
[ -z "$choice" ] && exit 0

case "$choice" in
    " Random")
        chosen="${files[$RANDOM % ${#files[@]}]}"
        ;;

    "󰋅 Choose manually")
        # List nama file
        list=""
        for f in "${files[@]}"; do
            list="${list}󰟾 $(basename "$f")\n"
        done

        chosen_name=$(printf "%b" "$list" | $DMENU -p "Choose:")
        [ -z "$chosen_name" ] && exit 0

        # Cocokkan nama dengan file asli
        stripped="${chosen_name#󰟾 }"

        for f in "${files[@]}"; do
            [ "$(basename "$f")" = "$stripped" ] && chosen="$f" && break
        done
        ;;

    *)
        notify-send "Wallpaper Error" "Invalid choice."
        exit 1
        ;;
esac

# Pastikan ada file dipilih
[ -z "${chosen:-}" ] && notify-send "Wallpaper Error" "No wallpaper selected." && exit 1

# Set wallpaper
feh --no-fehbg --bg-fill "$chosen"

# Simpan ke cache
echo "$chosen" > "$cache_file"

notify-send "Wallpaper Changed" "$(basename "$chosen")"
