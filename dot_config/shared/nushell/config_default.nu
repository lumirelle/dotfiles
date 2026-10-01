# Environment
# To ensure `mise env` is activated before we accessing bellow mise-managed executables,
# we init them inside `config.nu` instead of `env.nu`
let autoload = $nu.data-dir | path join "vendor/autoload"
if not ($autoload | path exists) { mkdir $autoload }
def --env gen-once [name: string, cmd: closure] {
  let f = $autoload | path join $name
  if not ($f | path exists) {
    do $cmd | save -f $f
  }
}
# Starship, https://starship.rs/
gen-once starship.nu { starship init nu }
## Zoxide, https://github.com/ajeetdsouza/zoxide
gen-once zoxide.nu { zoxide init nushell }
## Fnox, https://fnox.jdx.dev/
gen-once fnox.nu { fnox activate nu }

# Aliases
source aliases/sudo.nu
source aliases/built-in.nu
source aliases/cwd-file-exts.nu
source aliases/lazygit.nu
source aliases/chezmoi.nu
source aliases/podman.nu
