#!/usr/bin/env nushell
# set-editor-visual - make nvim the editor picked by tools that honour
# `EDITOR`/`VISUAL`.

def main [] {
  ^setx EDITOR nvim
  ^setx VISUAL nvim
}
