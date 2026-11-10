# -- ENCODING --
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = [Text.Encoding]::UTF8

# -- ENVIRONMENT --
$env:EDITOR = "nvim"
$env:VISUAL = "nvim"
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


# -- WSL --
## Open WSL in the Linux user's home dir instead of the translated Windows cwd
## (C:\Users\me -> /mnt/c/Users/me). Management invocations such as `wsl -l` or
## `wsl --shutdown` are passed through untouched.
function wsl {
  $management = @(
    '-l', '--list', '--status', '--version', '-v', '--help', '-h',
    '--shutdown', '--terminate', '-t', '--update', '--uninstall',
    '--import', '--import-in-place', '--export', '--unregister',
    '--install', '--mount', '--unmount', '--manage', '--set-default', '-s',
    '--set-default-version', '--set-version', '--debug-shell', '--cd'
  )
  if ($args | Where-Object { $management -contains $_ }) {
    wsl.exe @args
  } else {
    wsl.exe --cd '~' @args
  }
}
