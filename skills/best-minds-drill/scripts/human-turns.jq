# Emit one compact {ts, chars, text} object per turn the human actually typed.
# Input: a Claude Code transcript .jsonl, streamed (no --slurp).
#
# promptSource is the discriminator: "typed", "queued" and "suggestion_accepted"
# come from the keyboard; "system" and records without the field are injected
# context, tool results or pasted stdout.
select(.type == "user"
  and (has("toolUseResult") | not)
  and ((.isMeta // false) | not)
  and ((.isCompactSummary // false) | not)
  and ((.promptSource // "") as $p
       | $p == "typed" or $p == "queued" or $p == "suggestion_accepted"))
| { ts: (.timestamp // ""),
    text: (if (.message.content | type) == "string"
           then .message.content
           else ([.message.content[]? | select(.type == "text") | .text] | join("\n"))
           end) }
| select(.text | test("^\\s*$") | not)
| select(.text | test("^\\s*<(command-|local-command|task-notification|system-reminder)") | not)
| select(.text | test("^/[a-z][a-z0-9-]*\\s*$") | not)
| { ts, chars: (.text | length), text }
