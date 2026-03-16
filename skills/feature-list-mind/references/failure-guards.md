# Failure Guards

Long-running agents fail in predictable ways. These guards prevent the most common failure modes identified in multi-session agent work.

## 1. Premature Completion

**The failure:** The agent declares the project "done" or "everything looks good" when many features are still `not_started` or unverified.

**Why it happens:** The agent loses track of scope across sessions. After implementing several features, it feels like the project is further along than it is.

**Guards:**
- Never report completion unless `summary.not_started === 0` AND `summary.in_progress === 0` AND `summary.blocked === 0`
- Before saying "the project is complete," re-read `features.json` and recount. Trust the JSON, not memory
- If any features are `blocked`, report the blockers explicitly — blocked features are not "done"
- The only valid completion statement: "All [N] features in features.json have status passes. The project is complete."

## 2. Environmental Instability

**The failure:** The development environment breaks between sessions — packages changed, ports in use, database state corrupted, build tooling updated.

**Why it happens:** Time passes between sessions. OS updates, other projects, or manual changes can alter the environment.

**Guards:**
- At session start, before picking a feature, run `init.sh` (if it exists) and verify the dev server starts
- Spot-check 2–3 recently passing features to confirm they still work
- If the environment is broken, fix it before working on new features
- If the fix is non-trivial, create a new `infrastructure` feature with `critical` priority — do not absorb environment work into unrelated features

## 3. Scope Creep Within a Session

**The failure:** While implementing one feature, the agent discovers 5 more things that "need" to happen and tries to do them all in the current session.

**Why it happens:** Implementation reveals missing pieces. The temptation is to fix everything now while the context is fresh.

**Guards:**
- If new work is discovered, add it as new features in `features.json` with appropriate priority and category. Use the spawned-ID convention (e.g., `F005a`, `F005b`) to show lineage
- Do not start working on discovered features in the current session unless they are blocking the current feature's verification steps
- One feature per session is the discipline. "I also noticed X" goes into `features.json` as a new entry, not into the current session's scope
- If the discovered work is truly blocking, note it in the current feature's `blocked_by` field and switch to the blocker

## 4. Test Mutation

**The failure:** The agent edits verification steps to match what the implementation actually does, rather than fixing the implementation to match the steps.

**Why it happens:** It is faster to change the test than to fix the code. The agent rationalizes that the original steps were "wrong" or "unrealistic."

**Guards:**
- Verification steps are immutable after creation. This rule has no exceptions for convenience
- If the steps are genuinely wrong (the feature spec changed, not the implementation), create a new feature with corrected steps and mark the old feature as superseded in its `notes` field. Do not silently edit steps
- When reviewing a session's work, check the git diff of `features.json` — if `steps` arrays were modified for passing features, that is a red flag

## 5. Git Amnesia

**The failure:** The agent forgets to commit, commits everything in one massive dump at session end, or uses `git add .` and accidentally stages secrets or unrelated files.

**Why it happens:** Committing feels like overhead when the agent is focused on implementation. Batch-committing at session end feels more efficient.

**Guards:**
- Follow the double-commit pattern: one implementation commit, one progress commit, per feature
- If more than one feature has been implemented since the last commit, stop and commit now
- Never use `git add .` or `git add -A`. Stage files explicitly by name
- At session wrap-up, run `git status` to confirm no uncommitted changes remain
- If a session ends with uncommitted work (user stops abruptly), the next session's init sequence will catch it via `git status`
