-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine.
-- Configuration documentation can be found with `:h astrolsp`.

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@param opts AstroLSPOpts
  opts = function(_, opts)
    -- AstroNvim enables Mason-installed servers from its mason-lspconfig config, but that path is wrapped in
    -- `vim.schedule_wrap`, so it runs just *after* the FileType event of the session's first buffer and that buffer
    -- never gets a client (symptom: `is_enabled=true` but `clients=0`, and `:e` fixes it). `opts.servers` is enabled
    -- synchronously by astrolsp during its own setup, therefore ahead of that event.
    --
    -- The list is derived from the installed Mason packages instead of being hardcoded, so a newly `:MasonInstall`ed
    -- server is covered without touching this file. Servernames come from Mason's own package->lspconfig mapping, and
    -- `vim.lsp.config[name]` is nil for names nvim-lspconfig does not know, which filters out Mason packages that are
    -- not language servers (a formatter, a DAP adapter, ...).
    local ok, mapping = pcall(function()
      return require("mason-lspconfig.mappings").get_mason_map().package_to_lspconfig
    end)
    if ok then
      -- mason.nvim is only loaded on demand, so make sure mason-registry is requireable.
      if not pcall(require, "mason-registry") then
        pcall(function()
          require("lazy").load({ plugins = { "mason.nvim" } })
        end)
      end
      local registry_ok, registry = pcall(require, "mason-registry")
      if registry_ok then
        local servers = opts.servers or {}
        for _, pkg in ipairs(registry.get_installed_package_names()) do
          local server = mapping[pkg]
          if server and vim.lsp.config[server] then
            servers = require("astrocore").list_insert_unique(servers, { server })
          end
        end
        opts.servers = servers
      end
    end

    -- Neovim 0.12+ deprecates the old API `on_new_config`, which the astrocommunity json/yaml packs rely on to inject
    -- SchemaStore catalogs. This is a workaround that migrate those packs to new API `before_init`.
    -- Please refer to https://github.com/AstroNvim/astrocommunity/pull/1789 to track the status of upstream fixes.
    opts.config = vim.tbl_deep_extend("force", opts.config or {}, {
      jsonls = {
        before_init = function(_, config)
          config.settings = config.settings or {}
          config.settings.json = config.settings.json or {}
          config.settings.json.schemas = config.settings.json.schemas or {}
          vim.list_extend(config.settings.json.schemas, require("schemastore").json.schemas())
        end,
      },
      yamlls = {
        before_init = function(_, config)
          config.settings = config.settings or {}
          config.settings.yaml = config.settings.yaml or {}
          config.settings.yaml.schemas =
            vim.tbl_deep_extend("force", config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
        end,
      },
    })
  end,
}
