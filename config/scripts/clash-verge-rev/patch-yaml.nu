# Minimal comment- and format-preserving YAML editor shared by the Clash Verge
# patch scripts.
#
# `from yaml` is used to read the file and to verify the result, never to
# re-serialize it: re-serializing drops comments, re-indents block sequences and
# re-wraps long scalars, which would churn the whole file.

def indent-width [line: string] {
  ($line | str length) - ($line | str trim --left | str length)
}

# Index of the first line that closes the block mapping opened at `from`.
def block-end [lines: list, from: int] {
  let width = (indent-width ($lines | get $from))
  let total = ($lines | length)
  mut i = ($from + 1)
  while $i < $total {
    let text = (($lines | get $i) | str trim)
    if $text == '' or ($text | str starts-with '#') {
      $i += 1
      continue
    }
    if (indent-width ($lines | get $i)) <= $width {
      return $i
    }
    $i += 1
  }
  $total
}

# Whether `line` declares `key` at exactly `indent`.
def is-key-at [line: string, key: string, indent: int] {
  if (indent-width $line) != $indent {
    return false
  }
  let found = ($line | parse --regex '^\s*(?<key>[^#\s][^:]*):(?:\s|$)')
  if ($found | is-empty) {
    return false
  }
  (($found | first | get key) | str trim) == $key
}

def first-indent [lines: list, start: int, end: int, fallback: int] {
  mut i = $start
  while $i < $end {
    let text = (($lines | get $i) | str trim)
    if $text != '' and not ($text | str starts-with '#') {
      return (indent-width ($lines | get $i))
    }
    $i += 1
  }
  $fallback
}

# Renders one scalar the way YAML would read it back unchanged.
def scalar [value: any] {
  if ($value | describe) == 'string' {
    let reserved = ($value =~ '(?i)^(?:[yn~]|yes|no|true|false|on|off|null)$')
    let plain = ($value =~ '^\w[\w ./@+-]*$')
    if $plain and not $reserved {
      return $value
    }
    return ($value | to json -r)
  }
  $value | to json -r
}

# Sets the leaf `path` to `value`, creating any missing block mapping on the way.
def set-path [lines: list, path: list, value: any, step: int] {
  mut lines = $lines
  mut start = 0
  mut end = ($lines | length)
  mut indent = 0
  let depth_count = ($path | length)

  for depth in 0..($depth_count - 1) {
    let key = ($path | get $depth)
    let leaf = ($depth == ($depth_count - 1))

    mut index = -1
    mut i = $start
    while $i < $end {
      if (is-key-at ($lines | get $i) $key $indent) {
        $index = $i
        break
      }
      $i += 1
    }

    let pad = ('' | fill --width $indent)

    if $index < 0 {
      let inserted = if $leaf {
        $'($pad)($key): (scalar $value)'
      } else {
        $'($pad)($key):'
      }
      $lines = ($lines | insert $end $inserted)
      if $leaf {
        return $lines
      }
      $start = ($end + 1)
      $end = $start
      $indent += $step
      continue
    }

    if $leaf {
      $lines = ($lines | update $index $'($pad)($key): (scalar $value)')
      return $lines
    }

    let child_start = ($index + 1)
    let child_end = (block-end $lines $index)
    if $child_start == $child_end {
      # `key: null` / `key: {}` -> a real block mapping, so children can follow.
      $lines = ($lines | update $index $'($pad)($key):')
      $start = $child_start
      $end = $child_end
      $indent += $step
    } else {
      $start = $child_start
      $end = $child_end
      $indent = (first-indent $lines $child_start $child_end ($indent + $step))
    }
  }
  $lines
}

# Flattens nested records into `{ path: [...], value: ... }` leaves.
def flatten-paths [object: record, prefix: list = []] {
  mut out = []
  for key in ($object | columns) {
    let item = ($object | get $key)
    let path = ($prefix | append $key)
    if (($item | describe) | str starts-with 'record') {
      $out = ($out ++ (flatten-paths $item $path))
    } else {
      $out = ($out ++ [{ path: $path, value: $item }])
    }
  }
  $out
}

def get-in [value: any, path: list] {
  mut current = $value
  for key in $path {
    if not ((($current | describe) | str starts-with 'record')) {
      return null
    }
    $current = ($current | get --optional $key)
  }
  $current
}

def all-set [parsed: any, wanted: list] {
  for entry in $wanted {
    if (get-in $parsed $entry.path) != $entry.value {
      return false
    }
  }
  true
}

# Ensures every leaf of `desired` is present in the YAML file at `target`,
# leaving every other byte (comments, order, quotes, long scalars) untouched.
export def reconcile [target: string, desired: record] {
  let wanted = (flatten-paths $desired)
  let home = ($nu.home-dir | into string)
  let display = if ($target | str starts-with $home) {
    '~' + ($target | str substring ($home | str length)..)
  } else {
    $target
  }
  let original = if ($target | path exists) { open --raw $target } else { '' }
  let newline = if ($original | str contains "\r\n") { "\r\n" } else { "\n" }
  let keys = ($wanted | each {|entry| $entry.path | str join '.' } | str join ', ')

  if $original != '' {
    let parsed = (try { $original | from yaml } catch { null })
    if $parsed != null and (all-set $parsed $wanted) {
      print $'($display): all of ($keys) already set, leaving it to Clash Verge'
      return
    }
  }

  mut lines = if $original == '' {
    []
  } else {
    $original | str replace --all "\r\n" "\n" | split row "\n"
  }
  if ($lines | length) > 0 and ($lines | last) == '' {
    # Drop the artifact of the trailing newline so appended keys land last.
    $lines = ($lines | drop 1)
  }

  let step = (
    $lines
    | where {|line| ($line | str trim) != '' }
    | each {|line| indent-width $line }
    | where {|width| $width > 0 }
    | reduce --fold 2 {|width, acc| [$width $acc] | math min }
  )

  for entry in $wanted {
    $lines = (set-path $lines $entry.path $entry.value $step)
  }

  let updated = (($lines | str join $newline) + "\n")

  let check = (try { $updated | from yaml } catch { null })
  if $check == null {
    error make { msg: $"refusing to write ($display): the result is not valid YAML" }
  }
  let failed = ($wanted | where {|entry| (get-in $check $entry.path) != $entry.value })
  if not ($failed | is-empty) {
    let names = ($failed | each {|entry| $entry.path | str join '.' } | str join ', ')
    error make { msg: $"refusing to write ($display): ($names) did not apply" }
  }

  mkdir ($target | path dirname)
  $updated | save --force $target
  let action = if $original == '' { 'created' } else { 'updated' }
  print $'($action) ($display) with ($keys)'
}
