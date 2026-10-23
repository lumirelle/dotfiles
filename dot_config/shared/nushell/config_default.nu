# -- ENVIRONMENT (REST) --
# Active Mise before other vender-autoload scripts
use ($nu.default-config-dir | path join mise.nu)
let autoload = $nu.data-dir | path join "vendor/autoload"
mkdir $autoload
# Starship, https://starship.rs/
starship init nu | save -f ($autoload | path join "starship.nu")
## Zoxide, https://github.com/ajeetdsouza/zoxide
zoxide init nushell | save -f ($autoload | path join "zoxide.nu")
## Fnox, https://fnox.jdx.dev/
mise exec -- fnox activate nu | save -f ($autoload | path join "fnox.nu")

# -- CONFIG --
$env.config.show_banner = 'short'
$env.config.buffer_editor = 'nvim'

# -- ALIASES --
source aliases/sudo.nu
source aliases/built-in.nu
source aliases/cwd-file-exts.nu
source aliases/lazygit.nu
source aliases/chezmoi.nu
