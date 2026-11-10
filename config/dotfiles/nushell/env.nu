# -- ENVIRONMENT --
$env.EDITOR = 'nvim'
$env.VISUAL = 'nvim'
if ($"($nu.home-dir)/bin" | path exists) {
  $env.PATH = ($env.PATH | prepend $"($nu.home-dir)/bin")
}
if ($"($nu.home-dir)/.local/bin" | path exists) {
  $env.PATH = ($env.PATH | prepend $"($nu.home-dir)/.local/bin")
}
## Mise, https://mise.jdx.dev/
let mise_nu = $nu.default-config-dir | path join mise.nu
^mise activate nu | save -f $mise_nu
