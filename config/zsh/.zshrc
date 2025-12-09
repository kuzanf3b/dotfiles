# ================================
# PATHS
# ================================

PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"

PATH="$HOME/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.local/bin/src:$PATH"
PATH="$HOME/.config/composer/vendor/bin:$PATH"
PATH="$HOME/.deno/bin:$PATH"
PATH="$HOME/.npm-global/bin:$PATH"
PATH="$HOME/flutter/bin:$PATH"
PATH="$PATH:/home/kuzan/.dotnet/tools"

export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
PATH="$JAVA_HOME/bin:$PATH"

export PATH
export CHROME_EXECUTABLE="/usr/sbin/brave"

# ================================
# OH-MY-ZSH
# ================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="simple"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  colored-man-pages
)

source "$ZSH/oh-my-zsh.sh"

# ================================
# OPTIONS
# ================================
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"

export EDITOR="nvim"
export VISUAL="nvim"

# ================================
# Compinit Optimization
# ================================
autoload -Uz compinit
if [[ -f "$HOME/.zcompdump" ]]; then
  compinit -C
else
  compinit
fi

# ================================
# KEYBINDS
# ================================
bindkey -s '^G' 'lazygit\n'
bindkey -s '^F' 'fzf-nvim\n'
