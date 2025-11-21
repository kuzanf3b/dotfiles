#!/bin/sh
set -e

flameshot gui -r --region window | xclip -selection clipboard -t image/png;
