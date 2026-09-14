#!/usr/bin/env bash
# UserPromptSubmit gate for best-minds-optimizer.
#
# Why this exists: the prior hook force-invoked the skill on EVERY prompt,
# including trivial one-liners ("commit this", "go", "yes"). Each forced call
# cost a Skill load + main-model reasoning just to decide "skip". This gate
# only injects the invoke-directive for *substantive* prompts, so trivial
# inputs skip the skill entirely. Substantive prompts behave exactly as before.
#
# Contract: reads the UserPromptSubmit JSON on stdin, extracts .prompt, and
# prints the directive to stdout (which the harness injects as context) only
# when the prompt looks substantial. Prints nothing otherwise. Always exit 0
# so a parse hiccup never blocks the prompt.

set -euo pipefail

DIRECTIVE='Before responding, invoke the best-minds-triage skill (via the Skill tool) on this prompt. It runs on a small model in an isolated subagent and returns one lane: skip, polish, clarify, or optimize. If the lane is skip, answer the original prompt directly. Otherwise invoke best-minds-optimizer and pass it that lane, so the optimization and the answer run on the session model. If best-minds-triage is not installed, invoke best-minds-optimizer directly; it triages itself.'

input="$(cat || true)"
prompt="$(printf '%s' "$input" | jq -r '.prompt // empty' 2>/dev/null || true)"
# Fallback: if extraction fails, do NOT force the skill (fail toward cheaper).
[ -z "$prompt" ] && exit 0

# Normalize: strip leading/trailing whitespace.
trimmed="$(printf '%s' "$prompt" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
len=${#trimmed}
words=$(printf '%s' "$trimmed" | wc -w | tr -d ' ')

# Substantive if it's long, multi-clause, or an explicit question. Short
# mechanical commands ("commit this", "run the tests", "go") fall through silent.
substantive=0
[ "$len" -ge 50 ] && substantive=1
[ "$words" -ge 10 ] && substantive=1
case "$trimmed" in *\?) substantive=1 ;; esac

# Explicit opt-in phrases always force it, regardless of length. Matched
# case-insensitively, anywhere in the prompt. The "best mind"/"best-mind"/
# "bestmind" trio covers singular+plural for space, hyphen, and joined spellings.
shopt -s nocasematch || true
case "$trimmed" in
  *"best mind"*|*"best-mind"*|*"bestmind"*|*"optimize this"*|*"optimize the prompt"*|*"world-class"*|*"what would "*"say"*) substantive=1 ;;
esac

[ "$substantive" -eq 1 ] && printf '%s\n' "$DIRECTIVE"
exit 0
