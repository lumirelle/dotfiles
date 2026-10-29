# -- ENVIRONMENT SETUP --
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi
## Mise, https://mise.jdx.dev/
eval "$(mise activate bash)"
## Starship, https://starship.rs/
eval "$(starship init bash)"
## Zoxide, https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init bash)"
## Fnox, https://fnox.jdx.dev/
eval "$(fnox activate bash)"
## Worktrunk, https://worktrunk.dev/
eval "$(command wt config shell init bash)"

# -- ALIASES --
alias ch='chezmoi'
alias lzg='lazygit'
