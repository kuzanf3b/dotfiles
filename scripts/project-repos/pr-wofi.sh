#!/bin/sh
set -eu

# CONFIGURATION

# terminal choices
apps="  st
  alacritty
󰽒  foot
  vscode"

# categories
categories="  Repositories
  Configuration
  All Projects"

# Wofi styling
wofi_common="--insensitive --dmenu --prompt"

chosen_app=$(printf "%b\n" "$apps" | wofi $wofi_common 'Open with:' | awk '{print $2}')
[ -n "$chosen_app" ] || exit 0

chosen_category=$(printf "%b\n" "$categories" | wofi $wofi_common 'Category:' | awk '{print $2}')
[ -n "$chosen_category" ] || exit 0

# path
repos_dir="$HOME/Repos"
config_dir="$HOME/.config"

case "$chosen_category" in
    Repositories)
        base_dirs="$repos_dir"
        ;;
    Configuration)
        base_dirs="$config_dir"
        ;;
    All|All\ Projects)
        base_dirs="$repos_dir $config_dir"
        ;;
    *)
        notify-send " No Projects Found in Category" "Empty directory in categories '$chosen_category'." -i dialog-information
        exit 1
        ;;
esac

# all projects
projects=""
for dir in $base_dirs; do
    if [ -d "$dir" ]; then
        for p in "$dir"/*/; do
            [ -d "$p" ] || continue
            name="$(basename "$p")"
            parent="$(basename "$dir")"
            projects="${projects}  [$parent] $name\n"
        done
    fi
done

[ -n "$projects" ] || {
    notify-send " No Projects Found in Category" "Empty directory in categories '$chosen_category'." -i dialog-information
    exit 0
}

# choose project
chosen_entry=$(printf "%b" "$projects" | wofi $wofi_common 'Projects:')
[ -n "$chosen_entry" ] || exit 0

# taken apart chosen entry
chosen_parent=$(printf "%s" "$chosen_entry" | sed -E 's/.*\[(.*)\].*/\1/')
chosen_project=$(printf "%s" "$chosen_entry" | sed -E 's/.*\] (.*)/\1/')

# directory path
dir="$HOME/$chosen_parent/$chosen_project"

# run chosen app
case "$chosen_app" in
    st)
        exec st -e tmux new-session -As "$chosen_project" -c "$dir"
        ;;
    alacritty)
        exec alacritty -e tmux new-session -As "$chosen_project" -c "$dir"
        ;;
    foot)
        exec foot -e tmux new-session -As "$chosen_project" -c "$dir"
        ;;
    vscode)
        exec code "$dir"
        ;;
    *)
        notify-send " Unknown App" "Unknown '$chosen_app' application." -i dialog-warning
        exit 1
        ;;
esac
