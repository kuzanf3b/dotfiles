#!/usr/bin/env bash
set -eu

wall_dir="$HOME/Pictures/Wallpapers"
cache_dir="$HOME/.cache/wallthumbs"
rofi_theme="$HOME/.config/rofi/wall.rasi"

mkdir -p "$cache_dir"

# Generate thumbnails
for img in "$wall_dir"/*.{jpg,jpeg,png,webp}; do
    [ -f "$img" ] || continue
    name=$(basename "$img")
    if [ ! -f "$cache_dir/$name" ]; then
        magick "$img" -strip -thumbnail 400x225^ -gravity center -extent 400x225 "$cache_dir/$name"
    fi
done

# Build rofi entries
selected=$(find "$wall_dir" -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) \
    -exec basename {} \; | sort | while read -r file; do
        printf "%s\0icon\x1f%s/%s\n" "$file" "$cache_dir" "$file"
    done | rofi -dmenu -theme "$rofi_theme" -show-icons)

[ -z "$selected" ] && exit 0

# ensure daemon
pgrep -x swww-daemon >/dev/null || swww-daemon &

swww img "$wall_dir/$selected" \
    --transition-type grow \
    --transition-step 80 \
    --transition-fps 60
