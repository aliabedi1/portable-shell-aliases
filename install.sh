#!/bin/sh
set -eu

REPO_RAW_URL="${PORTABLE_ALIASES_URL:-https://raw.githubusercontent.com/aliabedi1/portable-shell-aliases/main}"
INSTALL_DIR="${PORTABLE_ALIASES_DIR:-$HOME/.portable-shell-aliases}"
MARKER_START='# >>> portable-shell-aliases >>>'
MARKER_END='# <<< portable-shell-aliases <<<'

download() {
  source_url="$1"
  destination="$2"

  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$source_url" -o "$destination"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$destination" "$source_url"
  else
    echo 'Error: curl or wget is required.' >&2
    exit 1
  fi
}

configure_profile() {
  profile_file="$1"
  temp_file="${profile_file}.portable-aliases.tmp.$$"

  if [ -f "$profile_file" ]; then
    if [ ! -f "${profile_file}.portable-aliases.bak" ]; then
      cp "$profile_file" "${profile_file}.portable-aliases.bak"
    fi

    awk -v start="$MARKER_START" -v end="$MARKER_END" '
      $0 == start { hidden = 1; next }
      $0 == end { hidden = 0; next }
      !hidden { print }
    ' "$profile_file" > "$temp_file"
  else
    : > "$temp_file"
  fi

  {
    printf '\n%s\n' "$MARKER_START"
    printf '. "$HOME/.portable-shell-aliases/aliases.sh"\n'
    printf '%s\n' "$MARKER_END"
  } >> "$temp_file"

  mv "$temp_file" "$profile_file"
  echo "Configured $profile_file"
}

mkdir -p "$INSTALL_DIR"
alias_temp="$INSTALL_DIR/aliases.sh.tmp.$$"
update_temp="$INSTALL_DIR/update.sh.tmp.$$"
trap 'rm -f "$alias_temp" "$update_temp"' EXIT HUP INT TERM
download "$REPO_RAW_URL/aliases.sh" "$alias_temp"
download "$REPO_RAW_URL/update.sh" "$update_temp"
sh -n "$alias_temp" "$update_temp"
mv "$alias_temp" "$INSTALL_DIR/aliases.sh"
mv "$update_temp" "$INSTALL_DIR/update.sh"

if [ ! -f "$INSTALL_DIR/aliases.local.sh" ]; then
  printf '%s\n' '# Add private or machine-specific Bash/Zsh aliases here.' > "$INSTALL_DIR/aliases.local.sh"
fi

# Bash reads .bashrc for normal terminals and .bash_profile for login shells
# (including Git Bash on Windows). Sourcing twice is harmless and keeps both covered.
configure_profile "$HOME/.bashrc"
configure_profile "$HOME/.bash_profile"

if command -v zsh >/dev/null 2>&1 || [ -f "$HOME/.zshrc" ]; then
  configure_profile "$HOME/.zshrc"
fi

echo
echo 'Portable aliases installed. Open a new terminal tab to use them.'
