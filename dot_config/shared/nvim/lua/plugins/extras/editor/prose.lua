-- Add read time & word count for markdown files
return {
  { "skwee357/nvim-prose", opts = { wpm = 200 } },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_y, {
        function()
          local ok, prose = pcall(require, "nvim-prose")
          if ok and prose.is_available() then
            return prose.reading_time() .. " " .. prose.word_count()
          end
          return ""
        end,
        cond = function()
          return vim.bo.filetype == "markdown"
        end,
      })
    end,
  },
}
