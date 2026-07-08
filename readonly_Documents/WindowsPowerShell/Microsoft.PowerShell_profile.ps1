# Encoding
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = [Text.Encoding]::UTF8

# UI
Invoke-Expression (&starship init powershell)

# Environment Variables
## Mise, https://mise.jdx.dev/
(&mise activate pwsh) | Out-String | Invoke-Expression
## Podman
$env:PODMAN_COMPOSE_WARNING_LOGS = $false

# Kits
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# Commands Aliases
# `which`: Show the path of commands
New-Alias -Name which -Value where.exe
New-Alias -Name touch -Value New-Item
# For container management
New-Alias -Name docker -Value podman
function Podman-Compose {
  podman compose @args
}
New-Alias -Name compose -Value Podman-Compose

# Custom Commands
function degit {
  param([string]$repo, [string]$dest = ".")
  if (Test-Path $dest -PathType Container -and (Get-ChildItem -Path $dest | Measure-Object).Count -gt 0) {
    Write-Host "Target directory is not empty. Please specify an empty directory or a new directory."
    return
  }
  $branch = "main"
  if ($repo -match "#(.+)") {
    $branch = $Matches[1]
    $repo = $repo -replace "#.+", ""
  }
  $url = "https://github.com/$repo/archive/refs/heads/$branch.tar.gz"
  curl.exe -sL $url | tar xz --strip-components=1 -C $dest
}
