#!/bin/bash

bar="▁▂▃▄▅▆▇█"
dict="s/;//g;"

for ((i=0; i<${#bar}; i++)); do
    dict="${dict}s/$i/${bar:$i:1}/g;"
done

config_file="/tmp/waybar_cava_config"

cat > "$config_file" <<EOF
[general]
bars=8

[output]
method=raw
raw_target=/dev/stdout
data_format=ascii
ascii_max_range=7
EOF

cava -p "$config_file" | while read -r line; do
    printf "%s\n" "$(echo "$line" | sed "$dict")" || exit 0
done
