#!/bin/sh
set -eu

REPO_RAW_URL="${PORTABLE_ALIASES_URL:-https://raw.githubusercontent.com/aliabedi1/portable-shell-aliases/main}"
INSTALL_DIR="${PORTABLE_ALIASES_DIR:-$HOME/.portable-shell-aliases}"
mkdir -p "$INSTALL_DIR"
alias_temp=$(mktemp "$INSTALL_DIR/aliases.sh.tmp.XXXXXX")
trap 'rm -f "$alias_temp"' EXIT HUP INT TERM
if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$REPO_RAW_URL/aliases.sh" -o "$alias_temp"
elif command -v wget >/dev/null 2>&1; then
  wget -qO "$alias_temp" "$REPO_RAW_URL/aliases.sh"
else
  echo 'Error: curl or wget is required.' >&2
  exit 1
fi
sh -n "$alias_temp"
mv "$alias_temp" "$INSTALL_DIR/aliases.sh"
echo 'Portable aliases updated.'
