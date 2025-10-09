#!/usr/bin/env bash

LOW_BATTERY=20

notify() {
  command -v notify-send >/dev/null && notify-send -u critical "$1" "$2" -t 5000
}

get_battery() {
  if command -v upower >/dev/null; then
    perc=$(upower -i $(upower -e | grep BAT) | awk -F: '/percentage/ {gsub(/ /, "", $2); print $2; exit}')
    state=$(upower -i $(upower -e | grep BAT) | awk -F: '/state/ {gsub(/ /, "", $2); print $2; exit}')
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
    info=$(upower -i $(upower -e | grep BAT) | grep -E 'state|percentage|time')
  elif command -v acpi >/dev/null; then
    info=$(acpi -b)
  else
    info="${perc:-N/A}"
  fi
  notify "Battery Info" "$info"
  exit
fi

get_battery

if [[ "$perc_num" -le $LOW_BATTERY ]] && [[ "$state" != "charging" ]]; then
  notify "Battery low" "Plug in!"
fi

if [[ "$perc_num" -le $LOW_BATTERY ]]; then
  echo "󰁻 $perc" # merah TokyoNight
else
  echo "󰂂 $perc" # biru terang TokyoNight
fi
