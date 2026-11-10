#!/usr/bin/env nushell
# build-pyyaml - build a PyYAML wheel for the active interpreter into the local
# pip wheelhouse, for Pythons that have no prebuilt PyYAML wheel yet.
#
# PyYAML lags newly released Pythons: when no wheel exists for the active
# interpreter, mason's `pip install --ignore-installed` compiles it from source
# and fails on machines without a C toolchain. Prebuilding the wheel here lets
# pip pick it up through the `--find-links` entry in lua/plugins/mason.lua.
#
# Wheels go to $env.PIP_WHEELHOUSE (default ~/.local/share/pip-wheelhouse).
# On Windows, setuptools is steered to MinGW's gcc when MSVC is not installed;
# if the C extension still cannot be built (PyYAML needs libyaml headers) the
# build falls back to a pure-Python wheel, which installs fine.

const package = 'pyyaml'

# Mason prefers `python` on Windows and `python3` elsewhere; match that so the
# wheel fits the interpreter mason will actually use.
def pick-python [] {
  let candidates = if $nu.os-info.name == 'windows' {
    ['python' 'python3']
  } else {
    ['python3' 'python']
  }
  let found = ($candidates | where {|candidate| (which $candidate | is-not-empty) } | get -i 0)
  if $found == null {
    print -e 'build-pyyaml: no Python interpreter found'
    exit 1
  }
  $found
}

def wheelhouse [] {
  $env.PIP_WHEELHOUSE? | default ($nu.home-dir | path join '.local' 'share' 'pip-wheelhouse')
}

def official-wheel-exists [python: string, tmp: path] {
  let result = (
    ^$python -m pip download --quiet --disable-pip-version-check --only-binary=:all:
      --no-deps --dest ($tmp | path join 'official') $package | complete
  )
  $result.exit_code == 0
}

def fetch-sdist [tmp: path] {
  let data = (http get $"https://pypi.org/pypi/($package)/json")
  let sdists = ($data.urls | where packagetype == 'sdist')
  if ($sdists | is-empty) {
    error make { msg: $"build-pyyaml: PyPI publishes no sdist for ($package)" }
  }

  let url = ($sdists | get 0.url | into string)
  print $"fetching ($url)"
  let archive = ($tmp | path join ($url | path basename))
  http get $url | save --force $archive

  let srcroot = ($tmp | path join 'src')
  mkdir $srcroot
  ^tar -xf $archive -C $srcroot

  let srcdir = (ls $srcroot | where type == 'dir' | get 0.name | path expand)
  $srcdir
}

def use-mingw-when-msvc-is-missing [srcdir: path] {
  if $nu.os-info.name != 'windows' {
    return
  }
  if not (($srcdir | path join 'setup.py') | path exists) {
    return
  }
  if (which gcc | is-empty) {
    print -e 'warning: no gcc on PATH, setuptools will look for MSVC'
    return
  }

  let cfg = ($srcdir | path join 'setup.cfg')
  let text = if ($cfg | path exists) { open --raw $cfg } else { '' }
  if not ($text | str contains '[build_ext]') {
    ($text + "\n[build_ext]\ncompiler = mingw32\n") | save --force $cfg
  }
}

def build [python: string, dest: path, tmp: path] {
  if (official-wheel-exists $python $tmp) {
    print $"($package): a prebuilt wheel exists for this interpreter, nothing to do"
    return 0
  }

  print $"($package): no prebuilt wheel for this interpreter, building from source"
  let srcdir = (fetch-sdist $tmp)
  use-mingw-when-msvc-is-missing $srcdir

  ^$python -m pip wheel --disable-pip-version-check --no-deps --wheel-dir $dest $srcdir
  if $env.LAST_EXIT_CODE != 0 {
    print -e 'build-pyyaml: build failed'
    return $env.LAST_EXIT_CODE
  }

  let wheels = (ls $dest | where name =~ 'pyyaml-.*[.]whl$' | sort-by modified)
  if ($wheels | is-not-empty) {
    print $"built (($wheels | last).name)"
  }
  0
}

def main [] {
  let python = (pick-python)
  let dest = (wheelhouse)
  mkdir $dest

  let base = ($env.TEMP? | default ($env.TMPDIR? | default $nu.home-dir))
  let tmp = ($base | path join $"build-pyyaml-(random uuid)")
  mkdir $tmp

  let status = (
    try {
      build $python $dest $tmp
    } catch {|err|
      print -e $"build-pyyaml: ($err.msg)"
      1
    }
  )
  rm --recursive --force $tmp

  if $status == 0 {
    print $"wheelhouse: ($dest)"
  }
  exit $status
}
