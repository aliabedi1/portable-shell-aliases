$ErrorActionPreference = 'Stop'

$RepoRawUrl = if ($env:PORTABLE_ALIASES_URL) {
    $env:PORTABLE_ALIASES_URL.TrimEnd('/')
} else {
    'https://raw.githubusercontent.com/aliabedi1/portable-shell-aliases/main'
}
$InstallDir = Join-Path $HOME '.portable-shell-aliases'
$AliasesFile = Join-Path $InstallDir 'aliases.ps1'
$LocalAliasesFile = Join-Path $InstallDir 'aliases.local.ps1'
$MarkerStart = '# >>> portable-shell-aliases >>>'
$MarkerEnd = '# <<< portable-shell-aliases <<<'

New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
$TemporaryFile = "$AliasesFile.tmp"

try {
    Invoke-WebRequest -UseBasicParsing -Uri "$RepoRawUrl/aliases.ps1" -OutFile $TemporaryFile
    Move-Item -Path $TemporaryFile -Destination $AliasesFile -Force
    Unblock-File -Path $AliasesFile -ErrorAction SilentlyContinue
} finally {
    Remove-Item -Path $TemporaryFile -Force -ErrorAction SilentlyContinue
}

if (-not (Test-Path $LocalAliasesFile)) {
    Set-Content -Path $LocalAliasesFile -Encoding utf8 -Value '# Add private or machine-specific PowerShell aliases here.'
}

$ProfileFile = $PROFILE.CurrentUserAllHosts
$ProfileDirectory = Split-Path -Parent $ProfileFile
New-Item -ItemType Directory -Path $ProfileDirectory -Force | Out-Null

$ExistingProfile = if (Test-Path $ProfileFile) {
    Get-Content -Path $ProfileFile -Raw
} else {
    ''
}

if ((Test-Path $ProfileFile) -and -not (Test-Path "$ProfileFile.portable-aliases.bak")) {
    Copy-Item -Path $ProfileFile -Destination "$ProfileFile.portable-aliases.bak"
}

$ManagedBlockPattern = '(?ms)^# >>> portable-shell-aliases >>>\r?\n.*?^# <<< portable-shell-aliases <<<\r?\n?'
$CleanProfile = [regex]::Replace($ExistingProfile, $ManagedBlockPattern, '').TrimEnd()
$ManagedBlock = @"
$MarkerStart
. (Join-Path `$HOME '.portable-shell-aliases/aliases.ps1')
$MarkerEnd
"@

$NewProfile = if ($CleanProfile) {
    "$CleanProfile`r`n`r`n$ManagedBlock`r`n"
} else {
    "$ManagedBlock`r`n"
}
Set-Content -Path $ProfileFile -Encoding utf8 -Value $NewProfile

# Windows PowerShell commonly starts with script execution disabled. RemoteSigned
# enables the current user's profile without requiring administrator access.
if ((Get-ExecutionPolicy) -eq 'Restricted') {
    try {
        Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
        Write-Host 'PowerShell execution policy set to RemoteSigned for the current user.'
    } catch {
        Write-Warning "Could not enable the PowerShell profile: $($_.Exception.Message)"
    }
}

try {
    . $AliasesFile
} catch {
    Write-Warning "Aliases were installed but could not be loaded in this session: $($_.Exception.Message)"
}

Write-Host "Configured $ProfileFile"
Write-Host 'Portable aliases installed. Open a new terminal tab to use them.'
