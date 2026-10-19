#!/usr/bin/env bun
/**
 * Clash Verge Rev - enforced subset of `verge.yaml` (the app's own settings).
 *
 * This repo does not own `verge.yaml` anymore: Clash Verge generates and
 * rewrites it, so chezmoi must never write the whole file. Instead this script
 * is a `run_onchange_` target, i.e. chezmoi runs it only when the contents of
 * this file change, and it guarantees the keys in `DESIRED` while leaving every
 * other byte of the file (comments, order, quotes, siblings of touched keys)
 * untouched.
 *
 * Targets, see https://www.clashverge.dev/uninstall.html
 *   Windows  %APPDATA%/io.github.clash-verge-rev.clash-verge-rev/verge.yaml
 *   macOS    ~/Library/Application Support/io.github.clash-verge-rev.clash-verge-rev/verge.yaml
 *   Linux    ~/.config/io.github.clash-verge-rev.clash-verge-rev/verge.yaml
 *
 * Note that on Linux the app splits its directories: `verge.yaml` lives in the
 * config directory while `config.yaml` and `dns_config.yaml` live in the data
 * directory.
 *
 * `bun run_onchange_verge.yaml.ts [file]` re-runs it by hand.
 */

import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs'
import { homedir } from 'node:os'
import { dirname, join } from 'node:path'
import process from 'node:process'

declare const Bun: { YAML: { parse: (text: string) => unknown } }

/** The only state this repo owns in `verge.yaml`; edit it and re-apply. */
const DESIRED: Record<string, unknown> = {
  theme_mode: 'system',
  env_type: 'nushell',
  enable_auto_launch: true,
  enable_silent_start: true,
  theme_setting: { font_family: 'Aporetic Serif' },
}

const APP = 'io.github.clash-verge-rev.clash-verge-rev'
const NAME = 'verge.yaml'

/** Clash Verge's config directory, see the docs linked above. */
function workingDir(): string {
  if (process.platform === 'win32') {
    return process.env.APPDATA ?? join(homedir(), 'AppData', 'Roaming')
  }
  if (process.platform === 'darwin') {
    return join(homedir(), 'Library', 'Application Support')
  }
  return process.env.XDG_CONFIG_HOME ?? join(homedir(), '.config')
}

// ---------------------------------------------------------------------------
// Minimal comment- and format-preserving YAML editor.
//
// `Bun.YAML` is used to read the file and to verify the result, never to
// re-serialize it: `Bun.YAML.stringify` drops comments, re-indents block
// sequences and re-wraps long scalars, which would churn the whole file.
// ---------------------------------------------------------------------------

const indentWidth = (line: string): number => line.length - line.trimStart().length

/** Index of the first line that closes the block mapping opened at `from`. */
function blockEnd(lines: string[], from: number): number {
  const width = indentWidth(lines[from])
  for (let i = from + 1; i < lines.length; i++) {
    const text = lines[i].trim()
    if (text === '' || text.startsWith('#')) {
      continue
    }
    if (indentWidth(lines[i]) <= width) {
      return i
    }
  }
  return lines.length
}

/** Whether `line` declares `key` at exactly `indent`. */
function isKeyAt(line: string, key: string, indent: number): boolean {
  if (indentWidth(line) !== indent) {
    return false
  }
  const match = /^\s*([^#\s][^:]*):(?:\s|$)/.exec(line)
  return match?.[1].trim() === key
}

function firstIndent(lines: string[], start: number, end: number, fallback: number): number {
  for (let i = start; i < end; i++) {
    const text = lines[i].trim()
    if (text !== '' && !text.startsWith('#')) {
      return indentWidth(lines[i])
    }
  }
  return fallback
}

/** Renders one scalar the way YAML would read it back unchanged. */
function scalar(value: unknown): string {
  if (typeof value !== 'string') {
    return String(value)
  }
  const reserved = /^(?:[yn~]|yes|no|true|false|on|off|null)$/i
  const plain = /^\w[\w ./@+-]*$/.test(value) && !reserved.test(value)
  return plain ? value : JSON.stringify(value)
}

/** Sets the leaf `path` to `value`, creating any missing block mapping on the way. */
function setPath(lines: string[], path: string[], value: unknown, step: number): void {
  let start = 0
  let end = lines.length
  let indent = 0
  for (let depth = 0; depth < path.length; depth++) {
    const key = path[depth]
    const leaf = depth === path.length - 1
    let index = -1
    for (let i = start; i < end; i++) {
      if (isKeyAt(lines[i], key, indent)) {
        index = i
        break
      }
    }
    const pad = ' '.repeat(indent)
    if (index < 0) {
      lines.splice(end, 0, leaf ? `${pad}${key}: ${scalar(value)}` : `${pad}${key}:`)
      if (leaf) {
        return
      }
      start = end + 1
      end = start
      indent += step
      continue
    }
    if (leaf) {
      lines[index] = `${pad}${key}: ${scalar(value)}`
      return
    }
    const childStart = index + 1
    const childEnd = blockEnd(lines, index)
    if (childStart === childEnd) {
      // `key: null` / `key: {}` -> a real block mapping, so children can follow.
      lines[index] = `${pad}${key}:`
      start = childStart
      end = childEnd
      indent += step
    }
    else {
      start = childStart
      end = childEnd
      indent = firstIndent(lines, childStart, childEnd, indent + step)
    }
  }
}

function flatten(object: Record<string, unknown>, prefix: string[] = []): [string[], unknown][] {
  return Object.entries(object).flatMap(([key, value]) =>
    value !== null && typeof value === 'object' && !Array.isArray(value)
      ? flatten(value as Record<string, unknown>, [...prefix, key])
      : [[[...prefix, key], value] as [string[], unknown]],
  )
}

function getIn(object: unknown, path: string[]): unknown {
  return path.reduce<unknown>((current, key) => {
    if (current === null || typeof current !== 'object') {
      return undefined
    }
    return (current as Record<string, unknown>)[key]
  }, object)
}

function reconcile(target: string, desired: Record<string, unknown>): void {
  const wanted = flatten(desired)
  const display = target.startsWith(homedir()) ? `~${target.slice(homedir().length)}` : target
  const original = existsSync(target) ? readFileSync(target, 'utf8') : ''
  const newline = original.includes('\r\n') ? '\r\n' : '\n'
  const keys = wanted.map(([path]) => path.join('.')).join(', ')

  if (original !== '') {
    try {
      const parsed = Bun.YAML.parse(original)
      if (wanted.every(([path, value]) => getIn(parsed, path) === value)) {
        console.log(`${display}: all of ${keys} already set, leaving it to Clash Verge`)
        return
      }
    }
    catch {
      // Not parsable: fall through and patch it line by line anyway.
    }
  }

  const lines = original === '' ? [] : original.split(/\r?\n/)
  if (lines.at(-1) === '') {
    // Drop the artifact of the trailing newline so appended keys land last.
    lines.pop()
  }
  const step = lines
    .filter(line => line.trim() !== '')
    .map(indentWidth)
    .filter(width => width > 0)
    .reduce((smallest, width) => Math.min(smallest, width), 2)
  for (const [path, value] of wanted) {
    setPath(lines, path, value, step)
  }

  const updated = `${lines.join(newline)}\n`

  const check = Bun.YAML.parse(updated)
  const failed = wanted.filter(([path, value]) => getIn(check, path) !== value)
  if (failed.length > 0) {
    throw new Error(
      `refusing to write ${display}: ${failed.map(([path]) => path.join('.')).join(', ')} did not apply`,
    )
  }

  mkdirSync(dirname(target), { recursive: true })
  writeFileSync(target, updated)
  console.log(`${original === '' ? 'created' : 'updated'} ${display} with ${keys}`)
}

try {
  reconcile(process.argv[2] ?? join(workingDir(), APP, NAME), DESIRED)
}
catch (error) {
  console.error(`[${NAME}] ${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
}
