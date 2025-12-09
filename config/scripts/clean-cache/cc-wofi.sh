#!/bin/sh
set -eu

# CONFIGURATION
ICON="󰄬"
TITLE="System Cleaner"
CACHE_DIRS="$HOME/.cache /tmp"
WOFI_CMD="wofi --dmenu --prompt"

# MENU OPTIONS
OPTIONS="  Clean User Cache\n  Clean Pacman Cache\n  Clean All\n󰜺  Cancel"

# CHOOSE ACTION
choice=$(printf "%b" "$OPTIONS" | $WOFI_CMD "Select cleanup mode:" --lines 4)
[ -z "$choice" ] && exit 0

case "$choice" in
    *"User Cache"*)
        ACTION="user"
        ;;
    *"Pacman Cache"*)
        ACTION="pacman"
        ;;
    *"Clean All"*)
        ACTION="all"
        ;;
    *)
        notify-send "$TITLE" "󰜺 Cleanup cancelled."
        exit 0
        ;;
esac

# CONFIRMATION
confirm=$(printf "Yes\nNo" | $WOFI_CMD "Are you sure?" --lines 2)
[ "$confirm" != "Yes" ] && {
    notify-send "$TITLE" " Cleanup aborted."
    exit 0
}

# STEP 1: CLEAN PACMAN CACHE
if [ "$ACTION" = "pacman" ] || [ "$ACTION" = "all" ]; then
    if command -v paccache >/dev/null 2>&1; then
        sudo paccache -r
    fi
fi

# STEP 2: CLEAN USER CACHE
if [ "$ACTION" = "user" ] || [ "$ACTION" = "all" ]; then
    for dir in $CACHE_DIRS; do
        if [ -d "$dir" ]; then
            rm -rf "${dir:?}/"*
        fi
    done
    if [ -d "$HOME/.cache/thumbnails" ]; then
        rm -rf "$HOME/.cache/thumbnails/"*
    fi
fi

# STEP 3: NOTIFY RESULT
freed_space=$(df -h / | awk 'NR==2 {print $4}')
case "$ACTION" in
    user) msg="User cache cleaned." ;;
    pacman) msg="Pacman cache cleaned." ;;
    all) msg="System fully cleaned." ;;
esac

notify-send "$TITLE" "$ICON  $msg\n󰑣 Free space available: $freed_space"
