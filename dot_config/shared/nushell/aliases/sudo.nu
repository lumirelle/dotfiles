# Alias support for `sudo`, see https://github.com/nushell/nushell/issues/17652
export def --wrapped sudo [...args] {
  ^sudo ...(match $args {
    [$first, ..$rest] => {
      # Only apply to first command not starts with "-", "/", or contains "="
      if not (($first | str starts-with "-") or ($first | str starts-with "/") or ($first | str contains "=")) {
        if (which $first).0?.type == alias {
          # Handle alias
          let definition = which $first | get 0.definition
          let tokens = $definition | split row " "
          let full_path = which $tokens.0 | get 0.path
          [$full_path] | append ($tokens | skip 1) | append $rest
        } else {
          # Handle commands
          try {
            let path = (which $first).0.path
            if ($path | str length) > 0 { [$path] | append $rest } else { $args }
          } catch { $args }
        }
      } else { $args }
    },
    _ => $args
  })
}
