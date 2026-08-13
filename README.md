# Portable Shell Aliases

My personal command shortcuts, backed up and made installable on Bash, Zsh,
Git Bash, and PowerShell. They work in Warp and other terminals because the
installer configures the shell running inside the terminal.

## Install

### Linux, macOS, WSL, or Git Bash

```sh
curl -fsSL https://raw.githubusercontent.com/aliabedi1/portable-shell-aliases/main/install.sh | sh
```

### Windows PowerShell

```powershell
irm https://raw.githubusercontent.com/aliabedi1/portable-shell-aliases/main/install.ps1 | iex
```

Open a new terminal tab after installation. Re-run the same command whenever
you want to update to the latest aliases.

> Prefer to inspect scripts before running them? Open
> [`install.sh`](./install.sh) or [`install.ps1`](./install.ps1) first.

## What the installer does

- Downloads the aliases into `~/.portable-shell-aliases`.
- Adds a small, clearly marked loading block to the appropriate shell profile.
- Configures `.bashrc`, `.bash_profile`, and `.zshrc` on Unix-like systems.
- Configures the current-user, all-hosts PowerShell profile on Windows.
- Makes a one-time `.portable-aliases.bak` copy before changing an existing profile.
- Preserves `aliases.local.sh` and `aliases.local.ps1` when updating.

The installer is idempotent: running it again updates the aliases without
duplicating profile entries.

## Included shortcuts

The original Laravel, Composer, VPN, project navigation, editor, and utility
shortcuts are included. PowerShell functions provide native equivalents for
commands such as `ll` and `open`. Linux-specific commands such as `nekoray` and
`phpswitch` print a useful warning when their Linux dependency is unavailable.

The untouched source snapshot is kept in
[`backup/original.zsh_aliases`](./backup/original.zsh_aliases).

## Private and machine-specific aliases

Do not commit secrets or machine-only commands to this public repository. Put
them in one of these local files instead:

- Bash/Zsh/Git Bash: `~/.portable-shell-aliases/aliases.local.sh`
- PowerShell: `~/.portable-shell-aliases/aliases.local.ps1`

The installer creates these files once and never overwrites them.

## Customize the public aliases

Edit [`aliases.sh`](./aliases.sh) and [`aliases.ps1`](./aliases.ps1), commit and
push the change, then re-run the install command on each machine.

## Uninstall

Remove the blocks between the `portable-shell-aliases` markers from your shell
profiles, then delete `~/.portable-shell-aliases`. The one-time profile backups
can be used to restore the pre-install state.

## License

[MIT](./LICENSE)
