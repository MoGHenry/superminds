---
name: feature-list-mind
description: >
  Session continuity protocol for long-running agent work across multiple
  context windows. Manages a JSON feature list with phases, dependency
  tracking, verification steps, and incremental commit discipline. Trigger
  this skill when: the user describes a project that will clearly take
  multiple sessions to build (e.g., "build me a full-stack app", "I want
  to create a SaaS platform"), asks to "set up a feature list" or
  "initialize a project", says "pick up where we left off" or "continue
  working on the project", asks "what's left to do" or "what features are
  remaining", wants to "mark this feature as done", needs to "track progress
  across sessions", or references long-running agent harness patterns. Also
  trigger when the user opens a project that already has a features.json
  file, even if they don't explicitly ask for tracking — the file's presence
  means this skill should activate in Resume Mode. Does NOT trigger on
  single-session tasks, quick bug fixes, file edits, or questions that
  don't involve multi-session project work.
---

# Feature List Mind

A session continuity protocol for long-running agent work. When a project spans multiple context windows, agents lose memory between sessions — leading to over-ambition (attempting everything at once), premature completion (declaring done too early), or repeated work. This skill solves that by establishing a JSON feature list as the single source of truth, a session init sequence that recovers state, and an incremental commit discipline that keeps progress auditable.

The core loop: **Resume → Pick Feature → Implement → Verify → Commit → Update Tracker → Commit Again.**

The core structure: **Phases → Features → Verification Steps.** Phases group features into delivery milestones (Foundation, MVP, Core, Polish). Features are individually completable units of work. Verification steps are the concrete test script for each feature.

## Two Modes

The skill operates in two modes, determined by whether `features.json` exists in the project root.

### Init Mode

When `features.json` does not exist, this is a new project. The goal is to expand the user's project description into a granular, testable feature list and establish the tracking infrastructure.

Read `references/init-protocol.md` for the full initialization sequence: gathering requirements, expanding into features, creating `PROGRESS.md`, making the initial git commit, and presenting the feature list for user review.

### Resume Mode

When `features.json` exists, this is a returning session. The goal is to recover state from the previous session, pick the next feature, implement it, and commit progress.

Read `references/session-resume.md` for the session init sequence: reading the feature list, checking git history, selecting the next feature by priority, and handling any uncommitted changes from a crashed session.

## Feature List as Single Source of Truth

The `features.json` file is the canonical tracker for all project work. Every feature, its status, verification steps, and dependencies live here. Key rules:

- **Never delete features.** Mark them as `passes`, `blocked`, or superseded — never remove them from the list.
- **Never edit passing tests' steps.** Verification steps are immutable after creation. If a feature's scope changes, create a new feature with the corrected steps and note the supersession.
- **Never track progress in comments, READMEs, or agent memory alone.** The JSON is the authority — everything else is a companion view.
- **One feature per session.** Complete and verify one feature before moving to the next. If a feature finishes early, pick the next one — but never rush multiple complex features in a single session.
- **Respect phase boundaries.** Complete the current phase before starting features in the next phase, unless the user explicitly approves phase-jumping.

Read `references/feature-schema.md` for the full JSON schema, phase structure, feature granularity guide, INVEST readiness criteria, verification step standards, and status transition rules.

## The Loop

Each session follows one cycle of the feature loop:

```
1. Resume    — Run session init sequence (pwd, read features.json, git log, git status)
2. Pick      — Select the highest-priority incomplete feature whose dependencies are met
3. Implement — Write the code for that one feature
4. Verify    — Run through every verification step end-to-end (not "the code looks right")
5. Commit    — Implementation commit: feat(F001): [description]
6. Update    — Set feature status to passes in features.json, update PROGRESS.md
7. Commit    — Progress commit: progress: F001 passing — [N]/[total] complete
```

Read `references/completion-protocol.md` for the full verification and commit protocol, including the double-commit pattern, session wrap-up, and handling verification failures.

## Failure Guards

Long-running agents fail in predictable ways. Read `references/failure-guards.md` for guards against:

- **Premature completion** — declaring the project done when features remain
- **Environmental instability** — the dev environment breaking between sessions
- **Scope creep** — discovering new work and expanding the current session
- **Test mutation** — editing verification steps to match broken implementations
- **Git amnesia** — forgetting to commit or committing everything in one massive dump

## Reference Files

| File | When to read | What it contains |
|------|-------------|-----------------|
| `references/init-protocol.md` | Init Mode | Requirements gathering, phase planning, feature expansion, PROGRESS.md creation, initial commit, user review gate |
| `references/session-resume.md` | Resume Mode | Session init sequence, phase-aware feature selection, handling uncommitted changes, intent announcement |
| `references/feature-schema.md` | Both modes | JSON schema with phases, feature granularity guide, INVEST readiness criteria, verification step standards, status transitions |
| `references/completion-protocol.md` | After implementing a feature | End-to-end verification, double-commit pattern, PROGRESS.md updates, session wrap-up, failure handling |
| `references/failure-guards.md` | When uncertain | Anti-patterns, premature completion guards, scope control, test immutability |

## Common Mistakes

| Mistake | Why it matters |
|---------|---------------|
| Attempting too many features per session | Context degradation causes regressions — one feature at a time is the ceiling |
| Marking features as passing without verification | The whole system depends on pass/fail being honest — an unverified "pass" cascades errors to downstream features |
| Editing verification steps to make them pass | Steps define the contract — changing the test instead of the code is the most dangerous failure mode |
| Skipping the session init sequence | Without reading progress first, you will redo work or break working features |
| Committing only at session end | Commit after each feature — a crash mid-session should lose at most one feature's worth of work |
| Using `git add .` or `git add -A` | Stage files explicitly by name to avoid committing unrelated changes or secrets |
| Declaring the project complete without checking features.json | Trust the JSON counts, not your memory — re-read and verify all features pass before reporting completion |
