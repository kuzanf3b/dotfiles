#!/usr/bin/env bash
# Combined DWM blocks network indicator

ICON_WIFI=""
ICON_ETH=""
ICON_DOWN="睊"

# Ethernet Check 
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
  # Ethernet aktif
  # kita kasih power "100" karena koneksi kabel stabil
  printf "%s 100%%\n" "$ICON_ETH"
  exit 0
fi

# ===== WiFi Check =====
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
  # Dapatkan sinyal WiFi dalam persen
  if command -v iw >/dev/null 2>&1; then
    sigdb=$(iw dev "$wiface" link 2>/dev/null | awk '/signal:/ {print $2; exit}')
    if [[ "$sigdb" =~ ^-?[0-9]+$ ]]; then
      # konversi dari dBm ke persen
      p=$(( 2 * (sigdb + 100) ))
      (( p < 0 )) && p=0
      (( p > 100 )) && p=100
      printf "%s %d%%\n" "$ICON_WIFI" "$p"
      exit 0
    fi
  fi

  # fallback pakai /proc/net/wireless
  if [ -r /proc/net/wireless ]; then
    q=$(awk -v IF="$wiface" '$1 ~ IF":" {print int($3)}' /proc/net/wireless)
    if [ -n "$q" ]; then
      p=$(( (q * 100) / 70 ))
      printf "%s %d%%\n" "$ICON_WIFI" "$p"
      exit 0
    fi
  fi

  # kalau sinyal gak bisa didapat
  printf "%s ?%%\n" "$ICON_WIFI"
  exit 0
fi

# ===== Tidak ada koneksi =====
printf "%s 0%%\n" "$ICON_DOWN"
