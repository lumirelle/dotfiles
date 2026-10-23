# -- ENVIRONMENT --
if ($"($env.HOME?)/bin" | path exists) {
  $env.PATH = ($env.PATH | prepend $"($env.HOME)/bin")
}
if ($"($env.HOME?)/.local/bin" | path exists) {
  $env.PATH = ($env.PATH | prepend $"($env.HOME)/.local/bin")
}
## Mise, https://mise.jdx.dev/
let mise_nu = $nu.default-config-dir | path join mise.nu
^mise activate nu | save -f $mise_nu
