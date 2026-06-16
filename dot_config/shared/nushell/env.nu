# UI
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# Environment
mise activate nu | save -f ($nu.data-dir | path join "vendor/autoload/mise.nu")
$env.PODMAN_COMPOSE_WARNING_LOGS = false

# Kits
zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")

# Commands Aliases
# For container management
alias docker = podman
alias compose = podman compose

# TODO: Sorting order support...
def rank-file-exts [] {
  let files = ls ...(glob **/* --exclude [**/node_modules/**, **/.git/**]) | where type == file
  let file_basenames = $files | get name | path basename
  let file_extnames = $file_basenames | each { | it | if ($it | str index-of . --end) > 0 { $it | str substring ($it | str index-of . --end)..-1 } else { $it | str substring 0..-1 } }
  $file_extnames | group-by --to-table | each { | it | { ext: $it.group, count: ($it.items | length) } } | sort-by count -r
}
