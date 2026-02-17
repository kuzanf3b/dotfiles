#!/bin/sh
set -eu

# =============================
# Config
# =============================
BOOKMARK_DIR="$HOME/.config/scripts/bookmarks/bookmarks-file"
ROFI_THEME="$HOME/.config/rofi/bookmark.rasi"

mkdir -p "$BOOKMARK_DIR"

rofi_run() {
    rofi -dmenu -i -no-config -theme "$ROFI_THEME" "$@"
}

LINES_CATEGORY=10
LINES_BOOKMARK=12
NEW_OPTION="Add New Bookmark"

# =============================
# Browsers
# =============================
ZEN_BROWSER="$(command -v zen-browser 2>/dev/null || true)"
FIREFOX="$(command -v firefox 2>/dev/null || true)"
BRAVE="$(command -v brave 2>/dev/null || command -v brave-browser 2>/dev/null || true)"
FLOORP="$(command -v floorp 2>/dev/null || true)"
VIVALDI="$(command -v vivaldi 2>/dev/null || true)"
QUTE="$(command -v qutebrowser 2>/dev/null || true)"

# =============================
# Helpers
# =============================
capitalize_case() {
    echo "$1" | sed 's/[-_]/ /g' | awk '{for (i=1;i<=NF;i++){ $i=toupper(substr($i,1,1))tolower(substr($i,2)) } print}'
}

emit() {
    file="$1"

    grep -vE '^\s*(#|$)' "$file" | while IFS= read -r line; do
        case "$line" in
            *"::"*)
                name="${line%%::*}"
                url="${line#*::}"
                printf '%s :: %s\n' "$(echo "$name" | xargs)" "$(echo "$url" | xargs)"
                ;;
            *)
                printf '%s :: %s\n' "$line" "$line"
                ;;
        esac
    done
}

# =============================
# Step 1: Category
# =============================
category_list=""
found=false

for file in "$BOOKMARK_DIR"/*.txt; do
    [ -f "$file" ] || continue
    found=true
    name="$(basename "$file" .txt)"
    category_list="${category_list}$(capitalize_case "$name")\n"
done

[ "$found" = false ] && exit 0

category_choice="$(printf "%b" "$category_list" | rofi_run -p "Select category:" -l "$LINES_CATEGORY" || true)"
[ -z "${category_choice:-}" ] && exit 0

CATEGORY="$(printf '%s' "$category_choice" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"
FILE="$BOOKMARK_DIR/$CATEGORY.txt"

[ -f "$FILE" ] || exit 0

# =============================
# Step 2: Bookmark
# =============================
bookmarks_sorted="$(emit "$FILE" | sort)"

menu_items="${NEW_OPTION}
${bookmarks_sorted}"

bookmark_choice="$(printf "%s" "$menu_items" | rofi_run -p "Select bookmark:" -l "$LINES_BOOKMARK" || true)"
[ -z "${bookmark_choice:-}" ] && exit 0

# =============================
# Step 3: Add New
# =============================
if [ "$bookmark_choice" = "$NEW_OPTION" ]; then
    name="$(rofi_run -p "Name:")"
    [ -z "${name:-}" ] && exit 0

    url="$(rofi_run -p "URL:")"
    [ -z "${url:-}" ] && exit 0

    printf "%s :: %s\n" "$name" "$url" >> "$FILE"
    notify-send "Bookmark added" "$name → $url"
    exit 0
fi

# =============================
# Step 4: Parse URL
# =============================
url="${bookmark_choice##* :: }"
url="$(printf '%s' "$url" | xargs)"

case "$url" in
    http://*|https://*|file://*|about:*|chrome:*) ;;
    *) url="https://$url" ;;
esac

# =============================
# Step 5: Choose Browser
# =============================
available=""

[ -n "$ZEN_BROWSER" ] && available="${available}\nZen"
[ -n "$FIREFOX" ] && available="${available}\nFirefox"
[ -n "$BRAVE" ] && available="${available}\nBrave"
[ -n "$FLOORP" ] && available="${available}\nFloorp"
[ -n "$VIVALDI" ] && available="${available}\nVivaldi"
[ -n "$QUTE" ] && available="${available}\nQutebrowser"

browser_choice="$(printf "%b" "$available" | sed '/^$/d' | rofi_run -p "Open with:" -l 6 || true)"
[ -z "${browser_choice:-}" ] && exit 0

case "$browser_choice" in
    Zen) cmd="$ZEN_BROWSER" ;;
    Firefox) cmd="$FIREFOX" ;;
    Brave) cmd="$BRAVE" ;;
    Floorp) cmd="$FLOORP" ;;
    Vivaldi) cmd="$VIVALDI" ;;
    Qutebrowser) cmd="$QUTE" ;;
    *) exit 0 ;;
esac

nohup "$cmd" "$url" >/dev/null 2>&1 &
notify-send "Opening" "$url" -u low
