# returns the name of the current branch
export def git_current_branch [] {
  ^git rev-parse --abbrev-ref HEAD
}

export def git_main_branch [] {
  git remote show origin
  | lines
  | str trim
  | find --regex 'HEAD .*?[：: ].+'
  | first
  | ansi strip
  | str replace --regex 'HEAD .*?[：: ]\s*(.+)' '$1'
}

# a
export alias ga = git add
export alias gav = git add --verbose
export alias gaa = git add --all
export alias gapt = git add --patch
export alias gaup = git add --update

# ap
export alias gap = git apply
export alias gap3 = git apply --3way

# b
export alias gb = git branch
export alias gbr = git branch --remote
export alias gba = git branch --all
export alias gbd = git branch --delete
export alias gbD = git branch --delete --force
export alias gbm = git branch --move
export alias gbmc = git branch --move (git_current_branch)
export alias gbnm = git branch --no-merged

# bl
export alias gbl = git blame -b -w

# bs
export alias gbs = git bisect
export alias gbss = git bisect start
export alias gbsb = git bisect bad
export alias gbsg = git bisect good
export alias gbsn = git bisect new
export alias gbso = git bisect old
export alias gbsr = git bisect reset

# c
export alias gc = git commit --verbose
export alias gca = git commit --verbose --all
export alias gcn = git commit --verbose --no-edit
export alias gcm = git commit --verbose --amend
export alias gcnm = git commit --verbose --no-edit --amend
export alias gcan = git commit --verbose --all --no-edit
export alias gcam = git commit --verbose --all --amend
export alias gcanm = git commit --verbose --all --no-edit --amend
export alias gcas = git commit --verbose --all --signoff
export alias gcasnm = git commit --verbose --all --signoff --no-edit --amend
export def gcm [message: string] {
  git commit --message $message
}
export def gcam [message: string] {
  git commit --all --message $message
}
export def gcasm [message: string] {
  git commit --all --signoff --message $message
}
export alias gcs = git commit --gpg-sign
export alias gcss = git commit --gpg-sign --signoff
export def gcssm [message: string] {
  git commit --gpg-sign --signoff --message $message
}

# cf
export alias gcf = git config --list

# cl
export alias gcl = git clone --recurse-submodules --config core.symlinks=true

# clean & prinsitne
export alias gclean = git clean --interactive -d
export def gpristine [] {
  git reset --hard
  git clean -d --force -x
}

# co
export alias gco = git checkout
export alias gcob = git checkout -b
export alias gcom = git checkout (git_main_branch)
export alias gcor = git checkout --recurse-submodules

# count
export alias gcount = git shortlog --summary --numbered

# cp
export alias gcp = git cherry-pick
export alias gcpa = git cherry-pick --abort
export alias gcpc = git cherry-pick --continue

# d
export alias gd = git diff
export alias gdc = git diff --cached
export alias gdw = git diff --word-diff
export alias gdcw = git diff --cached --word-diff
export alias gds = git diff --staged
export alias gdup = git diff @{upstream}
export alias gdt = git diff-tree --no-commit-id --name-only -r

# dc
export alias gdct = git describe --tags (git rev-list --tags --max-count=1)

# f
export alias gf = git fetch
export alias gfo = git fetch origin
export alias gfa = git fetch --all

# g
export alias gg = git gui citool
export alias gga = git gui citool --amend

# ?
export alias g? = git help

# ignore
export alias gignore = git update-index --assume-unchanged
export alias gunignore = git update-index --no-assume-unchanged

# l
export alias gl = git log
export alias gl = git log -1
export alias gls = git log --stat
export alias glsp = git log --stat --patch
export alias glg = git log --graph
export alias glga = git log --graph --decorate --all
export alias glgm = git log --graph --max-count=10
export alias glo = git log --oneline --decorate
export alias glod = git log --graph $'--pretty=%Cred%h%Creset -%C(char lp)auto(char rp)%d%Creset %s %Cgreen(char lp)%ad(char rp) %C(char lp)bold blue(char rp)<%an>%Creset'
export alias glods = git log --graph $'--pretty=%Cred%h%Creset -%C(char lp)auto(char rp)%d%Creset %s %Cgreen(char lp)%ad(char rp) %C(char lp)bold blue(char rp)<%an>%Creset' --date=short
export alias glog = git log --oneline --decorate --graph
export alias gloga = git log --oneline --decorate --graph --all
export alias glol = git log --graph $'--pretty=%Cred%h%Creset -%C(char lp)auto(char rp)%d%Creset %s %Cgreen(char lp)%ar(char rp) %C(char lp)bold blue(char rp)<%an>%Creset'
export alias glola = git log --graph $'--pretty=%Cred%h%Creset -%C(char lp)auto(char rp)%d%Creset %s %Cgreen(char lp)%ar(char rp) %C(char lp)bold blue(char rp)<%an>%Creset' --all
export alias glols = git log --graph $'--pretty=%Cred%h%Creset -%C(char lp)auto(char rp)%d%Creset %s %Cgreen(char lp)%ar(char rp) %C(char lp)bold blue(char rp)<%an>%Creset' --stat

# m
export alias gm = git merge
export alias gmt = git mergetool --no-prompt
export alias gmtvim = git mergetool --no-prompt --tool=vimdiff
export alias gma = git merge --abort
export def gmm [] {
  let main = (git_main_branch)
  git merge $"origin/($main)"
}

# me
export def gme [] {
  echo $"(git config get user.name) <(git config get user.email)>"
}

# r
export alias gr = git remote
export alias grv = git remote --verbose
export alias gra = git remote add
export alias grup = git remote update
export def grmv [remote: string, new_name: string] {
  git remote rename $remote $new_name
}
export def grrm [remote: string] {
  git remote remove $remote
}
export def grset [remote: string, url: string] {
  git remote set-url $remote $url
}

# p
export alias gp = git push
export alias gpv = git push --verbose
export alias gpd = git push --dry-run
export alias gpf = git push --force-with-lease
export alias gpf! = git push --force
export alias gpoa = git push origin --all
export alias gpod = git push origin --delete
export alias gpodc = git push origin --delete (git_current_branch)
export alias gpup = git push upstream
export alias gpsup = git push --set-upstream origin (git_current_branch)

# pl
export alias gpl = git pull
export alias gplv = git pull --verbose
export alias gplupm = git pull upstream (git_main_branch)

# rb
export alias grb = git rebase
export alias grba = git rebase --abort
export alias grbc = git rebase --continue
export alias grbi = git rebase --interactive
export alias grbm = git rebase (git_main_branch)
export alias grbo = git rebase --onto
export alias grbs = git rebase --skip

# rv
export alias grv = git revert

# rs
export alias grs = git reset
export alias grsh = git reset --hard
export alias grsoh = git reset $"origin/(git_current_branch)" --hard
export alias grsu = git reset --

# rm
export alias grm = git rm
export alias grmc = git rm --cached

# rst
export alias grst = git restore
export alias grsts = git restore --source
export alias grstt = git restore --staged

# rt
# Go to root
export alias grt = cd (git rev-parse --show-toplevel | complete | if $in.exit_code == 0 { $in.stdout | str trim } else { '.' })

# s
export alias gs = git status
export alias gss = git status --short
export alias gssb = git status --short --branch

# sh
export alias gsh = git show
export alias gshs = git show -s
export alias gshps = git show --pretty=short --show-signature

# sm
export alias gsmi = git submodule init
export alias gsmu = git submodule update

# st
export alias gstp = git stash push
export alias gstpp = git stash pop
export alias gsta = git stash apply
export alias gstc = git stash clear
export alias gstd = git stash drop
export alias gstl = git stash list
export alias gsts = git stash show --text
export alias gstu = gsta --include-untracked
export alias gstall = git stash --all

# sw
export alias gsw = git switch
export alias gswc = git switch --create

# t
export alias gts = git tag --sign
export def gtv [] {
  git tag | lines | sort
}

# wch
export alias gwch = git whatchanged -p --abbrev-commit --pretty=medium

# wt
export alias gwt = git worktree
export def gwta [path: path, branch?: string] {
  if $branch != null {
    git worktree add $path $branch
  } else {
    git worktree add $path
  }
}
export alias gwtls = git worktree list
export alias gwtmv = git worktree move
export def gwtrm [worktree: string] {
  git worktree remove $worktree
}

# am
export alias gam = git am
export alias gamc = git am --continue
export alias gams = git am --skip
export alias gama = git am --abort
export alias gamsh = git am --show-current-patch
