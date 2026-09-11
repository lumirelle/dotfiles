# System Environment
## set PATH so it includes user's private bin if it exists
if ($"($env.HOME?)/bin" | path exists) {
  $env.PATH = ($env.PATH | prepend $"($env.HOME)/bin")
}
## set PATH so it includes user's private bin if it exists
if ($"($env.HOME?)/.local/bin" | path exists) {
  $env.PATH = ($env.PATH | prepend $"($env.HOME)/.local/bin")
}

# Environment
## Shell
$env.config.show_banner = 'short'
$env.config.buffer_editor = 'nvim'
## Mise, https://mise.jdx.dev/
let mise_nu = $nu.default-config-dir | path join mise.nu
if not ($mise_nu | path exists) {
  ^mise activate nu | save -f $mise_nu
}
