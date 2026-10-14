# System Environment
## set PATH so it includes user's private bin if it exists
if ($"($env.HOME?)/bin" | path exists) {
  $env.PATH = ($env.PATH | prepend $"($env.HOME)/bin")
}
## set PATH so it includes user's private bin if it exists
if ($"($env.HOME?)/.local/bin" | path exists) {
  $env.PATH = ($env.PATH | prepend $"($env.HOME)/.local/bin")
}
## Mise, https://mise.jdx.dev/
# Regenerate mise.nu on EVERY startup, instead of only when the file is missing.
# Why: `mise activate nu` emits a "snapshot" module -- it hardcodes the PATH from the moment
# activate ran as literals inside mise.nu, instead of prepending to PATH at runtime.
# Generating the file only when it is missing therefore freezes that snapshot on the day it was
# generated, and later PATH additions are never picked up.
let mise_nu = $nu.default-config-dir | path join mise.nu
if (which mise | is-not-empty) {
  ^mise activate nu | save -f $mise_nu
}

# Environment
## Shell
$env.config.show_banner = 'short'
$env.config.buffer_editor = 'nvim'
