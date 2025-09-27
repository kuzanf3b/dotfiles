#!/usr/bin/env bash

# Fungsi notifikasi
notify() {
  command -v notify-send >/dev/null && notify-send -u low "$1" "$2" -t 3000
}

# Ambil volume & mute
get_volume() {
  if command -v pactl >/dev/null; then
    sink=$(pactl info | awk -F": " '/Default Sink/ {print $2}')
    vol=$(pactl get-sink-volume "$sink" | grep -oP '\d+%' | head -n1 | tr -d '%')
    mute=$(pactl get-sink-mute "$sink" | awk '{print $2; exit}')
  elif command -v amixer >/dev/null; then
    vol=$(amixer get Master | awk -F'[][]' '/%/ {print $2; exit}' | tr -d '%')
    mute=$(amixer get Master | grep '\[off\]')
  else
    vol=0
    mute="yes"
  fi
}

# Toggle mute (klik kiri)
toggle_mute() {
  if command -v pactl >/dev/null; then
    pactl set-sink-mute "$sink" toggle
  elif command -v amixer >/dev/null; then
    amixer set Master toggle
  fi
}

# Buka mixer (klik kanan)
open_mixer() {
  if command -v pavucontrol >/dev/null; then
    pavucontrol &
  else
    xterm -e alsamixer &
  fi
}

# Klik event
if [[ -n "$BLOCK_BUTTON" ]]; then
  get_volume
  case $BLOCK_BUTTON in
  1) toggle_mute ;; # klik kiri
  3) open_mixer ;;  # klik kanan
  esac
  get_volume
  [[ $mute == yes || -n $mute ]] && info="🔈 mute" || info="🔊 ${vol}%"
  notify "Audio" "$info"
  exit
fi

# Output standar dengan warna TokyoNight
get_volume
if [[ $mute == yes || -n $mute ]]; then
  echo "^c#f7768e^🔈 mute^d^" # merah saat mute
elif ((vol > 90)); then
  echo "^c#f7768e^🔊 ${vol}%^d^" # merah jika volume tinggi
elif ((vol > 70)); then
  echo "^c#e0af68^🔊 ${vol}%^d^" # kuning untuk medium
else
  echo "^c#9ece6a^🔊 ${vol}%^d^" # hijau normal
fi
