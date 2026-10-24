-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    options = {
      opt = {
        -- Use Nushell as the default shell.
        -- nu is not POSIX: no `2>&1`, no `tee`, and no quote-stripping,
        -- so the shell* options must be overridden alongside `shell`.
        shell = "nu",
        shellcmdflag = "--stdin --no-newline -c",
        shellxescape = "",
        shellxquote = "",
        shellquote = "",
        shellredir = "out+err> %s",
        shellpipe = "| complete | update stderr { ansi strip } | tee { get stderr | save --force --raw %s } | into record",

        -- Soft-wrap long lines for every filetype, breaking at word boundaries
        -- and keeping the continuation lines indented. `smoothscroll` makes the
        -- view scroll by screen lines instead of jumping over wrapped lines.
        wrap = true,
        linebreak = true,
        breakindent = true,
        smoothscroll = true,
      },
    },
  },
}
