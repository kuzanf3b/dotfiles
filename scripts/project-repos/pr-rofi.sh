#!/bin/sh
set -eu

# === PATHS ===
repos_dir="$HOME/Repository"
learn_dir="$HOME/Learning"
proj_dir="$HOME/Project"
config_dir="$HOME/.config"

# === Check installed apps ===
apps=""
command -v st >/dev/null 2>&1 && apps="${apps}  st\n"
command -v alacritty >/dev/null 2>&1 && apps="${apps}  alacritty\n"
command -v foot >/dev/null 2>&1 && apps="${apps}󰽒  foot\n"
command -v ghostty >/dev/null 2>&1 && apps="${apps}󰊠  ghostty\n"
command -v code >/dev/null 2>&1 && apps="${apps}  vscode\n"

[ -n "$apps" ] || {
    notify-send " No Terminal Apps Found" "Install a terminal emulator like st, foot, alacritty, or vscode." -i dialog-warning
    exit 1
}

# === Categories ===
categories="  Repositories
  Configuration
  Learning
  Projects"

rofi_common="-dmenu -i -no-show-icons -p"

# === Choose App ===
chosen_app=$(printf "%b" "$apps" | rofi $rofi_common "Open with:" | awk '{print $2}')
[ -n "$chosen_app" ] || exit 0

# === Choose Category ===
chosen_category=$(printf "%b" "$categories" | rofi $rofi_common "Category:" | awk '{print $2}')
[ -n "$chosen_category" ] || exit 0

# === Determine Base Directory ===
case "$chosen_category" in
    Repositories) base_dir="$repos_dir" ;;
    Configuration) base_dir="$config_dir" ;;
    Learning) base_dir="$learn_dir" ;;
    Projects) base_dir="$proj_dir" ;;
esac

# === Gather Projects Fast ===
# langsung list folder 1 level
projects=$(find "$base_dir" -maxdepth 1 -mindepth 1 -type d -printf "  %f\n" | sort)

[ -n "$projects" ] || {
    notify-send "No Projects Found" "Empty directory in '$chosen_category'." -i dialog-information
    exit 0
}

# === Choose Project ===
chosen_project=$(printf "%b" "$projects" | rofi $rofi_common "Projects:" | sed 's/^  //')
[ -n "$chosen_project" ] || exit 0

dir="$base_dir/$chosen_project"

# === Open Project Super Fast ===
case "$chosen_app" in
    st|alacritty|foot|ghostty)
        # session name aman
        sess=$(printf "%s" "$chosen_project" | tr '/.' '_')
        exec "$chosen_app" -e tmux new-session -As "$sess" -c "$dir"
        ;;
    vscode)
        exec code "$dir"
        ;;
esac
