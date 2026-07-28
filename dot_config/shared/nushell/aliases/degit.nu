# Create a new project from a GitHub repository without cloning the entire repository history.
@example "Create a new project from a GitHub repository" {degit 'user/repo#branch' dest}
export def --env degit [
  repo: string # The GitHub repository in the format "user/repo#branch". the branch is optional, defaults to "main"
  dest: string = "." # The destination directory where the project will be created
] {
  if ($dest | path exists) {
    if (ls -a $dest | is-not-empty) {
      let span = (metadata $dest).span
      error make {
        msg: "Target directory is not empty. Please specify an empty directory or a new directory."
        label: {text: "Target directory is not empty", span: $span}
      }
    }
  } else {
    mkdir $dest
  }
  let branch = (
    $repo
    | parse "{r}#{b}"
    | get b
    | default ["main"] --empty
    | get 0
  )
  let clean_repo = $repo | split row "#" | get 0
  let url = $"https://github.com/($clean_repo)/archive/refs/heads/($branch).tar.gz"
  print $"Creating project from ($url)..."
  http get $url | tar -xz --strip-components=1 -C $dest
  print "Done!"
}
export alias dg = degit
