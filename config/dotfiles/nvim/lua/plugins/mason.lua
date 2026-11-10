-- Customize Mason.
-- Configuration documentation can be found with `:h mason`.

---@type LazySpec
return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      -- Apply our local registry before the official one, so that we can override some official packages.
      opts.registries = { "lua:mason-registry-local", "github:mason-org/mason-registry" }
      -- mason runs pip with `--ignore-installed`, so any dependency without a
      -- prebuilt wheel for the current Python is built from source and fails
      -- without a C toolchain. `build-pyyaml.nu` (~/.local/bin) fills this
      -- wheelhouse; pip silently ignores the flag when the directory is absent.
      opts.pip = opts.pip or {}
      opts.pip.install_args = vim.list_extend(
        { "--find-links", vim.fn.expand("~/.local/share/pip-wheelhouse") },
        opts.pip.install_args or {}
      )
    end,
  },

  -- Use mason-tool-installer for automatically installing Mason packages.
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      -- Make sure to use the names found in `:Mason`.
      -- `oxfmt` is a Prettier-compatible formatter; mason-lspconfig maps it to the `oxfmt` LSP.
      ensure_installed = {
        "oxfmt",
      },
    },
  },
}
