# Completion Protocol

Verifying and committing a feature after implementation. This protocol runs after the code for a feature is written.

## Verification Before Marking as Passing

After implementing a feature, run through every verification step in its `steps` array. Prefer end-to-end verification over code review:

- **UI features** — Navigate to the page, perform the actions described in the steps, visually confirm the result. Use browser automation (e.g., Puppeteer MCP) when available.
- **Backend features** — Make the actual API calls, check the response status and body, verify side effects (database writes, file changes).
- **Data features** — Verify data persists across page refreshes, survives server restarts, and is retrievable through the expected interfaces.
- **Infrastructure features** — Run the build, start the server, confirm the CI pipeline passes.

**Do not mark a feature as passing based on "the code looks right."** Run the steps. If a step cannot be verified automatically, note the limitation but still attempt manual verification.

### Known Limitation

Some verification steps may involve browser-native elements (alert modals, file dialogs, print views) that browser automation tools cannot interact with. When this happens:

- Note the limitation in the feature's `notes` field
- Verify everything that can be verified automatically
- Describe what manual verification would look like for the remaining steps
- Mark the feature as `passes` only if all automatable steps pass and the remaining steps are clearly correct from code inspection

## The Double-Commit Pattern

Two separate git commits per feature. This separation makes git history more useful and reverts safer.

### Commit 1: Implementation

After the code is written and verified, commit only the source code changes:

```
git add [specific files]
git commit -m "feat(F003): new chat button creates fresh conversation"
```

Commit message format: `feat([ID]): [description in lowercase]`

### Commit 2: Progress

After updating `features.json` and `PROGRESS.md`, commit only the tracking files:

```
git add features.json PROGRESS.md
git commit -m "progress: F003 passing — 3/47 complete"
```

Commit message format: `progress: [ID] passing — [N]/[total] complete`

### Why Two Commits

- **Revert safety** — If a future session needs to revert tracking without reverting code (or vice versa), the separation makes it clean
- **Readable history** — `git log` becomes a progress diary: implementation commits show what changed, progress commits show the state
- **Bisect-friendly** — `git bisect` can isolate whether a regression came from implementation or tracking

## Updating PROGRESS.md

After each feature completion, update `PROGRESS.md`:

1. Move the feature description to the **Completed Features** section with its ID
2. Update the counts: `Features: [N]/[total] passing`
3. Update **Current Focus** to the next priority feature
4. Increment the session count if this is the first feature completed in this session
5. Add any discovered issues, environment notes, or scope changes to **Known Issues**

## Session Wrap-Up

At the end of each session (or when the user indicates they are stopping):

1. **Ensure all changes are committed** — No uncommitted work should remain. If a feature is mid-implementation, commit what exists and leave the feature as `in_progress` with a note.
2. **Update PROGRESS.md** with a brief session summary: what was completed, what was attempted, what the next session should start with.
3. **State the handoff** — "Next session: pick up [feature ID] ([description])."

## Handling Verification Failure

If a feature's verification steps fail after implementation:

1. **Do not mark it as passing** — Leave it as `in_progress`
2. **If the fix is small** — Fix the issue and re-verify in the same session
3. **If the fix is complex** — Add a note to the feature explaining what failed and what was tried. The next session will pick it up as `in_progress`
4. **Never edit the verification steps** to match the current (broken) behavior. The steps define what "working" means — if the code does not match the steps, the code is wrong
5. **If the steps themselves are genuinely wrong** (the feature spec changed, not just the implementation), create a new feature with corrected steps and mark the old one as superseded in its `notes` field
