# Session Resume

Picking up where the last session left off. This protocol runs at the start of every session when `features.json` already exists.

## The Session Init Sequence

Every resumed session begins with exactly these steps, in order:

1. **`pwd`** — Confirm the working directory is correct
2. **Read `features.json`** — Load the feature list and current statuses
3. **Read `PROGRESS.md`** — Get the human-readable context and any notes from the previous session
4. **`git log --oneline -20`** — See what was committed in recent sessions
5. **`git status`** — Check for any uncommitted changes from a crashed session
6. **Summarize** — State: "Phase [current_phase] ([name]): [N]/[phase_total] features passing. Overall: [N]/[total] ([completion_percentage]%). Last session completed: [feature]. Next priority: [feature]."

Do not skip any step. Do not start implementing before completing the full sequence. The summary ensures both the agent and the user are aligned on the current state.

## Feature Selection Priority

After the init sequence, pick the next feature to work on. Selection is phase-aware and follows strict priority:

1. **First:** Any feature with status `in_progress` — this means the previous session was interrupted mid-feature. Either complete it or, if the code is broken, revert and restart it.
2. **Second:** Within the `current_phase`, the highest-priority `not_started` feature whose `depends_on` features all have status `passes`. Priority order: `critical` → `high` → `medium` → `low`. Within the same priority, prefer the feature whose `blocks` array is longest (it unblocks the most downstream work). If still tied, pick the feature with the lowest ID.
3. **Third:** Any `blocked` feature whose blocker has been resolved (check if the `blocked_by` condition still holds).
4. **Phase gate:** If all features in the current phase have status `passes`, update the phase status to `complete`, advance `current_phase` to the next phase, and announce: "Phase [name] complete. Moving to Phase [next_name]." Then select from the new phase.
5. **Never:** Skip ahead to a feature in a later phase when the current phase has unfinished work, unless the user explicitly approves. Phase boundaries exist to prevent spreading work across too many areas at once.

## Handling Uncommitted Changes

If `git status` shows uncommitted changes at session start:

1. **Read the diff** — Understand what was in progress
2. **Check features.json** — Is there a feature marked `in_progress`? Do the changes relate to it?
3. **If changes look viable** — Continue from where the last session left off. The code may be close to complete.
4. **If changes look broken** — `git stash` them with a descriptive message (e.g., `git stash push -m "incomplete F007 from previous session"`). Note the stash in `PROGRESS.md` under Known Issues.
5. **Never blindly discard** — Uncommitted changes may represent significant work. Investigate before deciding.

## Environment Check

Before picking a feature, verify the environment is healthy:

- Run `init.sh` if it exists (or the project's equivalent setup command)
- Start the dev server and confirm it runs
- Spot-check 2–3 recently passing features — do they still work? (Not a full regression suite, just a quick sanity check)
- If the environment is broken, fix it first. If the fix is non-trivial, add it as a new `infrastructure` feature in `features.json` with `critical` priority.

## Announce Intent

Before starting work, state clearly:

> "Picking up **[feature ID]: [description]**. Verification steps I will complete:
> 1. [step 1]
> 2. [step 2]
> ...
> Starting implementation now."

This makes the agent's plan visible and auditable. The user can intervene if the selected feature is wrong or if priorities have changed since the last session.
