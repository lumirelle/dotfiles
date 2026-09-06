---@type LazySpec
return {
  {
    "apple/pkl-neovim",
    config = function()
      -- pkl-neovim builds its `settings` with flat keys ("pkl.cli.path"), but
      -- Neovim resolves `workspace/configuration` sections as nested lookups
      -- (settings["pkl"]["cli"]["path"]), so pkl-lsp never receives the CLI
      -- path. Its own PATH fallback only probes a file literally named "pkl"
      -- (never "pkl.exe"), which always fails on Windows. vim.g.pkl_neovim has
      -- no settings passthrough, and vim.lsp.start() does not merge
      -- vim.lsp.config[name], so we own the start config here instead and
      -- reuse the plugin's handlers/commands. Drop this override once upstream
      -- ships nested settings.
      local pkl = require("pkl-neovim")
      function pkl.start_lsp()
        vim.lsp.start({
          name = "pkl",
          cmd = { "java", "-XX:+UseCompactObjectHeaders", "-jar", vim.fn.expand("~/.local/bin/pkl-lsp.jar") },
          settings = {
            pkl = {
              cli = { path = vim.fn.exepath("pkl") },
            },
          },
          root_dir = vim.fs.root(0, ".pkl-lsp") or vim.fs.root(0, ".git") or vim.fs.root(0, "PklProject"),
          handlers = require("pkl-neovim.lsp_extensions"),
          commands = require("pkl-neovim.lsp_commands"),
          init_options = {
            extendedClientCapabilities = { actionableRuntimeNotifications = true },
          },
        })
      end
    end,
  },
}
