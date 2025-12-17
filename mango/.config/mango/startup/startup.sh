#!/bin/bash

# Polkit agent (WAJIB untuk mount, power, dll)
pkill polkit-gnome-authentication-agent-1
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# Waybar
pkill waybar
waybar &

# Mako
pkill mako
mako &

# Wallpaper daemon
pkill swww-daemon
swww-daemon &
swww img ~/Pictures/Wallpapers/windows10.jpg

# Idle & lock
swayidle -w \
    timeout 300 'makoctl mode -a away && swaylock -f --config ~/.config/swaylock/config' \
    resume 'makoctl mode -r away' \
    timeout 600 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on"' \
    before-sleep 'swaylock -f --config ~/.config/swaylock/config' &

# Portal
/usr/lib/xdg-desktop-portal-wlr &
