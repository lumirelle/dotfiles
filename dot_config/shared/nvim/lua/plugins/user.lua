-- User configuration entry point.
-- Each file under `lua/user/` returns a LazySpec and is imported here.
-- Add new customizations as separate files in `lua/user/` (e.g. `lsp.lua`,
-- `mappings.lua`) and they will be picked up automatically.

---@type LazySpec
return {
  { import = "user" },
}
