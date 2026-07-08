# UI
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# Environment
## Mise, https://mise.jdx.dev/
mise activate nu | save -f ($nu.data-dir | path join "vendor/autoload/mise.nu")
$env.PODMAN_COMPOSE_WARNING_LOGS = false

# Kits
zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")

# Commands Aliases
# For container management
alias docker = podman
alias compose = podman compose

# Custom Commands
def --env degit [
  repo: string
  dest: string = "."
] {
  if ($dest | path exists) {
    if (ls -a $dest | is-not-empty) {
      let span = (metadata $dest).span;
      error make {
        msg: "Target directory is not empty. Please specify an empty directory or a new directory.",
        label: { text: "Target directory is not empty", span: $span }
      }
    }
  } else {
    mkdir $dest
  }
  let branch = ($repo | parse "{r}#{b}" | get b | default [ "main" ] --empty | get 0)
  let clean_repo = ($repo | split row "#" | get 0)
  let url = $"https://github.com/($clean_repo)/archive/refs/heads/($branch).tar.gz"
  print $"Creating project from ($url)..."
  http get $url | tar xz --strip-components=1 -C $dest
  print "Done!"
}
# TODO: Sorting order support...
def rank-file-exts [] {
  let files = ls ...(glob **/* --exclude [**/node_modules/**, **/.git/**] --no-dir)
  let file_basenames = $files | get name | path basename
  let file_extnames = $file_basenames | each { | it | if ($it | str index-of . --end) > 0 { $it | str substring ($it | str index-of . --end)..-1 } else { $it | str substring 0..-1 } }
  $file_extnames | group-by --to-table | each { | it | { ext: $it.group, count: ($it.items | length) } } | sort-by count -r
}
