# Feature Schema

The JSON format for feature tracking across sessions. `features.json` lives in the project root for discoverability — an agent running `ls` at session start immediately sees it.

## Schema

```json
{
  "project": {
    "name": "string — project name",
    "description": "string — one-paragraph project description",
    "created": "ISO 8601 date (e.g., 2025-11-26)",
    "last_updated": "ISO 8601 date"
  },
  "phases": [
    {
      "id": "string — e.g., phase-0, phase-1",
      "name": "string — human-readable name (e.g., Foundation, MVP, Core, Polish)",
      "description": "string — what this phase delivers",
      "status": "not_started | in_progress | complete"
    }
  ],
  "current_phase": "string — ID of the active phase (e.g., phase-1)",
  "features": [
    {
      "id": "string — unique identifier (e.g., F001)",
      "phase": "string — phase ID this feature belongs to (e.g., phase-0)",
      "category": "functional | ui | integration | infrastructure | polish",
      "priority": "critical | high | medium | low",
      "description": "string — what this feature does, in one sentence",
      "depends_on": ["array of feature IDs this depends on, or empty array"],
      "blocks": ["array of feature IDs this unblocks when completed, or empty array"],
      "steps": [
        "string — each step is a concrete, verifiable action"
      ],
      "status": "not_started | in_progress | passes | blocked",
      "blocked_by": "string | null — reason if blocked, null otherwise",
      "session_completed": "number | null — session number when completed",
      "notes": "string | null — context from the agent about this feature"
    }
  ],
  "session_count": 0,
  "summary": {
    "total": 0,
    "passing": 0,
    "in_progress": 0,
    "blocked": 0,
    "not_started": 0,
    "completion_percentage": 0.0,
    "by_phase": {
      "phase-0": { "total": 0, "passing": 0 },
      "phase-1": { "total": 0, "passing": 0 }
    }
  }
}
```

## Phases

Phases group features into delivery milestones. They create natural scope gates — a reason to pause, review progress with the user, and confirm the next phase before continuing.

| Phase | Typical content | When it's done |
|-------|----------------|----------------|
| `phase-0` Foundation | Project scaffolding, environment setup, CI, database schema | The project runs and the dev environment is stable |
| `phase-1` MVP | The minimum set of features that makes the project usable | A user can complete the core workflow end-to-end |
| `phase-2` Core | Full functionality the user explicitly requested | All requested features work and are verified |
| `phase-3` Polish | Error handling, edge cases, performance, UI refinement | The project is production-ready |

These are defaults — adjust phase names and count to fit the project. A small project might have 2 phases; a complex one might have 5.

**Phase status rollup:** A phase is `complete` only when every feature in that phase has status `passes`. Update `current_phase` to the next phase when this happens. A phase is `in_progress` when at least one feature in it is `in_progress` or `passes` but not all are `passes`.

## Feature ID Convention

Use `F001`, `F002`, etc. for sequential features. For features discovered during implementation, use `F001a`, `F001b` to show they were spawned from work on `F001`. This preserves insertion order while showing lineage.

## The `blocks` Field

The `blocks` field is the inverse of `depends_on` — it lists which features are unblocked when this feature passes. Maintaining both directions makes feature selection smarter: when choosing between two features of equal priority, pick the one that `blocks` more downstream features. This keeps the critical path moving.

Example: If F001 has `"blocks": ["F002", "F003", "F004"]` and F006 has `"blocks": []`, always pick F001 first — it unblocks three features.

### Bidirectional Consistency Rule

`depends_on` and `blocks` must always be kept in sync as logical inverses. **Every edge in the dependency graph must appear in both directions.** Specifically:

- If feature B lists A in its `depends_on`, then feature A **must** list B in its `blocks`.
- If feature A lists B in its `blocks`, then feature B **must** list A in its `depends_on`.

**When adding or modifying a dependency, always update both sides in the same operation.** Never write one side and assume the other will be filled in later.

Consistency check — after generating or modifying the feature list, verify: for every feature X, for every ID in `X.depends_on`, that ID's `blocks` array contains X's ID. And vice versa: for every ID in `X.blocks`, that ID's `depends_on` array contains X's ID. If any mismatch is found, fix it immediately.

## Categories

| Category | When to use | Examples |
|----------|-------------|----------|
| `functional` | Core behavior the user expects | User can send a message; search returns results |
| `ui` | Visual and interaction design | Responsive layout; dark mode toggle |
| `integration` | Connecting to external systems | OAuth login; webhook delivery |
| `infrastructure` | Setup, tooling, deployment | CI pipeline; database migration |
| `polish` | Refinement of existing features | Animation smoothing; error message copy |

## Priority Levels

| Priority | Meaning | Selection rule |
|----------|---------|----------------|
| `critical` | Blocks other features or the project cannot function without it | Always picked first |
| `high` | Core functionality the user explicitly requested | Picked after all critical features pass |
| `medium` | Important but not blocking and not explicitly requested | Picked after high-priority features pass |
| `low` | Nice-to-have, polish, or speculative | Picked only when no higher-priority features remain |

## Feature Granularity Guide

Getting the right feature size is the most important part of the expansion step. Each feature must be completable and verifiable in a single session.

**Too coarse:**
> "Implement user authentication"

This involves registration, login, session management, password reset — each is its own feature. An agent attempting this in one session will either run out of context or leave features undocumented.

**Right size:**
> "User can register with email and password; registration creates an account and redirects to the dashboard"

Completable in one session. Has concrete verification steps. Clear pass/fail boundary.

**Too fine:**
> "The login button has a hover state"

This is a step within a UI feature, not a standalone feature. It does not merit its own entry in `features.json`.

**Rule of thumb:** If it takes fewer than 3 verification steps, it is probably a step within a larger feature. If it takes more than 7 verification steps, it is probably two features.

## INVEST Readiness Check

Before adding a feature to the list, verify it meets INVEST criteria. This prevents features that are too vague, too large, or too entangled to complete in one session.

| Criterion | Question | Red flag if no |
|-----------|----------|----------------|
| **I**ndependent | Can this be built without waiting for unfinished features? | Add the dependency to `depends_on` or reorder |
| **N**egotiable | Are the details clear but not over-specified? | Too rigid → can't adapt; too vague → can't verify |
| **V**aluable | Does completing this deliver visible progress? | If not, it might be a step inside another feature |
| **E**stimable | Can you roughly gauge the effort? | If not, decompose further — unknowns hide complexity |
| **S**mall | Fits in one session? | If more than 7 verification steps, split it |
| **T**estable | Are the verification steps concrete and observable? | Vague steps like "make sure it works" are not testable |

Not every feature will score perfectly on all six — infrastructure features are rarely "Valuable" in a user-visible sense. The check is a guide, not a gate. But if a feature fails 3+ criteria, it needs rework before entering the list.

## Writing Good Verification Steps

Each step must be:

- **Observable** — Not "ensure the code is clean" but "run the linter and confirm zero errors"
- **Ordered** — Steps form a test script that runs in sequence
- **Complete** — If all steps pass, the feature works; no implicit or assumed steps
- **Stable** — Steps do not change after creation; if the feature scope changes, create a new feature

**Good example:**
```json
{
  "id": "F003",
  "description": "New chat button creates a fresh conversation",
  "steps": [
    "Navigate to the main interface",
    "Click the 'New Chat' button",
    "Verify a new conversation is created with an empty message area",
    "Check that the chat area shows a welcome state or placeholder",
    "Verify the new conversation appears in the sidebar list"
  ]
}
```

**Bad example:**
```json
{
  "id": "F003",
  "description": "New chat button works",
  "steps": [
    "Test the new chat button",
    "Make sure it works correctly"
  ]
}
```

## Status Transitions

```
not_started ──→ in_progress ──→ passes
                            └──→ blocked (with reason in blocked_by)

blocked ──→ in_progress (when blocker is resolved)
```

The `passes` status is **terminal**. A passing feature never reverts to `in_progress`. If a regression breaks a passing feature, create a new bug-fix feature (e.g., `F003a: Fix regression in new chat button`) that references the original. This creates an auditable record of what broke and when.

## Summary Field

The `summary` object is a denormalized count that must be kept in sync with the `features` array. After every status change:

1. Recount all features and update `total`, `passing`, `in_progress`, `blocked`, `not_started`
2. Recalculate `completion_percentage`: `(passing / total) * 100`, rounded to one decimal
3. Update `by_phase` counts for each phase
4. Check phase rollup: if all features in a phase now have status `passes`, set that phase's status to `complete` and advance `current_phase`

The `by_phase` breakdown lets the agent quickly report: "Phase 1 (MVP): 8/12 features passing. Phase 2 (Core): 0/15 started." This is more useful than a flat count for large projects.
