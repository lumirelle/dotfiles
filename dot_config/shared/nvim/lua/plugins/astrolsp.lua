-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    config = {
      -- Neovim 0.12 no longer invokes `on_new_config`, which the astrocommunity json/yaml
      -- packs rely on to inject SchemaStore catalogs. Re-inject via `before_init`, which
      -- 0.12 still calls with a per-client deep copy of the config.
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
    },
  },
}
