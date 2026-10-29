# -- ENCODING --
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = [Text.Encoding]::UTF8

# -- ENVIRONMENT --
if (Test-Path "$env:USERPROFILE\bin") {
  $env:PATH = "$env:USERPROFILE\bin;$env:PATH"
}
if (Test-Path "$env:USERPROFILE\.local\bin") {
  $env:PATH = "$env:USERPROFILE\.local\bin;$env:PATH"
}
## Mise, https://mise.jdx.dev/
(&mise activate pwsh) | Out-String | Invoke-Expression
## Starship, https://starship.rs/
(&starship init powershell) | Invoke-Expression
## Zoxide, https://github.com/ajeetdsouza/zoxide
(&zoxide init powershell) | Out-String | Invoke-Expression
## Fnox, https://fnox.jdx.dev/
(&fnox activate powershell) | Out-String | Invoke-Expression

# -- ALIASES --
## GNU flavor
New-Alias -Name which -Value where.exe
New-Alias -Name touch -Value New-Item

New-Alias -Name lzg -Value lazygit
New-Alias -Name ch -Value chezmoi
