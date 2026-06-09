# UI
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# Environment
if (which chezmoi | is-not-empty) {
  $env.CHEZMOI_HOME = (chezmoi source-path)
}
mise activate nu | save -f ($nu.data-dir | path join "vendor/autoload/mise.nu")
$env.PODMAN_COMPOSE_WARNING_LOGS = false

# Commands Aliases
alias tochezmoi = cd $env.CHEZMOI_HOME
# For container management
alias docker = podman
alias compose = podman compose
