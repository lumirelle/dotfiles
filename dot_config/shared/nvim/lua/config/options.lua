-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Gui font, used by Neovide
vim.o.guifont = "0xProto, Symbols Nerd Font, Maple Mono WD CN"

-- Set default shell to Nushell, to get the cross-platform experience
vim.o.shell = "nu"

-- Disable some extension providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Enable ESLint auto format
vim.g.lazyvim_eslint_auto_format = true

-- Neovide specific config
vim.g.neovide_fullscreen = true
vim.g.neovide_title_background_color = "#1f2430"
