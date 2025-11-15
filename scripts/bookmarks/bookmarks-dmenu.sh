#!/bin/sh
set -eu

# === Directory ===
BOOKMARK_DIR="$HOME/.config/scripts/bookmarks/bookmarks-file"
mkdir -p "$BOOKMARK_DIR"

# === Browsers ===
ZEN_BROWSER="$(command -v zen-browser 2>/dev/null || true)"
FIREFOX="$(command -v firefox 2>/dev/null || true)"
BRAVE="$(command -v brave 2>/dev/null || command -v brave-browser 2>/dev/null || true)"

# === dmenu setup ===
DMENU="dmenu -i -l 10 -p"

# === Nerd Font Icons ===
ICON_DEFAULT="󰈙"
ICON_ZEN="󰤄"
ICON_FIREFOX="󰈹"
ICON_BRAVE="󰄛"
NEW_OPTION="󰐕  Add New Bookmark"

# === Icon mapping by filename ===
icon_for() {
    case "$1" in
        personal) echo "󰀄" ;;
        work) echo "󱃐" ;;
        theme) echo "󰏘" ;;
        appearance) echo "󰸱" ;;
        cinema) echo "󰎁" ;;
        terminal) echo "" ;;
        installation) echo "" ;;
        nvim) echo "" ;;
        wm-compositor) echo "" ;;
        *) echo "$ICON_DEFAULT" ;;
    esac
}

# === Capitalize case (Title Case) ===
capitalize_case() {
    echo "$1" | tr '-' ' ' | tr '_' ' ' |
    awk '{for (i=1; i<=NF; i++) {$i = toupper(substr($i,1,1)) tolower(substr($i,2))} print $0}'
}

# === Emit bookmarks from file ===
emit() {
    file="$1"; icon="$2"
    [ -f "$file" ] || return 0
    grep -vE '^\s*(#|$)' "$file" | while IFS= read -r line; do
        name="${line%%::*}"
        url="${line#*::}"
        [ "$name" = "$url" ] && url="$name"
        name="$(printf '%s' "$name" | sed 's/[[:space:]]*$//')"
        url="$(printf '%s' "$url" | sed 's/^[[:space:]]*//')"
        printf '%s  %-25s :: %s\n' "$icon" "$name" "$url"
    done
}

# === Step 1: Choose category (auto-detect .txt files) ===
category_list=""
for file in "$BOOKMARK_DIR"/*.txt; do
    [ -f "$file" ] || continue
    name="$(basename "$file" .txt)"
    display_name="$(capitalize_case "$name")"
    icon="$(icon_for "$name")"
    category_list="${category_list}${icon} ${display_name}\n"
done

[ -n "$category_list" ] || {
    dunstify -a "Bookmarks" " No bookmark files found" "$BOOKMARK_DIR"
    exit 0
}

category_choice="$(printf "%b" "$category_list" | sort | $DMENU 'Select category:')"
[ -n "$category_choice" ] || exit 0

# Convert choice back to filename
CATEGORY="$(printf '%s' "$category_choice" | cut -d' ' -f2- | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"
FILE="$BOOKMARK_DIR/$CATEGORY.txt"
ICON="$(icon_for "$CATEGORY")"

# === Step 2: Choose bookmark ===
menu_items="$(emit "$FILE" "$ICON")"
menu_items="${menu_items}${menu_items:+\n}${NEW_OPTION}"

bookmark_choice="$(printf "%s" "$menu_items" | sort | $DMENU 'Select bookmark:')"
[ -n "$bookmark_choice" ] || exit 0

# === Step 3: Add new bookmark ===
if printf '%s' "$bookmark_choice" | grep -q "$NEW_OPTION"; then
    name="$(printf '' | $DMENU 'Name of site:')"
    [ -z "$name" ] && exit 0
    url="$(printf '' | $DMENU 'URL:')"
    [ -z "$url" ] && exit 0
    printf '%s :: %s\n' "$name" "$url" >> "$FILE"
    dunstify -a "Bookmarks" " Bookmark Added" "$name → $url" \
        -h string:x-canonical-private-synchronous:bookmarks
    exit 0
fi

# === Step 4: Parse selection ===
url="${bookmark_choice##* :: }"
url="$(printf '%s' "$url" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

case "$url" in
    http://*|https://*|file://*|about:*|chrome:*) ;;
    *) url="https://$url" ;;
esac

# === Step 5: Choose browser ===
available_browsers=""
[ -n "$ZEN_BROWSER" ]   && available_browsers="$available_browsers\n$ICON_ZEN  Zen"
[ -n "$FIREFOX" ]       && available_browsers="$available_browsers\n$ICON_FIREFOX  Firefox"
[ -n "$BRAVE" ]         && available_browsers="$available_browsers\n$ICON_BRAVE  Brave"

if [ -z "$available_browsers" ]; then
    dunstify -a "Bookmarks" "❌ No Browser Found" "No available browser installed."
    exit 1
fi

BROWSER_CHOICE="$(printf '%b' "$available_browsers" | sed '/^$/d' | $DMENU 'Open with:')"
[ -z "$BROWSER_CHOICE" ] && exit 0

# === Step 6: Open selected browser ===
open_with() {
    cmd="$1"
    [ -n "$cmd" ] && nohup "$cmd" "$url" >/dev/null 2>&1 &
}

case "$BROWSER_CHOICE" in
    *Zen*)      open_with "$ZEN_BROWSER" ;;
    *Firefox*)  open_with "$FIREFOX" ;;
    *Brave*)    open_with "$BRAVE" ;;
esac

# === Step 7: Notify ===
dunstify -a "Bookmarks" " Opening Bookmark" "$url" \
    -h string:x-canonical-private-synchronous:bookmarks
