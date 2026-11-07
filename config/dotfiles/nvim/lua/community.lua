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

  -- -- GIT --
  -- @see https://astronvim.github.io/astrocommunity/#diffview-plus-nvim
  { import = "astrocommunity.git.diffview-plus-nvim" },

  -- -- LANGUAGE PACK --
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.eslint" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.hurl" },
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
  { import = "astrocommunity.pack.sql" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.vue" },
  { import = "astrocommunity.pack.xml" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.zig" },
  -- import/override with your plugins folder
}
