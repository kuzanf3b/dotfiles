#!/usr/bin/env bash

pkill waybar
pkill swaync

waybar &
swaync &
