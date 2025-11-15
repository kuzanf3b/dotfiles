#!/bin/sh
set -eu

# CONFIGURATION

# Terminal/app choices
apps="  st
  alacritty
󰽒  foot
  vscode"

# Categories
categories="  Repos
  Config
  All Projects"

# Dmenu setup
DMENU="dmenu -i -l 10 -p"

# Paths
repos_dir="$HOME/Repos"
config_dir="$HOME/.config"

# Step 1: Choose application
chosen_app=$(printf "%b\n" "$apps" | $DMENU 'Open with:' | awk '{print $2}')
[ -n "$chosen_app" ] || exit 0

# Step 2: Choose category
chosen_category=$(printf "%b\n" "$categories" | $DMENU 'Category:' | awk '{print $2}')
[ -n "$chosen_category" ] || exit 0

# Step 3: Determine base directory
case "$chosen_category" in
    Repos)
        base_dirs="$repos_dir"
        ;;
    Config)
        base_dirs="$config_dir"
        ;;
    All|All\ Projects)
        base_dirs="$repos_dir $config_dir"
        ;;
    *)
        dunstify -a "Projects" " No Projects Found in Category" "Empty directory in '$chosen_category'."
        exit 1
        ;;
esac

# Step 4: Collect all project directories
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
    dunstify -a "Projects" " No Projects Found in Category" "Empty directory in '$chosen_category'."
    exit 0
}

# Step 5: Choose project
chosen_entry=$(printf "%b" "$projects" | $DMENU 'Projects:')
[ -n "$chosen_entry" ] || exit 0

# Step 6: Extract parent and project name
chosen_parent=$(printf "%s" "$chosen_entry" | sed -E 's/.*\[(.*)\].*/\1/')
chosen_project=$(printf "%s" "$chosen_entry" | sed -E 's/.*\] (.*)/\1/')

# Step 7: Construct path
dir="$HOME/$chosen_parent/$chosen_project"

# Step 8: Run chosen app
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
        dunstify -a "Projects" " Unknown App" "Unknown application: '$chosen_app'."
        exit 1
        ;;
esac
