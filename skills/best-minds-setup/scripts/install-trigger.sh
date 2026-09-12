#!/usr/bin/env bash
# Install, move, or remove the best-minds-optimizer prompt trigger.
#
# The trigger is a UserPromptSubmit hook that runs best-minds-gate.sh, which
# injects an "invoke the skill" directive for substantive prompts only.
#
# Usage:
#   bash install-trigger.sh --scope user             # ~/.claude/settings.json
#   bash install-trigger.sh --scope project          # <project>/.claude/settings.local.json (personal)
#   bash install-trigger.sh --scope project-shared   # <project>/.claude/settings.json (committed)
#   bash install-trigger.sh --scope user --uninstall
#
# Options:
#   --project-dir DIR   project root for the project scopes (default: current directory)
#   --dry-run           print the before/after hook block, write nothing
#   --uninstall         remove the trigger entries instead of adding one
#
# Requires jq. Existing settings and gate files are backed up before writing.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GATE_SRC="$SCRIPT_DIR/best-minds-gate.sh"

SCOPE=""
PROJECT_DIR="$PWD"
DRY_RUN=0
UNINSTALL=0

usage() { sed -n '2,19p' "$0"; exit "${1:-0}"; }

while [ $# -gt 0 ]; do
  case "$1" in
    --scope) SCOPE="${2:-}"; shift 2 ;;
    --scope=*) SCOPE="${1#*=}"; shift ;;
    --project-dir) PROJECT_DIR="${2:-}"; shift 2 ;;
    --project-dir=*) PROJECT_DIR="${1#*=}"; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    --uninstall) UNINSTALL=1; shift ;;
    -h|--help) usage 0 ;;
    *) echo "error: unknown argument: $1" >&2; usage 1 ;;
  esac
done

command -v jq >/dev/null 2>&1 || {
  echo "error: jq is required, both by this installer and by the gate script itself." >&2
  echo "       Install it first: https://jqlang.github.io/jq/download/" >&2
  exit 1
}
[ -f "$GATE_SRC" ] || { echo "error: gate script missing next to this installer: $GATE_SRC" >&2; exit 1; }

case "$SCOPE" in
  user)
    SETTINGS="$HOME/.claude/settings.json"
    GATE_DEST="$HOME/.claude/best-minds-gate.sh"
    SKILL_DIRS="$HOME/.claude/skills"
    ;;
  project|project-shared)
    PROJECT_DIR="$(cd "$PROJECT_DIR" 2>/dev/null && pwd)" || { echo "error: no such directory: $PROJECT_DIR" >&2; exit 1; }
    if [ "$SCOPE" = "project" ]; then
      SETTINGS="$PROJECT_DIR/.claude/settings.local.json"
    else
      SETTINGS="$PROJECT_DIR/.claude/settings.json"
    fi
    GATE_DEST="$PROJECT_DIR/.claude/best-minds-gate.sh"
    SKILL_DIRS="$PROJECT_DIR/.claude/skills $HOME/.claude/skills"
    ;;
  "") echo "error: --scope is required (user | project | project-shared)" >&2; usage 1 ;;
  *) echo "error: unknown scope: $SCOPE" >&2; usage 1 ;;
esac

# The trigger is useless without the skill, so say so early. Not fatal: people
# sometimes set up the trigger first and install the skill afterwards.
if [ "$UNINSTALL" -eq 0 ]; then
  found=0
  for d in $SKILL_DIRS; do
    [ -d "$d/best-minds-optimizer" ] && found=1
  done
  if [ "$found" -eq 0 ]; then
    echo "warning: best-minds-optimizer is not installed in: $SKILL_DIRS" >&2
    echo "         npx skills add https://github.com/MoGHenry/superminds --skill best-minds-optimizer" >&2
  fi

  # A model: pin in the skill's frontmatter switches models for the rest of the
  # turn every time the skill fires, which is easy to install and then forget.
  for d in $SKILL_DIRS; do
    sk="$d/best-minds-optimizer/SKILL.md"
    if [ -f "$sk" ] && grep -q "^model:" "$sk"; then
      echo "warning: $sk pins '$(grep -m1 '^model:' "$sk")'" >&2
      echo "         Claude Code applies that model to the rest of the turn whenever the skill fires." >&2
    fi
  done
fi

mkdir -p "$(dirname "$SETTINGS")"
if [ -f "$SETTINGS" ]; then
  jq empty "$SETTINGS" 2>/dev/null || {
    echo "error: $SETTINGS is not valid JSON. Fix it first; nothing was changed." >&2
    exit 1
  }
  CURRENT="$(jq '.' "$SETTINGS")"
else
  CURRENT='{}'
fi

CMD="bash \"$GATE_DEST\""

# Drop any entry that already runs a best-minds gate, so re-running this
# installer moves the trigger instead of stacking a second copy.
PRUNE='
  .hooks //= {}
  | .hooks.UserPromptSubmit //= []
  | .hooks.UserPromptSubmit |= (
      map(.hooks |= map(select(((.command? // "") | test("best-minds-gate")) | not)))
      | map(select(((.hooks // []) | length) > 0))
    )
'

if [ "$UNINSTALL" -eq 1 ]; then
  PROGRAM="$PRUNE
  | (if (.hooks.UserPromptSubmit | length) == 0 then del(.hooks.UserPromptSubmit) else . end)
  | (if (.hooks | length) == 0 then del(.hooks) else . end)"
else
  PROGRAM="$PRUNE
  | .hooks.UserPromptSubmit += [{\"hooks\": [{\"type\": \"command\", \"command\": \$cmd, \"timeout\": 5}]}]"
fi

NEW="$(printf '%s' "$CURRENT" | jq --arg cmd "$CMD" "$PROGRAM")"

if [ "$DRY_RUN" -eq 1 ]; then
  echo "scope         : $SCOPE"
  echo "settings file : $SETTINGS"
  echo "gate script   : $GATE_DEST (copied from $GATE_SRC)"
  echo "--- hooks.UserPromptSubmit now ---"
  printf '%s' "$CURRENT" | jq '.hooks.UserPromptSubmit // "none"'
  echo "--- hooks.UserPromptSubmit after ---"
  printf '%s' "$NEW" | jq '.hooks.UserPromptSubmit // "none"'
  echo "(dry run: nothing was written)"
  exit 0
fi

TS="$(date +%Y%m%d-%H%M%S)"

if [ "$UNINSTALL" -eq 0 ]; then
  if [ -f "$GATE_DEST" ] && ! cmp -s "$GATE_SRC" "$GATE_DEST"; then
    cp "$GATE_DEST" "$GATE_DEST.bak.$TS"
    echo "backed up gate     -> $GATE_DEST.bak.$TS"
  fi
  cp "$GATE_SRC" "$GATE_DEST"
  chmod +x "$GATE_DEST" 2>/dev/null || true
fi

# Only touch the settings file when the merge changes something, so a re-run is
# a real no-op instead of a pile of identical backups.
if [ "$(printf '%s' "$CURRENT" | jq -S -c '.')" = "$(printf '%s' "$NEW" | jq -S -c '.')" ]; then
  SETTINGS_CHANGED=0
else
  SETTINGS_CHANGED=1
fi

if [ "$SETTINGS_CHANGED" -eq 1 ]; then
  if [ -f "$SETTINGS" ]; then
    cp "$SETTINGS" "$SETTINGS.bak.$TS"
    echo "backed up settings -> $SETTINGS.bak.$TS"
  fi
  printf '%s\n' "$NEW" > "$SETTINGS.tmp.$$"
  mv "$SETTINGS.tmp.$$" "$SETTINGS"
fi

if [ "$UNINSTALL" -eq 1 ]; then
  if [ "$SETTINGS_CHANGED" -eq 1 ]; then
    echo "removed: best-minds trigger entries in $SETTINGS"
    echo "         (the gate script at $GATE_DEST was left in place)"
  else
    echo "nothing to remove: no best-minds trigger in $SETTINGS"
  fi
else
  # Verify the way the hook will actually be read and run.
  jq -e --arg cmd "$CMD" \
    '.hooks.UserPromptSubmit[] | .hooks[] | select(.type == "command") | select(.command == $cmd) | .command' \
    "$SETTINGS" >/dev/null || {
      echo "error: the hook cannot be read back from $SETTINGS" >&2
      exit 1
    }
  loud="$(printf '%s' '{"prompt":"how should I price my consulting work for enterprise clients?"}' | bash "$GATE_DEST" || true)"
  [ -n "$loud" ] || { echo "error: the gate printed nothing for a substantive prompt" >&2; exit 1; }
  quiet="$(printf '%s' '{"prompt":"commit this"}' | bash "$GATE_DEST" || true)"
  [ -z "$quiet" ] || echo "warning: the gate fired on a trivial prompt; check $GATE_DEST" >&2

  if [ "$SETTINGS_CHANGED" -eq 1 ]; then
    echo "installed: UserPromptSubmit -> $CMD"
  else
    echo "already set: UserPromptSubmit -> $CMD (settings unchanged)"
  fi
  echo "settings : $SETTINGS"
  echo "verified : directive on a substantive prompt, silence on \"commit this\""
fi

if [ "$SCOPE" = "project" ]; then
  if ! git -C "$PROJECT_DIR" check-ignore -q ".claude/settings.local.json" 2>/dev/null; then
    echo "hint: add .claude/settings.local.json to .gitignore so your personal trigger is not committed"
  fi
fi

echo "note: a session that is already running may need /hooks (or a restart) before this takes effect."
