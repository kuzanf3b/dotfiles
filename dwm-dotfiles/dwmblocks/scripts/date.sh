### `scripts/date.sh`
$()$(
  bash
  #!/usr/bin/env bash

  notify() { command -v notify-send >/dev/null && notify-send -u low "$1" "$2" -t 5000; }

  if [[ -n "$BLOCK_BUTTON" ]]; then
    notify "Tanggal & Waktu" "$(date '+%A, %d %B %Y\n%H:%M:%S')"
    exit
  fi

  date '+%a %d %b %H:%M'
)$()
