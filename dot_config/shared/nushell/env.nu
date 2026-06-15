# UI
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# Environment
mise activate nu | save -f ($nu.data-dir | path join "vendor/autoload/mise.nu")
$env.PODMAN_COMPOSE_WARNING_LOGS = false

# Commands Aliases
# For container management
alias docker = podman
alias compose = podman compose
