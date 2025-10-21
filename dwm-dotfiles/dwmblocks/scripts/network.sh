#!/usr/bin/env bash
# Dynamic Wi-Fi icon levels

# Icons (requires Nerd Font)
ICON_WIFI_0=""   # disconnected
ICON_WIFI_25="󰤟"  # weak
ICON_WIFI_50="󰤢"  # medium
ICON_WIFI_75="󰤥"  # strong
ICON_WIFI_100="󰤨" # full
ICON_ETH=""

# Ethernet check
get_eth() {
    for if in /sys/class/net/*; do
        iface=$(basename "$if")
        [ "$iface" = "lo" ] && continue
        [ -d "/sys/class/net/$iface/wireless" ] && continue
        state=$(cat "/sys/class/net/$iface/operstate" 2>/dev/null)
        [ "$state" = "up" ] && echo "$iface" && return
    done
}

ethif=$(get_eth)

if [ -n "$ethif" ]; then
    printf "%s 100%%\n" "$ICON_ETH"
    exit 0
fi

# Wi-Fi check
get_wifi_iface() {
    for if in /sys/class/net/*; do
        iface=$(basename "$if")
        [ -d "/sys/class/net/$iface/wireless" ] || continue
        state=$(cat "/sys/class/net/$iface/operstate" 2>/dev/null)
        [ "$state" = "up" ] && echo "$iface" && return
    done
}

wiface=$(get_wifi_iface)

if [ -n "$wiface" ]; then
    if command -v iw >/dev/null 2>&1; then
        sigdb=$(iw dev "$wiface" link 2>/dev/null | awk '/signal:/ {print $2; exit}')
        if [[ "$sigdb" =~ ^-?[0-9]+$ ]]; then
            p=$(( 2 * (sigdb + 100) ))
            (( p < 0 )) && p=0
            (( p > 100 )) && p=100
        fi
    fi

    if [ -z "$p" ] && [ -r /proc/net/wireless ]; then
        q=$(awk -v IF="$wiface" '$1 ~ IF":" {print int($3)}' /proc/net/wireless)
        [ -n "$q" ] && p=$(( (q * 100) / 70 ))
    fi

    [ -z "$p" ] && p=0

    if   [ "$p" -ge 100 ]; then icon="$ICON_WIFI_100"
    elif [ "$p" -ge 75 ];  then icon="$ICON_WIFI_75"
    elif [ "$p" -ge 50 ];  then icon="$ICON_WIFI_50"
    elif [ "$p" -ge 25 ];  then icon="$ICON_WIFI_25"
    else                    icon="$ICON_WIFI_0"
    fi

    printf "%s %d%%\n" "$icon" "$p"
    exit 0
fi

# Disconnected
printf "%s Disconnected\n" "$ICON_WIFI_0"
