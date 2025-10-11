#!/usr/bin/env bash

LOW_BATTERY=20
CRITICAL_BATTERY=10

notify() {
  command -v notify-send >/dev/null && notify-send -u critical "$1" "$2" -t 5000
}

get_battery() {
  if command -v upower >/dev/null; then
    BAT_PATH=$(upower -e | grep BAT)
    perc=$(upower -i "$BAT_PATH" | awk -F: '/percentage/ {gsub(/ /, "", $2); print $2; exit}')
    state=$(upower -i "$BAT_PATH" | awk -F: '/state/ {gsub(/ /, "", $2); print $2; exit}')
  elif command -v acpi >/dev/null; then
    perc=$(acpi -b | awk -F', ' '{print $2; exit}')
    state=$(acpi -b | awk -F', ' '{gsub(/ /,"",$1); print $1; exit}')
  else
    perc="$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null)%"
    state="unknown"
  fi
  perc_num=${perc//%/}
}

if [[ -n "$BLOCK_BUTTON" ]]; then
  get_battery
  if command -v upower >/dev/null; then
    info=$(upower -i "$BAT_PATH" | grep -E 'state|percentage|time')
  elif command -v acpi >/dev/null; then
    info=$(acpi -b)
  else
    info="${perc:-N/A}"
  fi
  notify "Battery Info" "$info"
  exit
fi

get_battery

# === Notifikasi ===
if [[ "$perc_num" -le $CRITICAL_BATTERY ]]; then
  notify "Battery Critical" "Battery is critically low! Plug in now!"
elif [[ "$perc_num" -le $LOW_BATTERY ]] && [[ "$state" != "charging" ]]; then
  notify "Battery Low" "Battery low: $perc"
fi

# === Icon berdasarkan kondisi ===
if [[ "$state" == "charging" ]] || [[ "$state" == "fully-charged" ]]; then
  if   [[ "$perc_num" -le 10 ]]; then icon="󰢜"
  elif [[ "$perc_num" -le 20 ]]; then icon="󰂆"
  elif [[ "$perc_num" -le 30 ]]; then icon="󰂇"
  elif [[ "$perc_num" -le 40 ]]; then icon="󰂈"
  elif [[ "$perc_num" -le 50 ]]; then icon="󰢝"
  elif [[ "$perc_num" -le 60 ]]; then icon="󰂉"
  elif [[ "$perc_num" -le 70 ]]; then icon="󰢞"
  elif [[ "$perc_num" -le 80 ]]; then icon="󰂊"
  elif [[ "$perc_num" -le 90 ]]; then icon="󰂋"
  else icon="󰂅"
  fi
else
  if   [[ "$perc_num" -le 5 ]];  then icon="󰂎"
  elif [[ "$perc_num" -le 10 ]]; then icon="󰁺"
  elif [[ "$perc_num" -le 20 ]]; then icon="󰁻"
  elif [[ "$perc_num" -le 30 ]]; then icon="󰁼"
  elif [[ "$perc_num" -le 40 ]]; then icon="󰁽"
  elif [[ "$perc_num" -le 50 ]]; then icon="󰁾"
  elif [[ "$perc_num" -le 60 ]]; then icon="󰁿"
  elif [[ "$perc_num" -le 70 ]]; then icon="󰂀"
  elif [[ "$perc_num" -le 80 ]]; then icon="󰂁"
  elif [[ "$perc_num" -le 90 ]]; then icon="󰂂"
  else icon="󰁹"
  fi
fi

echo "$icon $perc"

echo "$icon $perc"
