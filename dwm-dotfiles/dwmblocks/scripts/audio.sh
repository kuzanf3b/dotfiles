#!/usr/bin/env bash

notify() {
  local title=${1:-"󰝚 Audio"}
  local body=${2:-""}
  if command -v notify-send >/dev/null; then
    notify-send \
      -u low \
      -t 3500 \
      -h string:bgcolor:"#393552" \
      -h string:fgcolor:"#e0def4" \
      -h string:framecolor:"#3e8fb0" \
      "$title" "$body"
  fi
}

if [[ -n "$BLOCK_BUTTON" ]]; then
  if command -v pactl >/dev/null; then
    sink=$(pactl info | awk -F": " '/Default Sink/ {print $2}')
    vol=$(pactl get-sink-volume "$sink" | awk '{print $5; exit}')
    mute=$(pactl get-sink-mute "$sink" | awk '{print $2; exit}')
    if [[ $mute == yes ]]; then
      notify "󰝟 Muted" "Audio output is muted"
    else
      notify "󰕾 Volume" "$vol"
    fi
  elif command -v amixer >/dev/null; then
    vol=$(amixer get Master | awk -F'[][]' '/%/ {print $2; exit}')
    mute=$(amixer get Master | grep '\[off\]')
    if [[ -n $mute ]]; then
      notify "󰝟 Muted" "Audio output is muted"
    else
      notify "󰕾 Volume" "$vol"
    fi
  else
    notify "󰋋 Audio" "Audio system not available"
  fi
  exit
fi

if command -v pactl >/dev/null; then
  sink=$(pactl info | awk -F": " '/Default Sink/ {print $2}')
  vol=$(pactl get-sink-volume "$sink" | awk '{print $5; exit}')
  mute=$(pactl get-sink-mute "$sink" | awk '{print $2; exit}')
  [[ $mute == yes ]] && echo "󰝟 mute" || echo "󰕾 $vol"
elif command -v amixer >/dev/null; then
  vol=$(amixer get Master | awk -F'[][]' '/%/ {print $2; exit}')
  mute=$(amixer get Master | grep '\[off\]')
  [[ -n $mute ]] && echo "󰝟 mute" || echo "󰕾 $vol"
else
  echo "󰋋 Audio N/A"
fi
