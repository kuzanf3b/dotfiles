#!/bin/sh
set -eu

# === Setup Directories ===
BOOKMARK_DIR="$HOME/.config/scripts/bookmarks/bookmarks-file"
mkdir -p "$BOOKMARK_DIR"

# === Browsers ===
ZEN_BROWSER="$(command -v zen-browser 2>/dev/null || true)"
FIREFOX="$(command -v firefox 2>/dev/null || true)"
BRAVE="$(command -v brave 2>/dev/null || command -v brave-browser 2>/dev/null || true)"
FLOORP="$(command -v floorp 2>/dev/null || true)"
VIVALDI="$(command -v vivaldi 2>/dev/null || true)"
QUTE="$(command -v qutebrowser 2>/dev/null || true)"

# === dmenu Setup ===
DMENU="dmenu -i"

# === Nerd Font Icons ===
ICON_DEFAULT="󰈙"
ICON_ZEN="󰤄"
ICON_FIREFOX="󰈹"
ICON_BRAVE="󰄛"
ICON_FLOORP="󰓅"
ICON_VIVALDI=""
ICON_QUTE="󰆍"
NEW_OPTION="󰐕  Add New Bookmark"

icon_for() {
    case "$1" in
        personal) echo "" ;;
        work) echo "󱃐" ;;
        theme) echo "󰏘" ;;
        appearance) echo "" ;;
        cinema) echo "󰎁" ;;
        terminal) echo "" ;;
        installation) echo "" ;;
        nvim) echo "" ;;
        wm-compositor) echo "" ;;
        *) echo "$ICON_DEFAULT" ;;
    esac
}

capitalize_case() {
    echo "$1" | sed 's/[-_]/ /g' | awk '{for (i=1;i<=NF;i++){$i=toupper(substr($i,1,1))tolower(substr($i,2))}print}'
}

emit() {
    file="$1"; icon="$2"
    grep -vE '^\s*(#|$)' "$file" | while IFS= read -r line; do
        case "$line" in
            *"::"*)
                name="${line%%::*}"
                url="${line#*::}"
                printf '%s [%s] :: %s\n' "$icon" "$(echo "$name" | xargs)" "$(echo "$url" | xargs)"
                ;;
            *)
                printf '%s [%s] :: %s\n' "$icon" "$line" "$line"
                ;;
        esac
    done
}

# === Step 1: Choose Category ===
category_list=""
found_file=false
for file in "$BOOKMARK_DIR"/*.txt; do
    [ -f "$file" ] || continue
    found_file=true
    name="$(basename "$file" .txt)"
    icon="$(icon_for "$name")"
    display_name="$(capitalize_case "$name")"
    category_list="${category_list}${icon} ${display_name}\n"
done

if [ "$found_file" = false ]; then
    notify-send "No bookmark files found in $BOOKMARK_DIR"
    exit 0
fi

category_choice="$(printf "%b" "$category_list" | $DMENU -p "Category:" || true)"
[ -n "${category_choice:-}" ] || exit 0

CATEGORY="$(printf '%s' "$category_choice" | cut -d' ' -f2- | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"
FILE="$BOOKMARK_DIR/$CATEGORY.txt"
ICON="$(icon_for "$CATEGORY")"

# === Step 2: Choose Bookmark ===
bookmarks_sorted="$(emit "$FILE" "$ICON" | sort)"

menu_items="${NEW_OPTION}
${bookmarks_sorted}"

bookmark_choice="$(printf "%s" "$menu_items" | $DMENU -p "Bookmark:" || true)"
[ -n "${bookmark_choice:-}" ] || exit 0

# === Step 3: Add New Bookmark ===
if printf '%s' "$bookmark_choice" | grep -q "$NEW_OPTION"; then
    name="$($DMENU -p "Name:" || true)"
    [ -z "${name:-}" ] && exit 0
    url="$($DMENU -p "URL:" || true)"
    [ -z "${url:-}" ] && exit 0
    printf "%s :: %s\n" "$name" "$url" >>"$FILE"
    notify-send "Bookmark Added" "$name → $url"
    exit 0
fi

# === Step 4: Parse selected bookmark ===
url="${bookmark_choice##* :: }"
url="$(printf '%s' "$url" | xargs)"

case "$url" in
    http://*|https://*|file://*|about:*|chrome:*) ;;
    *) url="https://$url" ;;
esac

# === Step 5: Choose Browser ===
available_browsers=""
[ -n "$ZEN_BROWSER" ] && available_browsers="${available_browsers}󰤄 Zen\n"
[ -n "$FIREFOX" ] && available_browsers="${available_browsers}󰈹 Firefox\n"
[ -n "$BRAVE" ] && available_browsers="${available_browsers}󰄛 Brave\n"
[ -n "$FLOORP" ] && available_browsers="${available_browsers}󰓅 Floorp\n"
[ -n "$VIVALDI" ] && available_browsers="${available_browsers} Vivaldi\n"
[ -n "$QUTE" ] && available_browsers="${available_browsers}󰆍 Qutebrowser\n"

browser_choice="$(printf "%b" "$available_browsers" | $DMENU -p "Browser:" || true)"
[ -n "${browser_choice:-}" ] || exit 0

case "$browser_choice" in
    *Zen) cmd="$ZEN_BROWSER" ;;
    *Firefox) cmd="$FIREFOX" ;;
    *Brave) cmd="$BRAVE" ;;
    *Floorp) cmd="$FLOORP" ;;
    *Vivaldi) cmd="$VIVALDI" ;;
    *Qutebrowser) cmd="$QUTE" ;;
    *) exit 0 ;;
esac

nohup "$cmd" "$url" >/dev/null 2>&1 &
notify-send "Opening" "$url"
