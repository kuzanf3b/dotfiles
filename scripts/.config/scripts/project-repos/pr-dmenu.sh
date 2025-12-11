#!/bin/sh
set -eu

# === PATHS ===
repos_dir="$HOME/Repository"
learn_dir="$HOME/Learning"
proj_dir="$HOME/Project"
config_dir="$HOME/.config"

# === dmenu wrapper ===
DMENU="dmenu -i -p"

# === Check installed apps ===
apps=""
command -v st >/dev/null 2>&1 && apps="${apps}  st\n"
command -v alacritty >/dev/null 2>&1 && apps="${apps}  alacritty\n"
command -v ghostty >/dev/null 2>&1 && apps="${apps}󰊠  ghostty\n"
command -v code >/dev/null 2>&1 && apps="${apps}  vscode\n"

[ -n "$apps" ] || {
    notify-send " No Terminal Apps Found" "Install a terminal emulator like st, alacritty, or vscode." -i dialog-warning
    exit 1
}

# === Categories ===
categories="  Repositories
  Configuration
  Learning
  Projects"

# === Choose App ===
chosen_app_line=$(printf "%b" "$apps" | $DMENU "Open with:")
[ -n "$chosen_app_line" ] || exit 0

# ambil kata terakhir (nama aplikasinya)
chosen_app="${chosen_app_line##* }"

# === Choose Category ===
chosen_category_line=$(printf "%b" "$categories" | $DMENU "Category:")
[ -n "$chosen_category_line" ] || exit 0

chosen_category="${chosen_category_line##* }"

# === Determine Base Directory ===
case "$chosen_category" in
    Repositories) base_dir="$repos_dir" ;;
    Configuration) base_dir="$config_dir" ;;
    Learning) base_dir="$learn_dir" ;;
    Projects) base_dir="$proj_dir" ;;
esac

# === Gather Projects Fast ===
projects=$(find "$base_dir" -maxdepth 1 -mindepth 1 -type d -printf "  %f\n" | sort)

[ -n "$projects" ] || {
    notify-send "No Projects Found" "Empty directory in '$chosen_category'." -i dialog-information
    exit 0
}

# === Choose Project ===
chosen_project_line=$(printf "%b" "$projects" | $DMENU "Projects:")
[ -n "$chosen_project_line" ] || exit 0

# hapus ikon
chosen_project="${chosen_project_line#  }"

dir="$base_dir/$chosen_project"

# === Open Project ===
case "$chosen_app" in
    st|alacritty|ghostty)
        sess=$(printf "%s" "$chosen_project" | tr '/.' '_')
        exec "$chosen_app" -e tmux new-session -As "$sess" -c "$dir"
        ;;
    vscode)
        exec code "$dir"
        ;;
esac
