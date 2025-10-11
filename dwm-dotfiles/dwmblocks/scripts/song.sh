#!/usr/bin/env bash

notify() {
  command -v notify-send >/dev/null && notify-send -u low "$1" "$2" -t 5000
}

music_bar() {
  local frames=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")
  local idx=$((RANDOM % 8))
  echo "${frames[$idx]}${frames[$(((idx + 2) % 8))]}${frames[$(((idx + 4) % 8))]}"
}

if [[ -n "$BLOCK_BUTTON" ]]; then
  if command -v playerctl >/dev/null; then
    info=$(playerctl metadata --format "{{artist}} - {{title}}\nAlbum: {{xesam:album}}\nStatus: {{status}}" 2>/dev/null)
  elif command -v mpc >/dev/null; then
    info="$(mpc current)\n$(mpc status | head -n2)"
  else
    info="No player found"
  fi
  [[ -n "$info" ]] && notify "Now Playing" "$info"
  exit
fi

if command -v playerctl >/dev/null; then
  status=$(playerctl status 2>/dev/null)
  player_name=$(playerctl -p spotify status >/dev/null 2>&1 && echo "spotify" || echo "")
  meta=$(playerctl metadata --format '{{artist}} - {{title}}' 2>/dev/null)
  
  if [[ -z $meta || $status == "Stopped" ]]; then
    echo ""
  else
    [[ ${#meta} -gt 30 ]] && meta="${meta:0:27}..."
    icon=""
    [[ $status == "Playing" ]] && icon="" || icon=""
    
    [[ $player_name == "spotify" ]] && icon=" $icon"
    
    echo "$icon $meta $(music_bar)"
  fi
elif command -v mpc >/dev/null; then
  cur=$(mpc current)
  if [[ -z $cur ]]; then
    echo ""
  else
    [[ ${#cur} -gt 30 ]] && cur="${cur:0:27}..."
    echo "♫ $cur $(music_bar)"
  fi
else
  echo ""
fi
