@echo off
rem ai - run a command as the Lumirelle Bot GitHub identity.
rem Sets GH_CONFIG_DIR, GIT_SSH_COMMAND and the GIT_AUTHOR_*/GIT_COMMITTER_* pair.
rem setlocal keeps every setting inside this process, so the parent shell is untouched.

setlocal

set "GH_CONFIG_DIR=%USERPROFILE%\.config\gh-ai"
set "GIT_SSH_COMMAND=ssh -o IdentitiesOnly=yes -i %USERPROFILE:\=/%/.ssh/id_ed25519_ai"
set "GIT_AUTHOR_NAME=Lumirelle Bot"
set "GIT_COMMITTER_NAME=Lumirelle Bot"
set "GIT_AUTHOR_EMAIL=githubbot@lumirelle.me"
set "GIT_COMMITTER_EMAIL=githubbot@lumirelle.me"

if "%~1"=="" (
  >&2 echo usage: ai ^<command^> [args...]
  exit /b 2
)

%*
