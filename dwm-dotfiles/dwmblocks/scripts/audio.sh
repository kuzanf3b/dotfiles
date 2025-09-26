#!/usr/bin/env bash

notify() { command -v notify-send >/dev/null && notify-send -u low "$1" "$2" -t 5000; }

if [[ -n "$BLOCK_BUTTON" ]]; then
  if command -v pactl >/dev/null; then
    sink=$(pactl info | awk -F": " '/Default Sink/ {print $2}')
    info=$(pactl list sinks | grep -A15 "$sink")
  elif command -v amixer >/dev/null; then
    info=$(amixer get Master)
  else
    info="Audio not available"
  fi
  notify "Audio" "$info"
  exit
fi

if command -v pactl >/dev/null; then
  sink=$(pactl info | awk -F": " '/Default Sink/ {print $2}')
  vol=$(pactl get-sink-volume "$sink" | awk '{print $5; exit}')
  mute=$(pactl get-sink-mute "$sink" | awk '{print $2; exit}')
  [[ $mute == yes ]] && echo "🔈 mute" || echo "🔊 $vol"
elif command -v amixer >/dev/null; then
  vol=$(amixer get Master | awk -F'[][]' '/%/ {print $2; exit}')
  mute=$(amixer get Master | grep '\[off\]')
  [[ -n $mute ]] && echo "🔈 mute" || echo "🔊 $vol"
else
  echo "Audio N/A"
fi
