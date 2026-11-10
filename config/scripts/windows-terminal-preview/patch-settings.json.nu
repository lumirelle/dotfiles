#!/usr/bin/env nushell
# Windows Terminal - keep this repo's settings, keep whatever the system adds.
#
# `settings.json` is owned by both sides. Windows Terminal rewrites it: dynamic
# profile generators persist newly discovered shells (WSL distros, SSH, Azure,
# Nushell, ...), and a save from the settings UI serialises the whole document,
# which also drops every comment in the file. So instead of managing the file -
# or symlinking it, which a Terminal save silently replaces with a real file -
# this script merges the baseline below into whatever is on disk: keys and array
# entries this repo defines are added or updated, and everything else that the
# system added survives untouched.
#
# Array entries are matched on `guid`, `id`, `name` or `type` (in that order,
# GUIDs compared without braces). That is what makes `profiles.list`, `themes`,
# `schemes`, `keybindings` and `newTabMenu` grow instead of being replaced.
#
# `schemes` and `themes` come from
# https://github.com/lumirelle/vercel-windows-terminal (`dark.jsonc`,
# `light.jsonc` and the matching `*Theme.jsonc`), so check that repo before
# editing colours here.
#
# Targets
#   %LOCALAPPDATA%\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json
#
# The stable and the Preview package each have their own copy of this script,
# with their own baseline, so the two are free to diverge: only this package's
# `settings.json` is ever touched.
#
# `nu patch-settings.json.nu [settings.json ...]` re-runs it by hand.

use ../patch-json.nu reconcile

const package = 'Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe'
const name = 'settings.json'

# The settings this repo owns, as verbatim `settings.json` text. Keep it strict
# JSON: nushell has no JSON5 parser, and Windows Terminal drops comments when it
# saves anyway.
const baseline_text = r#'{
  "$help": "https://aka.ms/terminal-documentation",
  "$schema": "https://aka.ms/terminal-profiles-schema-preview",
  "actions": [],
  "centerOnLaunch": true,
  "copyFormatting": "none",
  "copyOnSelect": true,
  "defaultProfile": "{47302f9c-1ac4-566c-aa3e-8cf29889d6ab}",
  "keybindings": [
    {
      "id": "Terminal.DuplicatePaneAuto",
      "keys": "alt+shift+d"
    }
  ],
  "newTabMenu": [
    {
      "type": "remainingProfiles"
    },
    {
      "allowEmpty": false,
      "entries": [
        {
          "commandline": null,
          "name": null,
          "source": "Windows.Terminal.SSH",
          "type": "matchProfiles"
        }
      ],
      "icon": "\ue969",
      "inline": "auto",
      "name": "SSH",
      "type": "folder"
    }
  ],
  "profiles": {
    "defaults": {
      "backgroundImage": "desktopWallpaper",
      "backgroundImageOpacity": 0.24,
      "colorScheme": "Vercel Dark",
      "font": {
        "face": "'GeistMono Nerd Font', 'Maple Mono CN'"
      },
      "intenseTextStyle": "all",
      "opacity": 100,
      "rightClickContextMenu": true,
      "startingDirectory": "%USERPROFILE%",
      "useAcrylic": true
    },
    "list": [
      {
        "commandline": "\"%SystemRoot%\\System32\\WindowsPowerShell\\v1.0\\powershell.exe\" -nologo",
        "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
        "hidden": false,
        "name": "Windows PowerShell"
      },
      {
        "commandline": "%SystemRoot%\\System32\\cmd.exe",
        "guid": "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}",
        "hidden": false,
        "name": "Command Prompt"
      },
      {
        "commandline": "wsl --cd ~",
        "guid": "{b02bd5d0-487c-4679-a940-be8e7f33dec1}",
        "hidden": false,
        "icon": "\ud83d\udc27",
        "name": "Windows Subsystem for Linux"
      },
      {
        "commandline": "nu",
        "guid": "{47302f9c-1ac4-566c-aa3e-8cf29889d6ab}",
        "hidden": false,
        "name": "Nushell",
        "source": "nu"
      }
    ]
  },
  "schemes": [
    {
      "name": "Vercel Dark",
      "cursorColor": "#EDEDED",
      "selectionBackground": "#1A1A1A",
      "background": "#000000",
      "foreground": "#EDEDED",
      "black": "#A1A1A1",
      "red": "#FF6166",
      "green": "#62C073",
      "yellow": "#F2A20D",
      "blue": "#52A8FF",
      "purple": "#BF7AF0",
      "cyan": "#0AC7B4",
      "white": "#EDEDED",
      "brightBlack": "#A1A1A1",
      "brightRed": "#FF6166",
      "brightGreen": "#62C073",
      "brightYellow": "#F2A20D",
      "brightBlue": "#52A8FF",
      "brightPurple": "#BF7AF0",
      "brightCyan": "#0AC7B4",
      "brightWhite": "#EDEDED"
    },
    {
      "name": "Vercel Light",
      "cursorColor": "#171717",
      "selectionBackground": "#F2F2F2",
      "background": "#FAFAFA",
      "foreground": "#171717",
      "black": "#171717",
      "red": "#CB2A2F",
      "green": "#297A3A",
      "yellow": "#A35200",
      "blue": "#0068D6",
      "purple": "#7820BC",
      "cyan": "#067A6E",
      "white": "#4D4D4D",
      "brightBlack": "#171717",
      "brightRed": "#CB2A2F",
      "brightGreen": "#297A3A",
      "brightYellow": "#A35200",
      "brightBlue": "#0068D6",
      "brightPurple": "#7820BC",
      "brightCyan": "#067A6E",
      "brightWhite": "#4D4D4D"
    }
  ],
  "theme": "Vercel Dark",
  "themes": [
    {
      "name": "Vercel Dark",
      "tab": {
        "background": "#000000FF",
        "showCloseButton": "always",
        "unfocusedBackground": null
      },
      "tabRow": {
        "background": "#000000FF",
        "unfocusedBackground": "#000000FF"
      },
      "window": {
        "applicationTheme": "dark"
      }
    },
    {
      "name": "Vercel Light",
      "tab": {
        "background": "#FAFAFAFF",
        "showCloseButton": "always",
        "unfocusedBackground": null
      },
      "tabRow": {
        "background": "#FAFAFAFF",
        "unfocusedBackground": "#FAFAFAFF"
      },
      "window": {
        "applicationTheme": "light"
      }
    }
  ]
}
'#

def default-target [] {
  let local = ($env.LOCALAPPDATA? | default '')
  if $local == '' {
    error make { msg: 'LOCALAPPDATA is not set' }
  }
  $local | path join 'Packages' $package 'LocalState' $name
}

def main [...targets: string] {
  let desired = ($baseline_text | from json)
  let files = if ($targets | is-empty) { [ (default-target) ] } else { $targets }
  for file in $files {
    try {
      reconcile ($file | into string) $desired
    } catch {|err|
      print -e $'[($name)] ($err.msg)'
      exit 1
    }
  }
}
