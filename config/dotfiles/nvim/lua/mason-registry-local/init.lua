-- Local Mason registry index: package name -> Lua module returning its spec.
-- Loaded via `registries = { "lua:mason-registry-local" }` (see lua/plugins/mason.lua).
-- Entries here shadow same-named packages from later registries (the official one).
--
-- NOTE: these data modules deliberately live at `lua/mason-registry-local/`, *not* under
-- `lua/plugins/`. lazy.nvim imports every module under `lua/plugins/` as a plugin spec, and
-- this module returns a name->module map, which lazy rejects with "Invalid plugin spec".
return {
  ["nginx-language-server"] = "mason-registry-local.nginx_language_server",
}
