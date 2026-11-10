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

# -- SCRIPT COMMANDS --
# Nushell does not resolve `.nu` scripts from PATH, so expose every script in
# ~/.local/bin as a command. This runs before config.nu is parsed, which
# `source`s the generated file; a new script therefore needs no hand-written
# alias. The file is only rewritten when its contents change.
let script_bin = $nu.home-dir | path join '.local' 'bin'
let script_commands = $nu.default-config-dir | path join 'aliases' 'scripts.nu'
let script_entries = (
  if ($script_bin | path exists) {
    ls $script_bin
    | where {|entry| ($entry.name | path basename) =~ '^[^.].*[.]nu$' }
    | sort-by name
  } else {
    []
  }
)
let script_header = '# Generated from ~/.local/bin/*.nu by env.nu. Do not edit.'
let script_body = (
  [$script_header]
  ++ ($script_entries | each {|entry|
      let stem = ($entry.name | path parse | get stem)
      let path = $entry.name
      $"export def --wrapped ($stem) [...args: string] {\n  ^nu '($path)' ...\$args\n}"
    })
) | str join "\n\n"
let script_current = if ($script_commands | path exists) { open --raw $script_commands } else { '' }
if $script_current != $script_body {
  $script_body | save --force $script_commands
}
