#!/usr/bin/env bash
# Locate Claude Code transcript files for a repo and describe each one, so the
# user can pick which sessions to analyse.
#   Usage: bash find-sessions.sh <repo-name | absolute-path>
set -uo pipefail

ROOT="${CLAUDE_PROJECTS_DIR:-$HOME/.claude/projects}"
HERE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
JQF="$HERE/human-turns.jq"
QUERY="${1:-}"

[ -n "$QUERY" ] || { echo "usage: bash find-sessions.sh <repo-name | absolute-path>" >&2; exit 2; }
command -v jq >/dev/null 2>&1 || { echo "jq is required but not installed" >&2; exit 4; }
[ -d "$ROOT" ] || { echo "no transcript root at $ROOT" >&2; exit 3; }
[ -f "$JQF" ] || { echo "missing $JQF" >&2; exit 5; }

# Claude Code names a project directory after its absolute path with every / turned into -.
case "$QUERY" in
  /*) PATTERN="${QUERY%/}"; PATTERN="${PATTERN//\//-}" ;;
   *) PATTERN="$QUERY" ;;
esac

mapfile -t DIRS < <(find "$ROOT" -mindepth 1 -maxdepth 1 -type d -name "*${PATTERN}*" -printf '%f\n' 2>/dev/null | sort)

if [ "${#DIRS[@]}" -eq 0 ]; then
  { echo "No transcript directory matches '${QUERY}'."
    echo
    echo "Projects under $ROOT:"
    find "$ROOT" -mindepth 1 -maxdepth 1 -type d -printf '  %f\n' 2>/dev/null | sort
  } >&2
  exit 1
fi

for d in "${DIRS[@]}"; do
  echo "DIR  $ROOT/$d"
  shopt -s nullglob; files=("$ROOT/$d"/*.jsonl); shopt -u nullglob
  if [ "${#files[@]}" -eq 0 ]; then echo "     (no .jsonl files)"; echo; continue; fi
  printf '     %-42s %10s %11s %11s %7s\n' FILE TURNS FIRST LAST SIZE
  for f in "${files[@]}"; do
    out="$(jq -c -f "$JQF" "$f" 2>/dev/null)"
    if [ -z "$out" ]; then
      turns=0; first="-"; last="-"
    else
      turns="$(printf '%s\n' "$out" | grep -c '^{')"
      first="$(printf '%s\n' "$out" | head -n1 | jq -r '.ts[0:10]' 2>/dev/null)"
      last="$(printf '%s\n'  "$out" | tail -n1 | jq -r '.ts[0:10]' 2>/dev/null)"
    fi
    printf '     %-42s %10s %11s %11s %7s\n' "$(basename -- "$f")" "$turns" "${first:--}" "${last:--}" "$(du -h -- "$f" | cut -f1)"
  done
  echo
done
