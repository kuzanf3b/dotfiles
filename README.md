## Overview

This repository contains multiple desktop setups focused on speed, minimalism, and aesthetics. Each setup is self-contained, so you can pick one (or more) and apply it independently.

> Built and tested on Arch Linux.

## What’s Inside

- **Hyprland** (Wayland)
- **Niri** (Wayland)
- **MangoWM** (Wayland)
- **i3** (X11)
- Additional configs/tools (e.g. Neovim, suckless utilities)

## Requirements

### AUR helper
Most install commands below use **paru**. If you don’t have it:

```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

### Fonts
Install the fonts used by the themes/UI:

- JetBrainsMono Nerd Font
- DroidSansMono Nerd Font
- Material Symbols Rounded

(Install via pacman/AUR or your preferred method.)

## Installation

### 1) Clone the repo

```bash
git clone https://github.com/kuzanf3b/dotfiles.git
cd dotfiles
```

### 2) Install dependencies (choose your setup)

> Notes:
> - Package names are written for Arch Linux.
> - Some packages are in the AUR (so `paru -S` is used).

#### DWM (GOAT) 🐐
See the [`DWM Configuration`](https://github.com/kuzanf3b/dotfiles/tree/main/suckless/dwm) — This dwm v6.6 configuration, maybe update soon to the latest

#### Hyprland

```bash
paru -S hyprland wlroots wayland xorg-xwayland wayland-protocols xdg-desktop-portal-hyprland xdg-desktop-portal qt5-wayland qt6-wayland polkit ghostty thunar thunar-volman tumbler tumbler-plugins-extra gvfs gvfs-mtp gvfs-gphoto2 gvfs-smb wofi swayidle swaylock-effects xdg-user-dirs pipewire pipewire-pulse wireplumber brightnessctl playerctl network-manager-applet bluez bluez-utils blueman pavucontrol grim slurp wl-clipboard hyprpaper hyprlock hypridle
```

#### Niri

```bash
paru -S niri wayland xorg-xwayland xwayland-satellite wayland-protocols xdg-desktop-portal xdg-desktop-portal-gtk polkit ghostty thunar thunar-volman tumbler tumbler-plugins-extra gvfs gvfs-mtp gvfs-gphoto2 gvfs-smb wofi swayidle swaylock-effects xdg-user-dirs pipewire pipewire-pulse wireplumber brightnessctl playerctl network-manager-applet bluez bluez-utils blueman pavucontrol grim slurp wl-clipboard
```

#### MangoWM

```bash
paru -S mangowm wlroots xorg-xwayland wayland wayland-protocols xdg-desktop-portal xdg-desktop-portal-wlr polkit ghostty thunar thunar-volman tumbler tumbler-plugins-extra gvfs gvfs-mtp gvfs-gphoto2 gvfs-smb wofi swayidle swaylock-effects xdg-user-dirs pipewire pipewire-pulse wireplumber brightnessctl playerctl network-manager-applet bluez bluez-utils blueman pavucontrol grim slurp wl-clipboard
```

#### i3 (X11)

```bash
paru -S i3-wm i3status i3lock polybar alacritty thunar thunar-volman tumbler tumbler-plugins-extra gvfs gvfs-mtp gvfs-gphoto2 gvfs-smb rofi swaylock-effects swayidle xdotool xorg-server xorg-xinit xorg-xrandr xorg-xsetroot picom feh dunst network-manager-applet bluez bluez-utils blueman pavucontrol brightnessctl playerctl
```

### 3) Apply configs

This repo is structured as a dotfiles collection. The safest approach is to **copy/merge** what you need instead of overwriting your entire `$HOME`.

Example (manual):

```bash
# Inspect first
ls -la

# Then copy what you need, e.g.
cp -r nvim/.config/nvim ~/.config/
```

If you prefer symlinks, use `stow` (recommended):

```bash
sudo pacman -S stow
stow nvim
```

(Repeat `stow <folder>` for the components you want.)

## Future Plans

- Nix/Home Manager support
- Unified theme switcher (Tokyo Night ↔ Rosé Pine ↔ Kanagawa ↔ Vague)
- Complete preview gallery
