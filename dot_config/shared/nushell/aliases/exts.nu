# TODO: Sorting order support...
export def rank-exts [] {
  let files = ls ...(glob **/* --exclude [**/node_modules/**, **/.git/**] --no-dir)
  let file_basenames = $files | get name | path basename
  let file_extnames = $file_basenames | each {| it | if ($it | str index-of . --end) > 0 { $it | str substring ($it | str index-of . --end)..-1 } else { $it | str substring 0..-1 } }
  $file_extnames | group-by --to-table | each {| it | { ext: $it.group, count: ($it.items | length) } } | sort-by count -r
}
