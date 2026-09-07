source /usr/share/cachyos-fish-config/cachyos-config.fish

set -Ux PATH $PATH $HOME/.deno/bin
set -x PATH $HOME/.npm-global/bin $PATH
set -U fish_user_paths $HOME/flutter/bin $fish_user_paths
set -Ux CHROME_EXECUTABLE /usr/sbin/brave

if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c) >/dev/null 2>&1
end

if test -f ~/.ssh/id_ed25519
    ssh-add -q ~/.ssh/id_ed25519 >/dev/null 2>&1
end

function fish_greeting
    # fastfetch
end

