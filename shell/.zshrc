# PATHS
PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"

PATH="$HOME/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.local/bin/src:$PATH"
PATH="$HOME/.config/composer/vendor/bin:$PATH"
PATH="$HOME/.deno/bin:$PATH"
PATH="$HOME/.npm-global/bin:$PATH"
PATH="$HOME/.local/share/pnpm/bin:$PATH"
PATH="$HOME/.luarocks/bin:$PATH"
PATH="$HOME/flutter/bin:$PATH"
PATH="$PATH:/home/kuzan/.dotnet/tools"
PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"

export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
PATH="$JAVA_HOME/bin:$PATH"


export PATH
export CHROME_EXECUTABLE="/usr/sbin/brave"


# OH-MY-ZSH
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="awesomepanda" # fwalch, half-life, macovsky, minimal, simple, refined

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  colored-man-pages
)

source "$ZSH/oh-my-zsh.sh"

# OPTIONS
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"

export EDITOR="nvim"
export VISUAL="nvim"

# Compinit Optimization
autoload -Uz compinit
if [[ -f "$HOME/.zcompdump" ]]; then
  compinit -C
else
  compinit
fi

# KEYBINDS
bindkey -s '^G' 'lazygit\n'
bindkey -s '^F' 'fzf-nvim\n'

# opencode
export PATH=/home/kuzan/.opencode/bin:$PATH

# pnpm
export PNPM_HOME='/home/kuzan/.local/share/pnpm'
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# Unity CLI
case ":${PATH}:" in *:"$HOME/.local/bin":*) ;; *) export PATH="$HOME/.local/bin:$PATH" ;; esac
