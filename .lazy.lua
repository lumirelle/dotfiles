vim.g.autoformat = false

vim.filetype.add({
  pattern = {
    [".*%.json"] = "jsonc",
  },
})

return {}
