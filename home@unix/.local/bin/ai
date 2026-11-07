#!/bin/sh
# ai - run a command as the Lumirelle Bot GitHub identity.
# Sets GH_CONFIG_DIR, GIT_SSH_COMMAND and the GIT_AUTHOR_*/GIT_COMMITTER_* pair.
# Exported only for this process; the parent shell is unaffected.

GH_CONFIG_DIR="$HOME/.config/gh-ai"
GIT_SSH_COMMAND="ssh -o IdentitiesOnly=yes -i \"$HOME/.ssh/id_ed25519_ai\""
GIT_AUTHOR_NAME='Lumirelle Bot'
GIT_COMMITTER_NAME='Lumirelle Bot'
GIT_AUTHOR_EMAIL='githubbot@lumirelle.me'
GIT_COMMITTER_EMAIL='githubbot@lumirelle.me'
export GH_CONFIG_DIR GIT_SSH_COMMAND GIT_AUTHOR_NAME GIT_COMMITTER_NAME \
       GIT_AUTHOR_EMAIL GIT_COMMITTER_EMAIL

if [ "$#" -eq 0 ]; then
  echo 'usage: ai <command> [args...]' >&2
  exit 2
fi

exec "$@"
