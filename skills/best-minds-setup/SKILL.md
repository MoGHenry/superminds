---
name: best-minds-setup
description: Install, move, or remove the best-minds-optimizer prompt trigger (a UserPromptSubmit hook) at user or project scope, and diagnose a trigger that never fires.
disable-model-invocation: true
argument-hint: "user | project | project-shared | uninstall"
---

# Best Minds Setup

Installs the trigger that makes `best-minds-optimizer` run on its own.

The skill on its own does nothing to a normal prompt. The trigger is a `UserPromptSubmit` hook that runs `best-minds-gate.sh`, which prints an invoke-the-skill directive for substantive prompts only.

All the work is done by `scripts/install-trigger.sh`, which sits next to this file. Always run it with `bash <path>`, never as a bare path, because the executable bit doesn't survive every download.

## Scopes

| Scope | Settings file | Who it applies to |
|-------|---------------|-------------------|
| `user` | `~/.claude/settings.json` | you, in every project |
| `project` | `<project>/.claude/settings.local.json` | you, in this project only (keep it out of git) |
| `project-shared` | `<project>/.claude/settings.json` | everyone working in this repo (committed) |

Default to `user`. Wanting sharper prompts is a personal preference, not a property of one repository.

## Steps

1. **Pick the scope.** Use the argument if one was given. Otherwise ask a multiple-choice question offering user (recommended), project, project-shared, and uninstall.
2. **Dry run first:**
   ```
   bash <skill dir>/scripts/install-trigger.sh --scope <scope> --dry-run
   ```
   For the project scopes, add `--project-dir <path>` unless the working directory is already the project root. Show the user the before and after hook blocks it prints.
3. **Apply once they agree.** Same command without `--dry-run`. It backs up the existing settings file and gate script before writing anything, and it replaces any trigger entry that is already there rather than adding a second one.
4. **Report** the settings file it wrote, the command it registered, and the two verification lines it prints. Tell the user that a session already running may need `/hooks` or a restart before the trigger takes effect.
5. **Uninstall** with `--uninstall`. It removes only the hook entries that run `best-minds-gate.sh` and leaves the rest of the settings file alone.

## What the gate does

`best-minds-gate.sh` prints its directive only when the prompt looks substantive:

- 50 characters or more, or
- 10 words or more, or
- ends with a question mark, or
- contains an opt-in phrase: "best mind", "best-mind", "bestmind", "optimize this", "optimize the prompt", "world-class", or "what would … say".

Short instructions like "commit this" or "fix the header bug" print nothing, so the skill never loads and costs nothing.

**This is the usual reason people think the optimizer is broken.** To force it on a short prompt, include one of the opt-in phrases.

## Requirements

- **`jq`**, used by the installer and by the gate at run time. If `jq` is missing, the gate silently prints nothing and the skill never fires.
- **The skill itself:**
  ```
  npx skills add https://github.com/MoGHenry/superminds --skill best-minds-optimizer
  ```
  The installer warns if it can't find `best-minds-optimizer` in the skills directories for the chosen scope.
- **Optional, for a cheaper first pass:**
  ```
  npx skills add https://github.com/MoGHenry/superminds --skill best-minds-triage
  ```
  When it's installed, the gate's directive sends the prompt to `best-minds-triage` first, which returns a lane from a small-model fork. When it isn't, the directive falls back to `best-minds-optimizer` triaging itself.

## Troubleshooting

| Symptom | Check |
|---------|-------|
| Nothing happens on short prompts | Expected. The gate filters them. Try a question, or an opt-in phrase. |
| Nothing happens on any prompt | `jq -e '.hooks.UserPromptSubmit[] \| .hooks[] \| select(.type=="command") \| .command' <settings file>` should print the command. |
| Registered but still silent | `printf '%s' '{"prompt":"how should I price my consulting work?"}' \| bash <gate path>` should print the directive. If it prints nothing, check that `jq` is installed. |
| Answers got worse after installing | Run `grep '^model:' <skills dir>/best-minds-optimizer/SKILL.md`. A `model:` pin in the skill's frontmatter switches the model for the rest of the turn each time the skill fires, so the answer itself comes from that model. The installer warns about this. |
| It fires twice | The trigger is installed at two scopes. Run `--uninstall` at the scope you don't want. |
| Hook edits seem ignored | A running session may not pick up settings changes. Open `/hooks` or restart the session. |
