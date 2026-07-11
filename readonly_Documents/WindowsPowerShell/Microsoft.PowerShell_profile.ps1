# Encoding
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = [Text.Encoding]::UTF8

# System Environment
## set PATH so it includes user's private bin if it exists
if (Test-Path "$env:USERPROFILE\bin") { 
  $env:PATH = "$env:USERPROFILE\bin;$env:PATH"
}
## set PATH so it includes user's private bin if it exists
if (Test-Path "$env:USERPROFILE\.local\bin") { 
  $env:PATH = "$env:USERPROFILE\.local\bin;$env:PATH"
}

# Environment
## Mise, https://mise.jdx.dev/
(&mise activate pwsh) | Out-String | Invoke-Expression
## Starship, https://starship.rs/
Invoke-Expression (&starship init powershell)
## Zoxide, https://github.com/ajeetdsouza/zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })
## Podman
$env:PODMAN_COMPOSE_WARNING_LOGS = $false

# Aliases & Custom Commands
New-Alias -Name cz -Value chezmoi
New-Alias -Name docker -Value podman
function Podman-Compose {
  podman compose @args
}
New-Alias -Name compose -Value Podman-Compose
## GNU flavor
New-Alias -Name which -Value where.exe
New-Alias -Name touch -Value New-Item
function degit {
  param([string]$repo, [string]$dest = ".")
  if (Test-Path $dest -PathType Container) {
    if ((Get-ChildItem -Path $dest | Measure-Object).Count -gt 0) {
      Write-Error "Target directory is not empty. Please specify an empty directory or a new directory."
      return
    }
  } else {
    New-Item -Path $dest -ItemType Directory | Out-Null
  }
  $branch = "main"
  if ($repo -match "#(.+)") {
    $branch = $Matches[1]
    $repo = $repo -replace "#.+", ""
  }
  $url = "https://github.com/$repo/archive/refs/heads/$branch.tar.gz"
  Write-Host "Creating project from $url..."
  $tempFile = New-TemporaryFile
  curl.exe -sL -o $tempFile $url
  tar -xzf $tempFile --strip-components=1 -C $dest
  Remove-Item $tempFile
  Write-Host "Done!"
}
