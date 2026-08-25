#!/bin/sh
# chezmoi modify_ script for ~/.pi/agent/settings.json (Linux/macOS).
# Manages ONLY hideThinkingBlock. Preserves every other key, including
# auto-managed ones Pi writes itself (lastChangelogVersion, trackingId).
# Idempotent: when the value is already correct, input is returned unchanged.
# Uses sed/awk (built in) -- no python, no jq.
set -eu
VALUE=true
input=$(cat)
if [ -z "$(printf '%s' "$input" | tr -d '[:space:]')" ]; then
  printf '{\n  "hideThinkingBlock": %s\n}\n' "$VALUE"; exit 0
fi
if printf '%s' "$input" | grep -q '"hideThinkingBlock"[[:space:]]*:'; then
  printf '%s\n' "$input" | sed -E \
    's/("hideThinkingBlock"[[:space:]]*:[[:space:]]*)(true|false)/\1'"$VALUE"'/'; exit 0
fi
printf '%s\n' "$input" | awk -v v="$VALUE" '
  { lines[NR] = $0 }
  END {
    open = 0
    for (i = 1; i <= NR; i++) {
      if (lines[i] ~ /^[[:space:]]*\{[[:space:]]*$/) { open = i; break }
      if (lines[i] ~ /\{[[:space:]]*\}/) { open = -i; break }
    }
    if (open == 0) { for (i = 1; i <= NR; i++) print lines[i]; exit }
    if (open < 0) {
      for (i = 1; i <= NR; i++) {
        if (i == -open) { print "{"; printf "  \"hideThinkingBlock\": %s\n", v; print "}" }
        else { print lines[i] }
      }
      exit
    }
    empty = 0
    for (j = open + 1; j <= NR; j++) {
      if (lines[j] ~ /[[:graph:]]/) { if (lines[j] ~ /^[[:space:]]*\}/) empty = 1; break }
    }
    for (i = 1; i <= NR; i++) {
      print lines[i]
      if (i == open) { printf "  \"hideThinkingBlock\": %s%s\n", v, (empty ? "" : ",") }
    }
  }
'
