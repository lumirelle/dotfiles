-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  -- -- MOTION --
  -- @see https://astronvim.github.io/astrocommunity/#mini-move
  { import = "astrocommunity.motion.mini-move" },
  -- @see https://astronvim.github.io/astrocommunity/#mini-surround
  { import = "astrocommunity.motion.mini-surround" },

  -- -- LANGUAGE PACK --
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.chezmoi" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.eslint" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.mdx" },
  { import = "astrocommunity.pack.nginx" },
  { import = "astrocommunity.pack.nushell" },
  { import = "astrocommunity.pack.oxlint" },
  { import = "astrocommunity.pack.pkl" },
  { import = "astrocommunity.pack.ps1" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.rust" },
  -- Disabled, it requires global installation of Go language.
  -- { import = "astrocommunity.pack.sql" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.vue" },
  { import = "astrocommunity.pack.xml" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.zig" },
  -- import/override with your plugins folder
}
