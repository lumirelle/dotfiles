# Merge helpers for the Windows Terminal `settings.json` scripts.
#
# `from json` reads and writes the file. Windows Terminal saves strict JSON (a
# save from the settings UI serialises the document and drops every comment), so
# the file is treated as JSON rather than JSON5; a hand-added comment makes the
# script fail loudly instead of being silently dropped.

# JSON arrays arrive from `from json` as either `list` or `table`.
def is-list [value: any] {
  let shape = ($value | describe)
  ($shape | str starts-with 'list') or ($shape | str starts-with 'table')
}

def sort-keys [value: any] {
  if (is-list $value) {
    return ($value | each {|item| sort-keys $item })
  }
  let shape = ($value | describe)
  if ($shape | str starts-with 'record') {
    mut out = {}
    for key in ($value | columns | sort) {
      $out = ($out | upsert $key (sort-keys ($value | get $key)))
    }
    return $out
  }
  $value
}

# Order-independent JSON text, used to compare two documents semantically.
def canonical [value: any] {
  let sorted = (sort-keys $value)
  $sorted | to json -r
}

# Stable identity of an array entry, or null when it has none.
def identity-of [entry: any] {
  if not ((($entry | describe) | str starts-with 'record')) {
    return null
  }
  for key in ['guid' 'id' 'name' 'type'] {
    let value = ($entry | get --optional $key)
    if ($value | describe) == 'string' {
      # Windows Terminal writes GUIDs with and without braces.
      return $'($key)=(($value | str replace --all --regex '[{}]' '' | str lowercase))'
    }
  }
  null
}

# Merges `wanted` into `current`: wanted wins on scalars, keys and entries that
# only the system knows about survive, arrays are unioned by entry identity.
def merge-value [current: any, wanted: any] {
  if (is-list $wanted) {
    mut merged = if (is-list $current) { $current } else { [] }
    for entry in $wanted {
      let id = (identity-of $entry)
      if $id == null {
        let rendered = (canonical $entry)
        let present = ($merged | any {|existing| (canonical $existing) == $rendered })
        if not $present {
          $merged = ($merged | append $entry)
        }
      } else {
        mut at = -1
        mut index = 0
        for existing in $merged {
          if (identity-of $existing) == $id {
            $at = $index
            break
          }
          $index += 1
        }
        if $at < 0 {
          $merged = ($merged | append $entry)
        } else {
          $merged = ($merged | update $at (merge-value ($merged | get $at) $entry))
        }
      }
    }
    return $merged
  }

  if (($wanted | describe) | str starts-with 'record') {
    mut merged = if ((($current | describe) | str starts-with 'record')) { $current } else { {} }
    for key in ($wanted | columns) {
      let base = ($merged | get --optional $key)
      $merged = ($merged | upsert $key (merge-value $base ($wanted | get $key)))
    }
    return $merged
  }

  $wanted
}

# Merges `desired` into the document at `target`, leaving everything the system
# added untouched, and writes it back as 2-space-indented JSON.
export def reconcile [target: string, desired: any] {
  let home = ($env.USERPROFILE? | default '')
  let display = if $home != '' and ($target | str starts-with $home) {
    '~' + ($target | str substring ($home | str length)..)
  } else {
    $target
  }

  let is_link = (try { ($target | path type) == 'symlink' } catch { false })

  # This repo used to manage settings.json as a symlink. Read it once (a
  # dangling symlink reads as nothing) and then stop sharing the file, because a
  # Terminal save would replace the symlink anyway.
  let current = if ($target | path exists) { open --raw $target } else { '' }
  if $is_link {
    rm --force $target
    print $'($display): replaced the managed symlink with a real file'
  }

  let parsed = if ($current | str trim) == '' { {} } else { $current | from json }
  let merged = (merge-value $parsed $desired)

  # A symlink was just removed, so an otherwise in-sync file still has to be
  # written: the point is that the entry is a real file from now on.
  if (not $is_link) and ((canonical $parsed) == (canonical $merged)) {
    print $'($display): already has the baseline, leaving the rest to Windows Terminal'
    return
  }

  # Merging is idempotent, so a second pass must change nothing: if it does,
  # some entry refused to be matched and writing would lose or duplicate it.
  if (canonical (merge-value $merged $desired)) != (canonical $merged) {
    error make { msg: $"refusing to write ($display): the merge did not settle" }
  }

  mkdir ($target | path dirname)
  (($merged | to json --indent 2) + "\n") | save --force $target

  let changed = (
    $desired
    | columns
    | where {|key|
        (canonical ($parsed | get --optional $key)) != (canonical ($merged | get --optional $key))
      }
  )
  let summary = if ($changed | is-empty) { 'the baseline' } else { $changed | str join ', ' }
  print $'($display): merged ($summary)'
}
