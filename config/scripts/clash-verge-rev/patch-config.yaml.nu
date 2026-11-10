#!/usr/bin/env nushell
# Clash Verge Rev - enforced subset of mihomo's `config.yaml`.
#
# This repo does not own `config.yaml` anymore: Clash Verge generates and
# rewrites it, so the file must never be written as a whole. Instead this script
# guarantees the keys in `desired` while leaving every other byte of the file
# (comments, order, quotes, long scalars) untouched.
#
# Targets, see https://www.clashverge.dev/uninstall.html
#   Windows  %APPDATA%/io.github.clash-verge-rev.clash-verge-rev/config.yaml
#   macOS    ~/Library/Application Support/io.github.clash-verge-rev.clash-verge-rev/config.yaml
#   Linux    ~/.local/share/io.github.clash-verge-rev.clash-verge-rev/config.yaml
#
# `nu patch-config.yaml.nu [file]` re-runs it by hand.

use ./patch-yaml.nu reconcile

const app = 'io.github.clash-verge-rev.clash-verge-rev'
const name = 'config.yaml'

# The only state this repo owns in `config.yaml`; edit it and re-apply.
const desired = {
  'allow-lan': true
  ipv6: true
  tun: { stack: 'system' }
}

# Clash Verge's working directory, see the docs linked above.
def working-dir [] {
  match $nu.os-info.name {
    'windows' => ($env.APPDATA? | default ($nu.home-dir | path join 'AppData' 'Roaming'))
    'macos' => ($nu.home-dir | path join 'Library' 'Application Support')
    _ => ($env.XDG_DATA_HOME? | default ($nu.home-dir | path join '.local' 'share'))
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
