# Open WSL in the Linux user's home directory instead of translating the
# current Windows working directory (C:\Users\me -> /mnt/c/Users/me).
# Management invocations such as `wsl -l` or `wsl --shutdown` pass through,
# as does an explicit `--cd`.
export def --wrapped wsl [...args: string] {
  let management = [
    '-l' '--list' '--status' '--version' '-v' '--help' '-h'
    '--shutdown' '--terminate' '-t' '--update' '--uninstall'
    '--import' '--import-in-place' '--export' '--unregister'
    '--install' '--mount' '--unmount' '--manage' '--set-default' '-s'
    '--set-default-version' '--set-version' '--debug-shell'
  ]
  if ($args | is-empty) or (($args | first) in $management) or ('--cd' in $args) {
    ^wsl.exe ...$args
  } else {
    ^wsl.exe --cd '~' ...$args
  }
}
