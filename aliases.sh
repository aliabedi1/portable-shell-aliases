# Portable aliases for Bash, Zsh, and Git Bash.
# Installed by https://github.com/aliabedi1/portable-shell-aliases

# Directory listings
alias ll='ls -alF'
alias lll='ls -1a'
alias la='ls -A'
alias l='ls -CF'

# Laravel / PHP
alias a='php artisan'
alias A='php artisan'
alias s='php artisan serve'
alias S='php artisan serve'
alias rc='php artisan route:cache'
alias oc='php artisan optimize:clear'
alias tinker='php artisan tinker'
alias rlist='php artisan route:list'
alias r='php artisan make:resource'
alias c='php artisan make:controller'
alias req='php artisan make:request'
alias d='php artisan debug'
alias D='php artisan debug'

# General tools
alias pingme='ping 4.2.2.4'
alias cc='clear'
alias md='glow -t'
alias dual='composer dumpautoload'
alias cu='composer u --no-cache'

# Machine-specific commands retained from the original alias file.
alias nekoray='sudo /opt/nekoray/nekoray'
alias infrastructure='cd ~/Desktop/dornica-projects/laravel-dev-environment/'
alias payment='cd ~/Desktop/dornica-projects/payment-system-rebuilt/'
alias phpswitch='sudo update-alternatives --config php'
alias pyvpn='python3 ~/Desktop/vpn/MasterHttpRelayVPN/main.py'

# Shell configuration shortcuts
alias bashrc='${EDITOR:-nano} ~/.bashrc'
alias zbashrc='${EDITOR:-nano} ~/.zshrc'
alias czbashrc='code ~/.zshrc'
alias zshaliase='code ~/.portable-shell-aliases/aliases.local.sh'

# Remove existing aliases before parsing function definitions (especially in Zsh).
unalias open vp skillin portable_aliases_update aliases-update 2>/dev/null || :

# Open a file or URL with the operating system's default application.
open() {
  case "$(uname -s 2>/dev/null)" in
    Darwin*) command open "$@" ;;
    MINGW*|MSYS*|CYGWIN*) cmd.exe /c start "" "$@" ;;
    *) xdg-open "$@" ;;
  esac
}

vp() {
  php artisan vendor:publish --tag="dornica-$1" --force
}

skillin() {
  "$@" --global --agent claude-code -y
}

# Update only the shared aliases, then reload them in this shell.
portable_aliases_update() {
  if [ "$#" -ne 0 ]; then
    printf '%s\n' 'Usage: aliases-update' >&2
    return 2
  fi
  sh "${PORTABLE_ALIASES_DIR:-$HOME/.portable-shell-aliases}/update.sh" &&
    . "${PORTABLE_ALIASES_DIR:-$HOME/.portable-shell-aliases}/aliases.sh"
}

alias aliases-update='portable_aliases_update'

# Put private or machine-only additions here. The installer never overwrites it.
if [ -f "$HOME/.portable-shell-aliases/aliases.local.sh" ]; then
  . "$HOME/.portable-shell-aliases/aliases.local.sh"
fi
