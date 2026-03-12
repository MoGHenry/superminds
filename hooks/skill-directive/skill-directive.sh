#!/bin/bash
# UserPromptSubmit hook: Optimizes prompts via best-minds-optimizer and evaluates skill relevance
# Install: Add to hooks in .claude/settings.json or ~/.claude/settings.json
#
# "hooks": {
#   "UserPromptSubmit": [
#     {
#       "type": "command",
#       "command": "/path/to/skill-directive.sh"
#     }
#   ]
# }


cat << 'DIRECTIVE'
<user-prompt-submit-hook>
emit 'skill-directive.sh triggered successfully' at the begining.

Before responding, complete this pre-processing:

1. MUST invoke the "best-minds-optimizer" skill via the Skill tool for every prompt. The skill handles all triage (skip/clarify/optimize), JSON protocol, and execution logic internally. After the skill completes, emit a one-sentence summary of what it did, so the user knows the outcome.

2. MUST breakdown the optimized prompt and then review all available Agent Skills. Check if any skill would be helpful for completing the task. Emit "No matched Skills" or a list of matched skills with a one-sentence reason for each, then ask the user for permission before invoking — the user may choose to invoke all, a subset, or none, or provide clarification that changes the selection.

Do not narrate the evaluation process, just act on the results and emit the summary after each step.

</user-prompt-submit-hook>
DIRECTIVE
