---@type LazySpec
return {
  {
    "apple/pkl-neovim",
    config = function()
      -- `pkl-neovim` builds its `settings` with flat keys ("pkl.cli.path"), but Neovim resolves
      -- `workspace/configuration` sections as nested lookups (settings["pkl"]["cli"]["path"]), so pkl-lsp never
      -- receives the CLI path. See GitHub issue report https://github.com/apple/pkl-neovim/issues/74 for more details.
      --
      -- Below override is a patch based on https://github.com/apple/pkl-neovim/blob/main/lua/pkl-neovim.lua#L97. Drop
      -- this override once upstream ships nested settings.
      local pkl = require("pkl-neovim")
      function pkl.start_lsp()
        vim.lsp.start({
          name = "pkl",
          settings = {
            pkl = {
              cli = { path = vim.fn.exepath("pkl") },
            },
          },
          root_dir = vim.fs.root(0, ".pkl-lsp") or vim.fs.root(0, ".git") or vim.fs.root(0, "PklProject"),
          cmd = { "java", "-XX:+UseCompactObjectHeaders", "-jar", vim.fn.expand("~/.local/bin/pkl-lsp.jar") },
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
