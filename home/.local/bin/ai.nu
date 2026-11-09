#!/usr/bin/env nu
# ai - run a command as the Lumirelle Bot GitHub identity.
# Sets GH_CONFIG_DIR, GIT_SSH_COMMAND and the GIT_AUTHOR_*/GIT_COMMITTER_* pair.
# with-env scopes every setting to the child process, so the parent shell is
# untouched.

def --wrapped main [...args: string] {
  if ($args | is-empty) {
    print -e 'usage: ai <command> [args...]'
    exit 2
  }

  # ssh reads -i with backslashes poorly on Windows; forward slashes work on
  # both Windows and Unix.
  let ssh_key = (
    $nu.home-dir
    | path join '.ssh' 'id_ed25519_ai'
    | into string
    | str replace -a '\' '/'
  )

  with-env {
    GH_CONFIG_DIR: ($nu.home-dir | path join '.config' 'gh-ai' | into string)
    GIT_SSH_COMMAND: $"ssh -o IdentitiesOnly=yes -i ($ssh_key)"
    GIT_AUTHOR_NAME: "Lumirelle's Bot"
    GIT_COMMITTER_NAME: "Lumirelle's Bot"
    GIT_AUTHOR_EMAIL: 'githubbot@lumirelle.me'
    GIT_COMMITTER_EMAIL: 'githubbot@lumirelle.me'
  } {
    run-external ($args | first) ...($args | skip 1)
  }
}
