#!/bin/sh
set -e

flameshot gui -r | xclip -selection clipboard -t image/png;
