#!/bin/sh
set -eu

# === PATHS ===
repos_dir="$HOME/Repository"
learn_dir="$HOME/Documents/Learning"
proj_dir="$HOME/Documents/Projects"
config_dir="$HOME/.config"

# === Wofi wrapper ===
menu() {
    local prompt="$1"
    WOFI_PROMPT="$prompt" wofi --dmenu --allow-markup --hide-scroll
}

# === Check installed apps ===
apps=""
command -v st >/dev/null 2>&1 && apps="${apps}  st\n"
command -v alacritty >/dev/null 2>&1 && apps="${apps}  alacritty\n"
command -v ghostty >/dev/null 2>&1 && apps="${apps}󰊠  ghostty\n"
command -v code >/dev/null 2>&1 && apps="${apps}  vscode\n"
command -v zed >/dev/null 2>&1 && apps="${apps}󰺕  zed\n"

[ -n "$apps" ] || {
    notify-send " No Terminal Apps Found" "Install st, alacritty, ghostty, vscode or zed." -i dialog-warning
    exit 1
}

# === Categories ===
categories="  Repositories
  Configuration
  Learning
  Projects"

# === Choose App ===
chosen_app=$(printf "%b" "$apps" | menu "Open with:" | awk '{print $2}')
[ -n "$chosen_app" ] || exit 0

# === Choose Category ===
chosen_category=$(printf "%b" "$categories" | menu "Category:" | awk '{print $2}')
[ -n "$chosen_category" ] || exit 0

# === Determine Base Directory ===
case "$chosen_category" in
    Repositories) base_dir="$repos_dir" ;;
    Configuration) base_dir="$config_dir" ;;
    Learning) base_dir="$learn_dir" ;;
    Projects) base_dir="$proj_dir" ;;
esac

# === Gather Projects ===
projects=$(find -L "$base_dir" -maxdepth 1 -mindepth 1 -type d -printf "  %f\n" | sort)

[ -n "$projects" ] || {
    notify-send "No Projects Found" "Empty directory in '$chosen_category'." -i dialog-information
    exit 0
}

# === Choose Project ===
chosen_project=$(printf "%b" "$projects" | menu "Projects:" | sed 's/^  //')
[ -n "$chosen_project" ] || exit 0

dir="$base_dir/$chosen_project"

# Special logic for GNU Stow repository layout:
# If the selected project contains .config/<project>, use that instead.
if [ "$chosen_category" = "Repositories" ]; then
    stow_path="$dir/.config/$chosen_project"
    if [ -d "$stow_path" ]; then
        dir="$stow_path"
    fi
fi

# === Open Project ===
case "$chosen_app" in
    st|alacritty|ghostty)
        sess=$(printf "%s" "$chosen_project" | tr '/.' '_')
        exec "$chosen_app" -e tmux new-session -As "$sess" -c "$dir"
        ;;
    vscode)
        exec code "$dir"
        ;;
    zed)
        exec zed "$dir"
        ;;
esac
