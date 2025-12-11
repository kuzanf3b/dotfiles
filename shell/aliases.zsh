# ==============================
# ZSH ALIASES CONFIGURATION
# ==============================

# ==============================
# Navigation
# ==============================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias c='clear'
alias rmd='rm -rf'

# ==============================
# File Utilities (eza)
# ==============================
alias ls='eza -lh --icons --git'
alias la='eza -a'
alias ll='eza -la --git'
alias lt='eza --tree --icons'
alias cat="bat --style=plain --paging=never"

# ==============================
# System / Package Manager
# ==============================
# Arch-based
alias syu='sudo pacman -Syu'
alias yyu='yay -Syu'
alias pyu='paru -Syu'

# Fedora
alias sdu='sudo dnf upgrade --refresh'
alias su5='sudo dnf5 upgrade --refresh'

# openSUSE
alias zyuu='sudo zypper refresh && sudo zypper up'
alias zydup='sudo zypper refresh && sudo zypper dup'

# Void Linux
alias xyu='sudo xbps-install -Su'
alias xis='sudo xbps-install'
alias xrs='sudo xbps-remove -R'
alias xq='xbps-query -Rs'

# PopOS
alias au='sudo apt update'
alias auu='sudo apt update && sudo apt upgrade -y'
alias ai='sudo apt install'
alias ar='sudo apt remove'
alias aps='apt search'

# Flatpak
alias fs='flatpak search'
alias flist='flatpak list'
alias fpi='flatpak install'
alias fr='flatpak remove'
alias fu='flatpak update'
alias fcu='flatpak update'

# ==============================
# Zsh Config
# ==============================
alias src='source ~/.zshrc'
alias ezrc='nvim ~/.zshrc'
alias ealias="nvim $ZSH_CUSTOM/aliases.zsh"

# ==============================
# Git
# ==============================
alias ga='git add'
alias gaa='git add --all'
alias gs='git status -sb'
alias gd='git diff'
alias gds='git diff --staged'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
alias gb='git branch'
alias gba='git branch -a'
alias gl='git log --oneline --graph --decorate'
alias gp='git push'
alias gpl='git pull'
alias gf='git fetch --all --prune'
alias gr='git restore'
alias gri='git rebase -i'
alias grc='git rebase --continue'
alias gcl='git clone'

# ==============================
# Editors
# ==============================
alias nv='nvim'
alias v='vim'
alias nvcf='cd ~/.config/nvim'

# ==============================
# Python
# ==============================
alias py='python'
alias pipu='pip install --upgrade pip'
alias venv='python -m venv venv && source venv/bin/activate'

# ==============================
# Node / npm / pnpm
# ==============================
alias nr='npm run'
alias ni='npm install'
alias ns='npm start'
alias nb='npm run build'

alias pn='pnpm'
alias pni='pnpm install'
alias pnr='pnpm run'
alias pnb='pnpm run build'
alias pns='pnpm start'
alias pnx='pnpm dlx'

# ==============================
# PHP / Composer
# ==============================
alias phpv='php -v'
alias phpserv='php -S localhost:8000'

# ==============================
# Flutter
# ==============================
alias fl='flutter'
alias flr='flutter run'
alias flb='flutter build'
alias fld='flutter doctor'
alias flc='flutter clean'
alias flp='flutter pub get'

# ==============================
# Cargo (Rust)
# ==============================
alias cbr='cargo build --release'
alias cb='cargo build'
alias crn='cargo run'
alias ctt='cargo test'

# ==============================
# DWM / X11
# ==============================
alias smci='sudo make clean install'
alias pdwm='patch -i'
alias xrc='nvim ~/.Xresources'
alias xrms='xrdb -merge ~/.Xresources'
alias xrr='xrdb -merge ~/.Xresources'

# ==============================
# Extra Tools / Utilities
# ==============================
alias cpv='rsync -ah --progress'
alias mvv='rsync -ah --progress --remove-source-files'
alias serve='python3 -m http.server 8888'
alias tarnow='tar -czvf'
alias untar='tar -xzvf'

# ==============================
# Fasfetch Shortcuts
# ==============================
alias fastfetch='fastfetch -c ~/.config/fastfetch/config.jsonc'
alias neofetch='fastfetch -c ~/.config/fastfetch/OG.jsonc'
