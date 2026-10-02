export alias ll = ls --long
export alias la = ls --all

export alias cls = clear

export def readtime [filepath: string] {
  const default_wpm = 260
  let words = open $filepath --raw | str stats | get words
  if ($env.READTIME_WPM? | is-empty) {
    print $'≈ ($words / $default_wpm | math round) min <WPM: ($default_wpm)>'
  } else {
    print $'≈ ($words / $env.READTIME_WPM | math round) min <WPM: ($env.READTIME_WPM)>'
  }
}
