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
QUTEBROWSER="$(command -v qutebrowser 2>/dev/null || true)"

# === Wofi Setup ===
WOFI() { wofi --dmenu --prompt "$1" --lines "$2"; }
LINES_CATEGORY=10
LINES_BOOKMARK=12

# === Nerd Font Icons ===
ICON_DEFAULT="󰈙"
ICON_ZEN="󰤄"
ICON_FIREFOX="󰈹"
ICON_BRAVE="󰄛"
ICON_FLOORP="󰈹"
ICON_VIVALDI="󰓇"
ICON_QUTE="󰖟"
NEW_OPTION="󰐕  Add New Bookmark"

# === Icon Map (by file name) ===
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

# === Capitalize Case Function ===
capitalize_case() {
    echo "$1" | tr '-_' ' ' | awk '{for (i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2)); print}'
}

# === Emit bookmarks from file ===
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
for file in "$BOOKMARK_DIR"/*.txt; do
    [ -f "$file" ] || continue
    name="$(basename "$file" .txt)"
    display_name="$(capitalize_case "$name")"
    icon="$(icon_for "$name")"
    category_list="${category_list}${icon} ${display_name}\n"
done

[ -n "$category_list" ] || {
    command -v notify-send >/dev/null 2>&1 && \
        notify-send " No bookmark files found in $BOOKMARK_DIR"
    exit 0
}

category_choice="$(printf "%b" "$category_list" | WOFI 'Select category:' "$LINES_CATEGORY" || true)"
[ -n "${category_choice:-}" ] || exit 0

# Ambil nama file asli dari pilihan
CATEGORY="$(printf '%s' "$category_choice" | sed 's/^[^ ]* //' | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"
FILE="$BOOKMARK_DIR/$CATEGORY.txt"
ICON="$(icon_for "$CATEGORY")"

# === Step 2: Choose Bookmark ===
menu_items="$(emit "$FILE" "$ICON" | sort)"
menu_items="${menu_items}\n${NEW_OPTION}"

bookmark_choice="$(printf "%s" "$menu_items" | WOFI 'Select bookmark:' "$LINES_BOOKMARK" || true)"
[ -n "${bookmark_choice:-}" ] || exit 0

# === Step 3: Add New Bookmark ===
if printf '%s' "$bookmark_choice" | grep -q "$NEW_OPTION"; then
    name="$(WOFI 'Name of site:' 1 || true)"
    [ -z "${name:-}" ] && exit 0
    url="$(WOFI 'URL:' 1 || true)"
    [ -z "${url:-}" ] && exit 0
    printf "%s :: %s\n" "$name" "$url" >>"$FILE"
    command -v notify-send >/dev/null 2>&1 && \
        notify-send " Bookmark Added" "$name → $url" -a "Bookmarks"
    exit 0
fi

# === Step 4: Parse selected bookmark ===
url="${bookmark_choice##* :: }"
url="$(printf '%s' "$url" | xargs)"

case "$url" in
    *://*|about:*|chrome:*) ;;
    *) url="https://$url" ;;
esac

# === Step 5: Choose Browser ===
available_browsers=""
[ -n "$ZEN_BROWSER" ] && available_browsers="${available_browsers}\n${ICON_ZEN} Zen"
[ -n "$FIREFOX" ] && available_browsers="${available_browsers}\n${ICON_FIREFOX} Firefox"
[ -n "$BRAVE" ] && available_browsers="${available_browsers}\n${ICON_BRAVE} Brave"
[ -n "$FLOORP" ] && available_browsers="${available_browsers}\n${ICON_FLOORP} Floorp"
[ -n "$VIVALDI" ] && available_browsers="${available_browsers}\n${ICON_VIVALDI} Vivaldi"
[ -n "$QUTEBROWSER" ] && available_browsers="${available_browsers}\n${ICON_QUTE} Qutebrowser"

browser_choice="$(printf "%b" "$available_browsers" | sed '/^$/d' | WOFI 'Open with:' 6 || true)"
[ -n "${browser_choice:-}" ] || exit 0

case "$browser_choice" in
    *Zen) cmd="$ZEN_BROWSER"; browser_name="Zen Browser" ;;
    *Firefox) cmd="$FIREFOX"; browser_name="Firefox" ;;
    *Brave) cmd="$BRAVE"; browser_name="Brave" ;;
    *Floorp) cmd="$FLOORP"; browser_name="Floorp" ;;
    *Vivaldi) cmd="$VIVALDI"; browser_name="Vivaldi" ;;
    *Qutebrowser) cmd="$QUTEBROWSER"; browser_name="Qutebrowser" ;;
    *) exit 0 ;;
esac

nohup "$cmd" "$url" >/dev/null 2>&1 &
command -v notify-send >/dev/null 2>&1 && \
    notify-send " Opening in $browser_name" "$url" -a "Bookmarks" -u low
