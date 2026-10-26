-- Customize Mason.
-- Configuration documentation can be found with `:h mason`.

---@type LazySpec
return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      -- Apply our local registry before the official one, so that we can override some official packages.
      opts.registries = { "lua:mason-registry-local", "github:mason-org/mason-registry" }
    end,
  },

  -- Use mason-tool-installer for automatically installing Mason packages.
  -- {
  --   "WhoIsSethDaniel/mason-tool-installer.nvim",
  --   opts = {
  --     -- Make sure to use the names found in `:Mason`
  --     ensure_installed = {
  --       "lua-language-server",
  --       "stylua",
  --       "debugpy",
  --       "tree-sitter-cli",
  --     },
  --   },
  -- },
}
