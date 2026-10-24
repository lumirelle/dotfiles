-- Shadows the upstream Mason package `nginx-language-server`.
--
-- Upstream registry pins pkg:pypi/nginx-language-server@0.9.0, whose metadata says
-- `requires-python <3.14` (it pins pydantic v1), so `:MasonInstall` fails on Python 3.14+.
--
-- This entry points Mason at the maintained fork instead, which declares
-- `requires-python >=3.10,<3.15` and dropped pydantic/crossplane entirely.
local version = "0.10.0"
local wheel = (
  "https://github.com/walber-vaz/nginx-language-server/releases/download/"
  .. "v%s/nginx_language_server-%s-py3-none-any.whl"
):format(version, version)

---@type RegistryPackageSpec
return {
  name = "nginx-language-server",
  description = "Language server for nginx configuration files (maintained fork, Python 3.10-3.14).",
  homepage = "https://github.com/walber-vaz/nginx-language-server",
  licenses = { "GPL-3.0-or-later" },
  languages = { "nginx" },
  categories = { "LSP" },
  source = {
    id = ("pkg:generic/nginx-language-server@%s"):format(version),
    build = {
      -- The venv stores absolute paths, so it must be created in the final package dir.
      staged = false,
      run = table.concat({
        "$ErrorActionPreference = 'Stop'",
        "python -m venv venv",
        (
          "./venv/Scripts/python.exe -m pip --disable-pip-version-check install"
          .. " --no-user --ignore-installed "
          .. wheel
        ),
      }, "\n"),
    },
  },
  bin = {
    ["nginx-language-server"] = "venv/Scripts/nginx-language-server.exe",
  },
  neovim = {
    lspconfig = "nginx_language_server",
  },
}
