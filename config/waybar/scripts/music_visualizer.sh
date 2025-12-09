#!/usr/bin/env bash

frames=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")

while true; do
  out=""
  for i in {1..5}; do
    out+="${frames[$((RANDOM % ${#frames[@]}))]}"
  done
  echo "$out"
  sleep 0.2
done
