---@type LazySpec
return {
  {
    "apple/pkl-neovim",
    config = function()
      vim.g.pkl_neovim = {
        start_command = {
          "java",
          "-XX:+UseCompactObjectHeaders",
          "-jar",
          vim.fn.expand "~/.local/bin/pkl-lsp.jar",
        },
        pkl_cli_path = vim.fn.exepath "pkl",
      }
    end,
  },
}
