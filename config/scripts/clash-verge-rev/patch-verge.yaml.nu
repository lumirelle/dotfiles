#!/usr/bin/env nushell
# Clash Verge Rev - enforced subset of `verge.yaml` (the app's own settings).
#
# This repo does not own `verge.yaml` anymore: Clash Verge generates and rewrites
# it, so the file must never be written as a whole. Instead this script
# guarantees the keys in `desired` while leaving every other byte of the file
# (comments, order, quotes, siblings of touched keys) untouched.
#
# Targets, see https://www.clashverge.dev/uninstall.html
#   Windows  %APPDATA%/io.github.clash-verge-rev.clash-verge-rev/verge.yaml
#   macOS    ~/Library/Application Support/io.github.clash-verge-rev.clash-verge-rev/verge.yaml
#   Linux    ~/.config/io.github.clash-verge-rev.clash-verge-rev/verge.yaml
#
# Note that on Linux the app splits its directories: `verge.yaml` lives in the
# config directory while `config.yaml` and `dns_config.yaml` live in the data
# directory.
#
# `nu patch-verge.yaml.nu [file]` re-runs it by hand.

use ./patch-yaml.nu reconcile

const app = 'io.github.clash-verge-rev.clash-verge-rev'
const name = 'verge.yaml'

# The only state this repo owns in `verge.yaml`; edit it and re-apply.
const desired = {
  theme_mode: 'system'
  env_type: 'nushell'
  enable_auto_launch: true
  enable_silent_start: true
  theme_setting: { font_family: "'Geist', 'Resource Han Rounded CN'" }
}

# Clash Verge's config directory, see the docs linked above.
def working-dir [] {
  match $nu.os-info.name {
    'windows' => ($env.APPDATA? | default ($nu.home-dir | path join 'AppData' 'Roaming'))
    'macos' => ($nu.home-dir | path join 'Library' 'Application Support')
    _ => ($env.XDG_CONFIG_HOME? | default ($nu.home-dir | path join '.config'))
  }
}

def main [target?: string] {
  let file = ($target | default ((working-dir) | path join $app $name) | into string)
  try {
    reconcile $file $desired
  } catch {|err|
    print -e $'[($name)] ($err.msg)'
    exit 1
  }
}
