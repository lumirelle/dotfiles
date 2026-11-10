-- Customize Mason.
-- Configuration documentation can be found with `:h mason`.

---@type LazySpec
return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      -- Apply our local registry before the official one, so that we can override some official packages.
      opts.registries = { "lua:mason-registry-local", "github:mason-org/mason-registry" }
      -- PyYAML 6.0.3 没有 cp315 的预编译 wheel；mason 的 pip 调用带 `--ignore-installed`，
      -- 会无视已安装的包重新从源码构建，在没有 MSVC 的机器上必定失败。
      -- 这里让它优先使用本地预编译 wheel：~/.local/share/pip-wheelhouse/
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
