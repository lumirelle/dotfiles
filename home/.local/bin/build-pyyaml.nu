#!/usr/bin/env nushell
# build-pyyaml - build a PyYAML wheel for the active interpreter into the local
# pip wheelhouse, for Pythons that have no prebuilt PyYAML wheel yet.
# The work lives in build-pyyaml.py so the sh and cmd front ends share it.

def main [] {
  let here = ($env.CURRENT_FILE | path dirname)

  # Match mason's own lookup order: python first on Windows, python3 elsewhere.
  let candidates = if $nu.os-info.name == 'windows' {
    ['python' 'python3']
  } else {
    ['python3' 'python']
  }
  let python = ($candidates | where {|candidate| (which $candidate | is-not-empty) } | get -i 0)

  if $python == null {
    print -e 'build-pyyaml: no Python interpreter found'
    exit 1
  }

  run-external $python ($here | path join 'build-pyyaml.py')
  exit $env.LAST_EXIT_CODE
}
