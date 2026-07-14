# System Environment
## set PATH so it includes user's private bin if it exists
if ($"($env.HOME?)/bin" | path exists) {
  $env.PATH = ($env.PATH | prepend $"($env.HOME)/bin")
}
## set PATH so it includes user's private bin if it exists
if ($"($env.HOME?)/.local/bin" | path exists) {
  $env.PATH = ($env.PATH | prepend $"($env.HOME)/.local/bin")
}
mkdir ($nu.data-dir | path join "vendor/autoload")
let mise_path = $nu.default-config-dir | path join mise.nu
$env.NU_LIB_DIRS | append ($mise_path | path dirname | to nuon)

# Environment
## Shell
$env.config.show_banner = 'short'
$env.config.buffer_editor = 'nvim'
## Starship, https://starship.rs/
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
## Zoxide, https://github.com/ajeetdsouza/zoxide
zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")
## Podman
$env.PODMAN_COMPOSE_WARNING_LOGS = false

# Aliases & Custom Commands
alias cz = chezmoi
alias docker = podman
alias compose = podman compose
# Create a new project from a GitHub repository without cloning the entire repository history.
@example "Create a new project from a GitHub repository" {degit 'user/repo#branch' dest}
def --env degit [
  repo: string # The GitHub repository in the format "user/repo#branch". the branch is optional, defaults to "main"
  dest: string = "." # The destination directory where the project will be created
] {
  if ($dest | path exists) {
    if (ls -a $dest | is-not-empty) {
      let span = (metadata $dest).span
      error make {
        msg: "Target directory is not empty. Please specify an empty directory or a new directory."
        label: {text: "Target directory is not empty", span: $span}
      }
    }
  } else {
    mkdir $dest
  }
  let branch = (
    $repo
    | parse "{r}#{b}"
    | get b
    | default ["main"] --empty
    | get 0
  )
  let clean_repo = $repo | split row "#" | get 0
  let url = $"https://github.com/($clean_repo)/archive/refs/heads/($branch).tar.gz"
  print $"Creating project from ($url)..."
  http get $url | tar -xz --strip-components=1 -C $dest
  print "Done!"
}
# TODO: Sorting order support...
def rank-file-exts [] {
  let files = ls ...(glob **/* --exclude [**/node_modules/**, **/.git/**] --no-dir)
  let file_basenames = $files | get name | path basename
  let file_extnames = $file_basenames | each {| it | if ($it | str index-of . --end) > 0 { $it | str substring ($it | str index-of . --end)..-1 } else { $it | str substring 0..-1 } }
  $file_extnames | group-by --to-table | each {| it | { ext: $it.group, count: ($it.items | length) } } | sort-by count -r
}
