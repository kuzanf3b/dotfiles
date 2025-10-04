#!/bin/sh

xrandr --output eDP-1 --mode 1920x1080 --rate 144 &

setxkbmap us &

feh --bg-scale ~/Pictures/Wallpapers/mainwall3.png

picom --config ~/.config/picom/picom.conf --backend glx -b &

if command -v dbus-launch >/dev/null 2>&1 && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
  eval $(dbus-launch --sh-syntax --exit-with-session)
fi

nm-applet &

xsetroot -cursor_name left_ptr &

dwmblocks &

xset r rate 200 35

export XCURSOR_THEME="Bibata-Modern-Ice"
export XCURSOR_SIZE=12

xsetroot -cursor_name left_ptr

export PATH=$PATH:/usr/local/bin

xrdb -merge ~/.Xresources

exec dwm
