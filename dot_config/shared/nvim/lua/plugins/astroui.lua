-- AstroUI provides the basis for configuring the AstroNvim User Interface.
-- Configuration documentation can be found with `:h astroui`.

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    -- Use my vercel colorscheme.
    colorscheme = "vercel",
    icons = {
      -- Configure the loading of the lsp in the status line.
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",
    },
  },
}
