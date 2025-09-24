### `scripts/song.sh`
$()$(
  bash
  #!/usr/bin/env bash

  notify() { command -v notify-send >/dev/null && notify-send -u low "$1" "$2" -t 5000; }

  if [[ -n "$BLOCK_BUTTON" ]]; then
    if command -v playerctl >/dev/null; then
      info=$(playerctl metadata --format "{{artist}} - {{title}}\nAlbum: {{xesam:album}}\nStatus: {{status}}")
    elif command -v mpc >/dev/null; then
      info="$(mpc current)\n$(mpc status | head -n2)"
    else
      info="No player found"
    fi
    notify "Now Playing" "$info"
    exit
  fi

  if command -v playerctl >/dev/null; then
    status=$(playerctl status 2>/dev/null)
    meta=$(playerctl metadata --format '{{artist}} - {{title}}' 2>/dev/null)
    [[ -z $meta ]] && echo "—" || {
      [[ ${#meta} -gt 40 ]] && meta="${meta:0:37}..."
      [[ $status == Playing ]] && echo "▶ $meta" || echo "⏸ $meta"
    }
  elif command -v mpc >/dev/null; then
    cur=$(mpc current)
    [[ -z $cur ]] && echo "—" || echo "♫ ${cur:0:40}"
  else
    echo "—"
  fi
)$()
