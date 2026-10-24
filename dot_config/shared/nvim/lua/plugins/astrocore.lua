-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`.

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    options = {
      -- VIM OPTIONS
      opt = {
        -- Soft-wrap long lines for every filetype, breaking at word boundaries and keeping the continuation lines
        -- indented. `smoothscroll` makes the view scroll by screen lines instead of jumping over wrapped lines.
        wrap = true,
        linebreak = true,
        breakindent = true,
        smoothscroll = true,
        -- Use Nushell as the default shell. Referenced https://github.com/nushell/integrations/blob/main/nvim/init.lua.
        shell = "nu",
        shellcmdflag = "--stdin --no-newline -c",
        shellxescape = "",
        shellxquote = "",
        shellquote = "",
        shellredir = "out+err> %s",
        shellpipe = "| complete | update stderr { ansi strip } | tee { get stderr | save --force --raw %s } | into record",
      },
    },
  },
}
