-- Extend filetype snippets: let JS snippets be available in JSX, TS, and TSX.
---@type LazySpec
return {
  {
    "L3MON4D3/LuaSnip",
    opts = function(_, opts)
      -- include the default astronvim config that calls the setup call
      require("astronvim.plugins.configs.luasnip")(_, opts)

      local luasnip = require("luasnip")
      luasnip.filetype_extend("javascriptreact", { "javascript" })
      luasnip.filetype_extend("typescript", { "javascript" })
      luasnip.filetype_extend("typescriptreact", { "javascript" })
    end,
  },
}
