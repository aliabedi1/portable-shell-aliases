# Portable PowerShell equivalents of aliases.sh.
# Installed by https://github.com/aliabedi1/portable-shell-aliases

# PowerShell resolves aliases before functions. Remove name collisions (notably
# the built-in `r` alias) so these portable functions receive the command.
$portableCommandNames = @(
    'll', 'lll', 'la', 'l', 'a', 's', 'rc', 'oc', 'tinker', 'rlist', 'r', 'c', 'req',
    'd', 'pingme', 'cc', 'md', 'dual', 'cu', 'infrastructure', 'payment', 'pyvpn',
    'phpswitch', 'nekoray', 'open', 'bashrc', 'zbashrc', 'czbashrc',
    'zshaliase', 'vp', 'skillin', 'aliases-update'
)
foreach ($portableCommandName in $portableCommandNames) {
    Remove-Item -Path "Alias:$portableCommandName" -Force -ErrorAction SilentlyContinue
}

function global:ll { Get-ChildItem -Force @args }
function global:lll { Get-ChildItem -Force @args | Select-Object -ExpandProperty Name }
function global:la { Get-ChildItem -Force @args }
function global:l { Get-ChildItem @args }

function global:a { & php artisan @args }
function global:s { & php artisan serve @args }
function global:rc { & php artisan route:cache @args }
function global:oc { & php artisan optimize:clear @args }
function global:tinker { & php artisan tinker @args }
function global:rlist { & php artisan 'route:list' @args }
function global:r { & php artisan 'make:resource' @args }
function global:c { & php artisan 'make:controller' @args }
function global:req { & php artisan 'make:request' @args }
function global:d { & php artisan debug @args }

function global:pingme { & ping 4.2.2.4 @args }
function global:cc { Clear-Host }
function global:md { & glow -t @args }
function global:dual { & composer dumpautoload @args }
function global:cu { & composer u --no-cache @args }

function global:infrastructure {
    Set-Location (Join-Path $HOME 'Desktop/dornica-projects/laravel-dev-environment')
}

function global:payment {
    Set-Location (Join-Path $HOME 'Desktop/dornica-projects/payment-system-rebuilt')
}

function global:pyvpn {
    & python (Join-Path $HOME 'Desktop/vpn/MasterHttpRelayVPN/main.py') @args
}

function global:phpswitch {
    if (Get-Command update-alternatives -ErrorAction SilentlyContinue) {
        & sudo update-alternatives --config php
    } else {
        Write-Warning 'phpswitch is only available on systems with update-alternatives.'
    }
}

function global:nekoray {
    if (Test-Path '/opt/nekoray/nekoray') {
        & sudo /opt/nekoray/nekoray
    } else {
        Write-Warning 'nekoray is only available when /opt/nekoray/nekoray exists.'
    }
}

function global:open {
    param([Parameter(Position = 0, Mandatory = $true)][string] $Path)
    Start-Process $Path
}

function global:Invoke-PortableAliasEditor {
    param([Parameter(Mandatory = $true)][string] $Path)

    if (Get-Command code -ErrorAction SilentlyContinue) {
        & code $Path
    } elseif (Get-Command notepad -ErrorAction SilentlyContinue) {
        & notepad $Path
    } else {
        Write-Host $Path
    }
}

function global:bashrc { Invoke-PortableAliasEditor (Join-Path $HOME '.bashrc') }
function global:zbashrc { Invoke-PortableAliasEditor (Join-Path $HOME '.zshrc') }
function global:czbashrc { Invoke-PortableAliasEditor (Join-Path $HOME '.zshrc') }
function global:zshaliase {
    Invoke-PortableAliasEditor (Join-Path $HOME '.portable-shell-aliases/aliases.local.ps1')
}

function global:vp {
    param([Parameter(Position = 0, Mandatory = $true)][string] $Name)
    & php artisan vendor:publish "--tag=dornica-$Name" --force
}

function global:skillin {
    if ($args.Count -eq 0) {
        Write-Error 'Usage: skillin <command> [arguments]'
        return
    }

    $commandName = $args[0]
    $commandArgs = if ($args.Count -gt 1) { $args[1..($args.Count - 1)] } else { @() }
    & $commandName @commandArgs --global --agent claude-code -y
}

function global:aliases-update {
    if ($args.Count -ne 0) {
        throw 'Usage: aliases-update'
    }
    $repoUrl = if ($env:PORTABLE_ALIASES_URL) {
        $env:PORTABLE_ALIASES_URL.TrimEnd('/')
    } else {
        'https://raw.githubusercontent.com/aliabedi1/portable-shell-aliases/main'
    }
    $aliasesFile = Join-Path $HOME '.portable-shell-aliases/aliases.ps1'
    $temporaryFile = "$aliasesFile.$([guid]::NewGuid()).tmp"
    try {
        Invoke-WebRequest -UseBasicParsing -Uri "$repoUrl/aliases.ps1" -OutFile $temporaryFile -ErrorAction Stop
        $parseErrors = $null
        $tokens = $null
        $null = [System.Management.Automation.Language.Parser]::ParseFile($temporaryFile, [ref] $tokens, [ref] $parseErrors)
        if ($parseErrors.Count -gt 0) { throw 'Downloaded aliases contain syntax errors.' }
        Move-Item -Path $temporaryFile -Destination $aliasesFile -Force -ErrorAction Stop
    } finally {
        Remove-Item -Path $temporaryFile -Force -ErrorAction SilentlyContinue
    }
    . $aliasesFile
    Write-Host 'Portable aliases updated and reloaded.'
}

$portableLocalAliases = Join-Path $HOME '.portable-shell-aliases/aliases.local.ps1'
if (Test-Path $portableLocalAliases) {
    . $portableLocalAliases
}
