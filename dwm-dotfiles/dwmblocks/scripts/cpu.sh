#!/usr/bin/env bash

notify() {
  command -v notify-send >/dev/null && notify-send -u low "$1" "$2" -t 5000
}

statfile="/tmp/dwm_cpu_prev"
read -r _ user nice system idle iowait irq softirq steal _ < <(grep '^cpu ' /proc/stat)
total=$((user + nice + system + idle + iowait + irq + softirq + steal))

if [[ -f $statfile ]]; then
  read -r prev_total prev_idle <"$statfile"
else
  prev_total=$total
  prev_idle=$idle
fi

echo "$total $idle" >"$statfile"
totald=$((total - prev_total))
idled=$((idle - prev_idle))
usage=$(((1000 * (totald - idled) / totald + 5) / 10))

# Pilih ikon dan warna sesuai TokyoNight
if ((usage > 75)); then
  icon="🔥"
  color="#f7768e" # merah TokyoNight
elif ((usage > 40)); then
  icon="⚡"
  color="#e0af68" # kuning TokyoNight
else
  icon="💻"
  color="#9ece6a" # hijau TokyoNight
fi

# Klik event
if [[ -n "$BLOCK_BUTTON" ]]; then
  top1=$(ps -eo comm,pcpu --sort=-pcpu | sed -n '2,4p')
  notify "CPU ${usage}%" "$top1"
  exit
fi

# Output untuk DWMbar dengan warna TokyoNight
echo "$icon ${usage}%"
