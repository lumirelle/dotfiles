-- Shadows the upstream Mason package `nginx-language-server`.
--
-- Upstream registry pins pkg:pypi/nginx-language-server@0.9.0, whose metadata says `requires-python <3.14` (it pins
-- pydantic v1), so `:MasonInstall` fails on Python 3.14+.
--
-- This entry points Mason at my self used fork (based on the maintained fork by @walber-vaz) instead, which declares
-- `requires-python >=3.10,<3.15` and dropped pydantic/crossplane entirely.
local version = "0.11.0"
local wheel = (
  "https://github.com/lumirelle/nginx-language-server/releases/download/"
  .. "v%s/nginx_language_server-%s-py3-none-any.whl"
):format(version, version)

local pip_install = " -m pip --disable-pip-version-check install --no-user --ignore-installed " .. wheel
local create_venv = "python -m venv venv"
---@type RegistryPackageSpec
return {
  name = "nginx-language-server",
  description = "Language server for nginx configuration files (maintained fork, Python 3.10-3.14).",
  homepage = "https://github.com/lumirelle/nginx-language-server",
  licenses = { "GPL-3.0-or-later" },
  languages = { "nginx" },
  categories = { "LSP" },
  source = {
    id = ("pkg:generic/nginx-language-server@%s"):format(version),
    build = {
      {
        target = "win",
        staged = false,
        run = table.concat({
          create_venv,
          ".\\venv\\Scripts\\python.exe" .. pip_install,
        }, "\n"),
      },
      {
        target = "unix",
        staged = false,
        run = table.concat({
          create_venv,
          "./venv/bin/python" .. pip_install,
        }, "\n"),
      },
    },
  },
  bin = {
    ["nginx-language-server"] = "pypi:nginx-language-server",
  },
  neovim = {
    lspconfig = "nginx_language_server",
  },
}
