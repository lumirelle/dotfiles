# -- ENVIRONMENT --
# Use $nu.home-dir, not $env.HOME: `nushell` started from Explorer/Windows Terminal
# has no HOME env var, which made the old `$env.HOME?` checks resolve to
# `/.local/bin` (i.e. C:\.local\bin) and silently skip the prepend.
for dir in [($nu.home-dir | path join 'bin') ($nu.home-dir | path join '.local' 'bin')] {
  if ($dir | path exists) {
    $env.PATH = ($env.PATH | prepend $dir)
  }
}
## Mise, https://mise.jdx.dev/
let mise_nu = $nu.default-config-dir | path join mise.nu
^mise activate nu | save -f $mise_nu
