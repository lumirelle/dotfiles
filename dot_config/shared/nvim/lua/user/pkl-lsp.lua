---@type LazySpec
return {
  {
    "apple/pkl-neovim",
    init = function()
      vim.g.pkl_neovim = {
        start_command = { "java", "-XX:+UseCompactObjectHeaders", "-jar", vim.fn.expand("~/.local/bin/pkl-lsp.jar") },
        pkl_cli_path = "pkl",
      }
    end,
  },
}
