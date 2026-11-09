# Run a command as the Lumirelle Bot GitHub identity.
# Nushell does not resolve `.nu` scripts from PATH, so expose the script in
# ~/.local/bin as an `ai` command.
export def --wrapped ai [...args: string] {
  ^nu ($nu.home-dir | path join '.local/bin' 'ai.nu') ...$args
}
