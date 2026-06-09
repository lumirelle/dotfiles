# Encoding
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = [Text.Encoding]::UTF8

# UI
Invoke-Expression (&starship init powershell)

# Environment Variables
if (where.exe chezmoi > $null 2>&1) {
  $env:CHEZMOI_HOME = (&chezmoi source-path)
}
## Mise, https://mise.jdx.dev/
(&mise activate pwsh) | Out-String | Invoke-Expression
## Podman
$env:PODMAN_COMPOSE_WARNING_LOGS = $false

# Commands Aliases
# `which`: Show the path of commands
New-Alias -Name which -Value where.exe
New-Alias -Name touch -Value New-Item
New-Alias -Name tochezmoi -Value To-Chezmoi
function To-Chezmoi {
    cd $env:CHEZMOI_HOME
  }
# For container management
New-Alias -Name docker -Value podman
function Podman-Compose {
  podman compose @args
}
New-Alias -Name compose -Value Podman-Compose
