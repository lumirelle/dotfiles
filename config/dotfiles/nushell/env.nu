# -- ENVIRONMENT --
if ($"($nu.home-dir)/bin" | path exists) {
  $env.PATH = ($env.PATH | prepend $"($nu.home-dir)/bin")
}
if ($"($nu.home-dir)/.local/bin" | path exists) {
  $env.PATH = ($env.PATH | prepend $"($nu.home-dir)/.local/bin")
}
## Mise, https://mise.jdx.dev/
let mise_nu = $nu.default-config-dir | path join mise.nu
^mise activate nu | save -f $mise_nu
## 1. Disguise as Kitty, deceive Snacks.nvim.
## Rio currently supports Kitty Graphic Protocol, but does not being added to the terminal whitelist of Snacks.nvim.
$env.SNACKS_KITTY = true
