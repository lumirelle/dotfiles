# -- ENVIRONMENT --
## Mise, https://mise.jdx.dev/
let mise_nu = $nu.default-config-dir | path join mise.nu
^mise activate nu | save -f $mise_nu
