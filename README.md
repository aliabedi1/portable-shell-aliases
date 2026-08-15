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

PowerShell command names are case-insensitive, so `a`/`A`, `s`/`S`, and `d`/`D`
are the same functions there.

| Shortcut | Command or purpose |
| --- | --- |
| `ll` | Detailed directory listing, including hidden files |
| `lll` | List all entries one per line, showing names only |
| `la` | List hidden files |
| `l` | Compact directory listing |
| `a`, `A` | `php artisan` |
| `s`, `S` | `php artisan serve` |
| `rc` | `php artisan route:cache` |
| `oc` | `php artisan optimize:clear` |
| `tinker` | `php artisan tinker` |
| `rlist` | `php artisan route:list` |
| `r` | `php artisan make:resource` |
| `c` | `php artisan make:controller` |
| `req` | `php artisan make:request` |
| `d`, `D` | `php artisan debug` |
| `pingme` | Ping `4.2.2.4` |
| `cc` | Clear the terminal |
| `md FILE` | Render a Markdown file with `glow -t` |
| `dual` | `composer dumpautoload` |
| `cu` | `composer u --no-cache` |
| `infrastructure` | Open the local Laravel development-environment directory |
| `payment` | Open the local payment-system directory |
| `phpswitch` | Select the active PHP version with `update-alternatives` |
| `nekoray` | Start `/opt/nekoray/nekoray` with `sudo` |
| `pyvpn` | Start the local Python VPN script |
| `bashrc` | Edit `~/.bashrc` |
| `zbashrc`, `czbashrc` | Edit `~/.zshrc` |
| `zshaliase` | Edit this install's private, machine-specific alias file |
| `open` | Open a file or URL in the operating system's default application |
| `vp NAME` | Publish the `dornica-NAME` Laravel vendor tag with `--force` |
| `skillin COMMAND` | Run a command with `--global --agent claude-code -y` appended |

PowerShell functions provide native equivalents for commands such as `ll` and
`open`. Linux-specific commands such as `nekoray` and `phpswitch` print a useful
warning when their Linux dependency is unavailable.

The untouched source snapshot is kept in
[`backup/original.zsh_aliases`](./backup/original.zsh_aliases).

## Private and machine-specific aliases

Do not commit secrets or machine-only commands to this public repository. Put
them in one of these local files instead:

- Bash/Zsh/Git Bash: `~/.portable-shell-aliases/aliases.local.sh`
- PowerShell: `~/.portable-shell-aliases/aliases.local.ps1`

The installer creates these files once and never overwrites them.

## Update the shared aliases

Use this workflow for aliases that are safe to publish and should be available
on every machine:

1. Clone this repository if it is not on the machine yet:

   ```sh
   git clone https://github.com/aliabedi1/portable-shell-aliases.git
   cd portable-shell-aliases
   ```

   If it is already cloned, open its directory and get the latest changes:

   ```sh
   cd portable-shell-aliases
   git pull
   ```

2. Edit both [`aliases.sh`](./aliases.sh) and
   [`aliases.ps1`](./aliases.ps1) so Unix shells and PowerShell keep the same
   shortcuts. Simple commands can be aliases in `aliases.sh`; commands that
   accept arguments should be shell functions. PowerShell commands should be
   functions.

   For example, the same new shortcut would look like this:

   ```sh
   # aliases.sh
   alias gs='git status'
   ```

   ```powershell
   # aliases.ps1
   function global:gs { & git status @args }
   ```

   Also add a PowerShell command name to `$portableCommandNames` near the top of
   `aliases.ps1`. That removes any built-in alias with the same name before the
   function is created.

3. Check and publish the change:

   ```sh
   sh -n aliases.sh install.sh
   git diff
   git add aliases.sh aliases.ps1 README.md
   git commit -m "Describe the alias change"
   git push -u origin HEAD
   ```

4. After the change reaches the `main` branch, update each installed machine by
   re-running its install command from the [Install](#install) section. The
   installer downloads the newest shared file and preserves the local alias
   file.

5. Open a new terminal, or reload immediately:

   ```sh
   # Bash
   . ~/.bashrc

   # Zsh
   . ~/.zshrc
   ```

   ```powershell
   # PowerShell
   . $PROFILE.CurrentUserAllHosts
   ```

Do not edit `~/.portable-shell-aliases/aliases.sh` or `aliases.ps1` directly.
Those are installed copies and the next update overwrites them.

## Add private or machine-specific aliases

Use the local file for secrets, private URLs, or commands that only make sense
on one machine:

- Bash/Zsh/Git Bash: `~/.portable-shell-aliases/aliases.local.sh`
- PowerShell: `~/.portable-shell-aliases/aliases.local.ps1`

The `zshaliase` shortcut opens the appropriate local file. Save the change and
reload the shell using the commands above. These files are created once, are
not stored in this repository, and are never overwritten by the installer.

Examples:

```sh
# aliases.local.sh
alias workserver='ssh user@private-host'
```

```powershell
# aliases.local.ps1
function global:workserver { ssh user@private-host }
```

## Uninstall

Remove the blocks between the `portable-shell-aliases` markers from your shell
profiles, then delete `~/.portable-shell-aliases`. The one-time profile backups
can be used to restore the pre-install state.

## License

[MIT](./LICENSE)
