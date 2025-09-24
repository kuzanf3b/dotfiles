### `scripts/battery.sh`
$()$(
  bash
  #!/usr/bin/env bash

  notify() { command -v notify-send >/dev/null && notify-send -u low "$1" "$2" -t 5000; }

  if [[ -n "$BLOCK_BUTTON" ]]; then
    if command -v upower >/dev/null; then
      info=$(upower -i $(upower -e | grep BAT) | grep -E 'state|percentage|time')
    elif command -v acpi >/dev/null; then
      info=$(acpi -b)
    else
      info="$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null)%"
    fi
    notify "Baterai" "$info"
    exit
  fi

  perc=""
  if command -v upower >/dev/null; then
    perc=$(upower -i $(upower -e | grep BAT) | awk -F: '/percentage/ {gsub(/ /, "", $2); print $2; exit}')
  elif command -v acpi >/dev/null; then
    perc=$(acpi -b | awk -F', ' '{print $2; exit}')
  else
    perc="$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null)%"
  fi

  echo "🔋 ${perc:-N/A}"
)$()
