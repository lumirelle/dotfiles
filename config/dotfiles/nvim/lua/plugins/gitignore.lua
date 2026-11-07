---@type LazySpec
return {
  {
    "gitignore",
    virtual = true,
    cmd = { "Gitignore", "GitignoreUpdate" },
    config = function() require("user_plugins.gitignore").setup() end,
  },
}
