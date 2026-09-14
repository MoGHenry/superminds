#!/usr/bin/env bash
# Print the turns the human typed in one or more Claude Code transcripts.
#   Usage: bash extract-turns.sh [--json|--stats] <transcript.jsonl> [more...]
# Default output is one readable block per turn; --json emits {ts,chars,text}
# objects; --stats emits counts and the length distribution only.
set -uo pipefail

HERE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
JQF="$HERE/human-turns.jq"
MODE=text

while [ $# -gt 0 ]; do
  case "$1" in
    --json)  MODE=json;  shift ;;
    --stats) MODE=stats; shift ;;
    --text)  MODE=text;  shift ;;
    --) shift; break ;;
    -*) echo "unknown option: $1" >&2; exit 2 ;;
    *) break ;;
  esac
done

[ $# -gt 0 ] || { echo "usage: bash extract-turns.sh [--json|--stats] <transcript.jsonl> [more...]" >&2; exit 2; }
command -v jq >/dev/null 2>&1 || { echo "jq is required but not installed" >&2; exit 4; }
[ -f "$JQF" ] || { echo "missing $JQF" >&2; exit 5; }

for f in "$@"; do
  [ -f "$f" ] || { echo "not a file: $f" >&2; exit 6; }
done

TURNS="$(jq -c -f "$JQF" "$@" 2>/dev/null)"
[ -n "$TURNS" ] || { echo "No human-typed turns found." >&2; exit 1; }

case "$MODE" in
  json)
    printf '%s\n' "$TURNS"
    ;;
  stats)
    printf '%s\n' "$TURNS" | jq -s '
      (map(.chars) | sort) as $L
      | { turns: length,
          first: (map(.ts) | map(select(. != "")) | sort | first // "-"),
          last:  (map(.ts) | map(select(. != "")) | sort | last  // "-"),
          chars: { min: ($L | first), median: ($L[($L|length)/2|floor]),
                   p90: ($L[(($L|length)*0.9)|floor]), max: ($L | last),
                   mean: (($L | add) / ($L | length) | round) },
          under_20_chars: (map(select(.chars < 20)) | length) }'
    ;;
  text)
    printf '%s\n' "$TURNS" | jq -r '"── " + (.ts[0:19]) + " · " + (.chars|tostring) + " chars ──\n" + .text + "\n"'
    ;;
esac
