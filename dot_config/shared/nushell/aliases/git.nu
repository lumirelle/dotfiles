# branch, b
export alias gba = git branch --all
export alias gbr = git branch --remote
export alias gbnm = git branch --no-merged # List branch which are not merged into current branch

# bisect, bs
export alias gbs = git bisect
export alias gbss = git bisect start
export alias gbsb = git bisect bad
export alias gbsg = git bisect good
export alias gbsn = git bisect new
export alias gbso = git bisect old
export alias gbsr = git bisect reset

# config, cf
export alias gcf = git config --list

# clone, cl
export alias gcl = git clone --config core.symlinks=true

# help, ?
export alias g? = git help

# me
export def gme [] {
  echo $"(git config get user.name) <(git config get user.email)>"
}

# p
export alias gp = git pull

# ps
export alias gps = git push
export alias gpsf = git push --force

# root, rt
# Go to root
export alias grt = cd (git rev-parse --show-toplevel | complete | if $in.exit_code == 0 { $in.stdout | str trim } else { '.' })

# summary
export alias gsummary = git shortlog --summary --numbered
