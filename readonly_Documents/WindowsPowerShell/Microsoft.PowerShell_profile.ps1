# System Environment
## set PATH so it includes user's private bin if it exists
if (Test-Path "$env:USERPROFILE\bin") {
  $env:PATH = "$env:USERPROFILE\bin;$env:PATH"
}
## set PATH so it includes user's private bin if it exists
if (Test-Path "$env:USERPROFILE\.local\bin") {
  $env:PATH = "$env:USERPROFILE\.local\bin;$env:PATH"
}
## Mise, https://mise.jdx.dev/
(&mise activate pwsh) | Out-String | Invoke-Expression

# Environment
## Shell
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = [Text.Encoding]::UTF8
## Starship, https://starship.rs/
Invoke-Expression (&starship init powershell)
## Zoxide, https://github.com/ajeetdsouza/zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })
## Fnox, https://fnox.jdx.dev/
Invoke-Expression (& { (fnox activate powershell | Out-String) })
## Podman
$env:PODMAN_COMPOSE_WARNING_LOGS = $false

# Aliases & Custom Commands
New-Alias -Name lg -Value lazygit
New-Alias -Name ch -Value chezmoi
## GNU flavor
New-Alias -Name which -Value where.exe
New-Alias -Name touch -Value New-Item
