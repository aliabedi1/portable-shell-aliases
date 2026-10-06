#!/bin/sh
set -eu
repo_dir=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' EXIT HUP INT TERM
export HOME="$test_dir/home"
export PORTABLE_ALIASES_URL="file://$repo_dir"
mkdir -p "$HOME/.portable-shell-aliases" "$test_dir/bin"
printf '%s\n' 'alias private_alias="echo private"' > "$HOME/.portable-shell-aliases/aliases.local.sh"
cp "$HOME/.portable-shell-aliases/aliases.local.sh" "$test_dir/local.expected"
sh "$repo_dir/install.sh"
sh "$repo_dir/install.sh"
for profile in .bashrc .bash_profile .zshrc; do
  [ "$(rg -c '^# >>> portable-shell-aliases >>>$' "$HOME/$profile")" = 1 ]
done
cat > "$test_dir/bin/xdg-open" <<'MOCK'
#!/bin/sh
printf '<%s>\n' "$@"
MOCK
chmod +x "$test_dir/bin/xdg-open"
export PATH="$test_dir/bin:$PATH"
for shell in bash zsh; do
  "$shell" -f -c '
    if [ -n "${BASH_VERSION:-}" ]; then shopt -s expand_aliases; fi
    alias open="false"
    alias vp="false"
    alias skillin="false"
    alias aliases-update="false"
    . "$HOME/.portable-shell-aliases/aliases.sh" || exit
    . "$HOME/.portable-shell-aliases/aliases.sh" || exit
    open "a b" "https://example.com" > "$HOME/open.actual"
    printf "<a b>\n<https://example.com>\n" > "$HOME/open.expected"
    cmp "$HOME/open.expected" "$HOME/open.actual" || exit
    eval aliases-update || exit
    alias private_alias >/dev/null || exit
    eval "aliases-update unexpected" && exit 1
    exit 0
  '
done
cmp "$test_dir/local.expected" "$HOME/.portable-shell-aliases/aliases.local.sh"
cp "$HOME/.portable-shell-aliases/aliases.sh" "$test_dir/aliases.expected"
if PORTABLE_ALIASES_URL="file://$test_dir/missing" sh "$HOME/.portable-shell-aliases/update.sh"; then
  echo 'Failed download unexpectedly succeeded' >&2
  exit 1
fi
cmp "$test_dir/aliases.expected" "$HOME/.portable-shell-aliases/aliases.sh"
echo 'Shell regression checks passed.'
