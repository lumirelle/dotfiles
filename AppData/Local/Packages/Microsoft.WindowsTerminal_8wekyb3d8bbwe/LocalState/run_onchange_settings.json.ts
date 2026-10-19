#!/usr/bin/env bun
/**
 * Windows Terminal - keep this repo's settings, keep whatever the system adds.
 *
 * `settings.json` is owned by both sides. Windows Terminal rewrites it: dynamic
 * profile generators persist newly discovered shells (WSL distros, SSH, Azure,
 * Nushell, ...), and a save from the settings UI serialises the whole document,
 * which also drops every comment in the file. So instead of managing the file -
 * or symlinking it, which a Terminal save silently replaces with a real file -
 * this `run_onchange_` target merges the baseline below into whatever is on
 * disk: keys and array entries this repo defines are added or updated, and
 * everything else that the system added survives untouched.
 *
 * Array entries are matched on `guid`, `id`, `name` or `type` (in that order,
 * GUIDs compared without braces). That is what makes `profiles.list`, `themes`,
 * `schemes`, `keybindings` and `newTabMenu` grow instead of being replaced.
 *
 * `schemes` and `themes` come from
 * https://github.com/lumirelle/vercel-windows-terminal (`dark.jsonc`,
 * `light.jsonc` and the matching `*Theme.jsonc`), so check that repo before
 * editing colours here.
 *
 * Targets
 *   %LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
 *
 * The stable and the Preview package each have their own copy of this script,
 * with their own baseline, so the two are free to diverge: only this package's
 * `settings.json` is ever touched.
 *
 * `bun run_onchange_settings.json.ts [settings.json ...]` re-runs it by hand.
 */

import { existsSync, lstatSync, mkdirSync, readFileSync, unlinkSync, writeFileSync } from 'node:fs'
import { dirname, join } from 'node:path'
import process from 'node:process'

declare const Bun: { JSON5: { parse: (text: string) => unknown } }

/**
 * The settings this repo owns, as verbatim `settings.json` text (comments and
 * all, which is why it is parsed with `Bun.JSON5`). Keep it free of backticks,
 * of `${` and of non-ASCII characters: Bun hands non-ASCII characters back out
 * of `String.raw` re-encoded as text (`\u{1f427}` for astral ones), which JSON5
 * then rejects, so icons stay escaped the way Windows Terminal writes them.
 *
 * Editing it - like editing any other line here - is what makes chezmoi re-run
 * this script.
 */
const BASELINE = String.raw`{
  "$help": "https://aka.ms/terminal-documentation",
  "$schema": "https://aka.ms/terminal-profiles-schema",
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
        "face": "'Aporetic Serif Mono', 'Symbols Nerd Font Mono', 'Zhuque Fangsong A1050'"
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
`

const PACKAGE = 'Microsoft.WindowsTerminal_8wekyb3d8bbwe'

const NAME = 'settings.json'
const DESIRED = Bun.JSON5.parse(BASELINE) as Json

type Json = null | boolean | number | string | Json[] | { [key: string]: Json }

/** Entry fields that identify an array element, most specific first. */
const IDENTITY_KEYS = ['guid', 'id', 'name', 'type'] as const

/** Stable identity of an array entry, or `undefined` when it has none. */
function identityOf(entry: Json): string | undefined {
  if (entry === null || typeof entry !== 'object' || Array.isArray(entry)) {
    return undefined
  }
  const record = entry as Record<string, Json>
  for (const key of IDENTITY_KEYS) {
    const value = record[key]
    if (typeof value === 'string') {
      // Windows Terminal writes GUIDs with and without braces.
      return `${key}=${value.replaceAll(/[{}]/g, '').toLowerCase()}`
    }
  }
  return undefined
}

/** Order-independent JSON text, used to compare two documents semantically. */
function canonical(value: Json | undefined): string {
  if (Array.isArray(value)) {
    return `[${value.map(item => canonical(item)).join(',')}]`
  }
  if (value !== null && typeof value === 'object') {
    const entries = Object.entries(value).sort(([a], [b]) => (a < b ? -1 : 1))
    return `{${entries.map(([key, item]) => `${JSON.stringify(key)}:${canonical(item)}`).join(',')}}`
  }
  return JSON.stringify(value ?? null) as string
}

/**
 * Merges `wanted` into `current`: wanted wins on scalars, keys and entries that
 * only the system knows about survive, arrays are unioned by entry identity.
 */
function merge(current: Json | undefined, wanted: Json): Json {
  if (Array.isArray(wanted)) {
    const merged: Json[] = Array.isArray(current) ? [...current] : []
    for (const entry of wanted) {
      const identity = identityOf(entry)
      if (identity === undefined) {
        if (!merged.some(existing => canonical(existing) === canonical(entry))) {
          merged.push(entry)
        }
        continue
      }
      const at = merged.findIndex(existing => identityOf(existing) === identity)
      if (at < 0) {
        merged.push(entry)
      }
      else {
        merged[at] = merge(merged[at], entry)
      }
    }
    return merged
  }
  if (wanted !== null && typeof wanted === 'object') {
    const merged: Record<string, Json> = current !== null && typeof current === 'object' && !Array.isArray(current)
      ? { ...(current as Record<string, Json>) }
      : {}
    for (const [key, value] of Object.entries(wanted)) {
      merged[key] = merge(merged[key], value)
    }
    return merged
  }
  return wanted
}

function defaultTarget(): string {
  const local = process.env.LOCALAPPDATA
  if (local === undefined) {
    throw new Error('LOCALAPPDATA is not set')
  }
  return join(local, 'Packages', PACKAGE, 'LocalState', NAME)
}

function reconcile(target: string): void {
  const home = process.env.USERPROFILE ?? ''
  const display = home !== '' && target.startsWith(home) ? `~${target.slice(home.length)}` : target

  let isLink = false
  try {
    isLink = lstatSync(target).isSymbolicLink()
  }
  catch {
    // Not there at all: a fresh machine, or a package Windows Terminal has not run yet.
  }

  // This repo used to manage settings.json as a symlink. Read it once (a dangling
  // symlink reads as nothing) and then stop sharing the file, because a Terminal
  // save would replace the symlink anyway.
  const current = existsSync(target) ? readFileSync(target, 'utf8') : ''
  if (isLink) {
    unlinkSync(target)
    console.log(`${display}: replaced the managed symlink with a real file`)
  }

  const parsed = (current.trim() === '' ? {} : Bun.JSON5.parse(current)) as Json
  const merged = merge(parsed, DESIRED)

  // A symlink was just removed, so an otherwise in-sync file still has to be
  // written: the point is that the entry is a real file from now on.
  if (!isLink && canonical(parsed) === canonical(merged)) {
    console.log(`${display}: already has the baseline, leaving the rest to Windows Terminal`)
    return
  }

  // Merging is idempotent, so a second pass must change nothing: if it does,
  // some entry refused to be matched and writing would lose or duplicate it.
  if (canonical(merge(merged, DESIRED)) !== canonical(merged)) {
    throw new Error(`refusing to write ${display}: the merge did not settle`)
  }

  mkdirSync(dirname(target), { recursive: true })
  writeFileSync(target, `${JSON.stringify(merged, null, 2)}\n`)

  const changed = Object.keys(DESIRED as Record<string, Json>)
    .filter(key => canonical((parsed as Record<string, Json>)[key]) !== canonical((merged as Record<string, Json>)[key]))
  console.log(`${display}: merged ${changed.length > 0 ? changed.join(', ') : 'the baseline'}`)
}

try {
  const targets = process.argv.slice(2)
  for (const target of targets.length > 0 ? targets : [defaultTarget()]) {
    reconcile(target)
  }
}
catch (error) {
  console.error(`[${NAME}] ${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
}
