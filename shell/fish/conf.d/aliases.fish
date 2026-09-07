# ZSH / BASH / FISH Aliases

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias home='cd ~'
alias c='clear'
alias ls='eza -lh --icons --git'

# System / Package Management
alias sydu='sudo dnf5 upgrade --refresh'
alias syzu='sudo zypper refresh; sudo zypper dup' 
alias syu='sudo pacman -Syu'
alias yyu='sudo yay -Syu'
alias pyu='sudo paru -Syu'

# Zsh / Config
alias src='source ~/.zshrc'
alias ealias="nv $ZSH_CUSTOM/aliases.zsh"

# Flatpak Shortcuts
alias fs='flatpak search'
alias sflif='sudo flatpak install flathub'
alias sflrf='sudo flatpak remove flathub'

# Git Shortcuts
alias ga='git add'
alias gs='git status'
alias gc='git commit'
alias gf='git fetch'
alias gr='git reset'
alias gco='git checkout'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'

# VIM / NEOVIM Shortcuts
alias nvcf='cd ~/.config/nvim'
alias vcf='cd ~/.vim/'
alias nv='nvim'
alias v='vim'
alias snv='sudo HOME=/home/zen /usr/sbin/nvim'
alias sv='sudo HOME=/home/zen /usr/sbin/vim'

# DWM Shortcuts
alias smci='sudo make clean install'
alias pdwm='patch -i'
alias xrc='nv ~/.Xresources'
alias xrms='xrdb -merge ~/.Xresources'
