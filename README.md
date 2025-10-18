# 🌌 Dotfiles Collection

[![Arch Linux](https://img.shields.io/badge/OS-ArchLinux-blue?logo=archlinux)](https://archlinux.org/)  
[![Wayland](https://img.shields.io/badge/Display%20Server-Wayland-brightgreen)](https://wayland.freedesktop.org/)  
[![Neovim](https://img.shields.io/badge/Editor-Neovim-green?logo=neovim)](https://neovim.io/)

> A curated collection of my Linux dotfiles for various window managers and workflows.

---

## 🧠 Overview

This repository contains multiple desktop setups customized for speed, minimalism, and aesthetics. Each setup is self-contained and can be applied independently.

| Environment | Description |
|------------|------------|
| 🪶 **dwl-dotfiles** | Lightweight Wayland tiling WM setup for daily coding. |
| 🧱 **dwm-dotfiles** | Classic X11 tiling WM with patches for keyboard-driven workflow. |
| 🌀 **hyprland-dotfiles** | Modern Wayland compositor setup with animations and Waybar. |
| 🧩 **niri-dotfiles** | Experimental compositor setup with smooth transitions. |
| 🍋 **mango-dotfiles** | Personal hybrid setup for tinkering and visual experiments. |

---

## ⚙️ Features

- Minimal and modular configuration  
- Unified colors: Tokyo Night / Rosé Pine palette  
- JetBrainsMono Nerd Font for terminals  
- Low resource usage  
- Pipewire audio, battery, and workspace indicators  
- Modular folder structure for easy switching between setups  

---

## 🧰 Requirements & Installation

# Install common dependencies (Arch example)
sudo pacman -S waybar foot kitty tmux neovim pipewire brightnessctl playerctl

# Clone the repository
git clone https://github.com/kuzanf3b/dotfiles ~/.dotfiles

# Apply a setup using stow
cd ~/.dotfiles/dwl-dotfiles
stow .

# Or manually link configs
ln -sf ~/.dotfiles/dwl-dotfiles/.config/* ~/.config/

> Swap symlinks to change setups without touching the repo content.

Fonts:  
- JetBrainsMono Nerd Font  
- Material Symbols Rounded  

---

## 🖼️ Previews

## 🖼️ Previews

| dwl | dwm | hyprland | niri | mango |
|-----|-----|----------|------|-------|
| ![dwl](dwl-dotfiles/preview.png) | ![dwm](dwm-dotfiles/preview.png) | ![hyprland](hyprland-dotfiles/preview.png) | ![niri](niri-dotfiles/preview.png) | ![mango](mango-dotfiles/preview.png) |

---

## 🧬 Structure

```
dotfiles/
├── dwl-dotfiles/
├── dwm-dotfiles/
├── hyprland-dotfiles/
├── niri-dotfiles/
└── mango-dotfiles/
```

Each directory contains its own `.config/` ready to symlink or `stow`.

---

## 🧤 Philosophy

> Ricing is about understanding and controlling your environment.  

Clean, minimal, and functional — every setup has only what’s necessary to work efficiently while looking nice.

---

## 🚧 Future Plans

- Nix/Home Manager support  
- Unified theme switcher (Tokyo Night ↔ Rosé Pine)  
- Auto-install scripts for Arch-based systems  
- Improved Waybar animations  
- Complete preview gallery  

---

> 🩵 Handcrafted on Arch Linux. Built for productivity, curiosity, and aesthetic enjoyment.
