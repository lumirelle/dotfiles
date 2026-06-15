-- Map *.json files to jsonc, as they are actually in jonsc syntax
vim.filetype.add({
  pattern = {
    [".*%.json"] = "jsonc",
  },
})

-- ESLint as formatter
local eslint_support_filetypes = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "vue",
  "html",
  "markdown",
  "json",
  "jsonc",
  "yaml",
  "toml",
  "xml",
  "css",
  "postcss",
  "scss",
  "sass",
  "less",
}
local eslint_support_file_patterns = {
  "*.js",
  "*.mjs",
  "*.cjs",
  "*.jsx",
  "*.ts",
  "*.mts",
  "*.cts",
  "*.tsx",
  "*.vue",
  "*.html",
  "*.htm",
  "*.md",
  "*.mdc",
  "*.mdx",
  "*.json",
  "*.jsonc",
  "*.yaml",
  "*.yml",
  "*.toml",
  "*.xml",
  "*.css",
  "*.postcss",
  "*.scss",
  "*.sass",
  "*.less",
}
-- Disable other formatter conflict with ESLint
require("snacks").util.lsp.on(function(_, client)
  if vim.tbl_contains(eslint_support_filetypes, vim.bo.filetype) then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
end)
-- yamlls cannot be disabled via previous method.
-- This is quite wired...
require("lspconfig").yamlls.setup({
  settings = {
    yaml = {
      format = { enable = false },
    },
  },
})
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {
          filetypes = eslint_support_filetypes,
        },
      },
      setup = {
        eslint = function()
          -- Auto-fix on save for specific filetypes
          vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = eslint_support_file_patterns,
            command = "LspEslintFixAll",
          })
        end,
      },
    },
  },
}
