#!/bin/sh
set -e

flameshot full -r | xclip -selection clipboard -t image/png
