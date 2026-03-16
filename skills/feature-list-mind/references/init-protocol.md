# Init Protocol

Setting up a project for multi-session agent work. This protocol runs once — when `features.json` does not exist in the project root.

## Step 1: Gather Project Description

Ask the user to describe what they want to build. Gather:

- **The overall goal** — What is this project? What problem does it solve?
- **The tech stack** — What languages, frameworks, and tools are involved?
- **Constraints** — Deadlines, existing code, platform requirements, accessibility needs
- **Definition of done** — What does "finished" look like? What must work for the user to consider this complete?

If the description is too vague to decompose into features, ask 2–3 targeted clarifying questions. Do not guess at requirements that would change the feature list significantly.

## Step 2: Expand into Features

Transform the project description into a `features.json` file. The expansion follows a systematic decomposition:

### Decomposition Process

1. **Define phases** — Break the project into delivery milestones: Foundation (scaffolding, environment), MVP (minimum usable product), Core (full requested functionality), Polish (edge cases, performance, UX). Adjust phase names and count to fit the project.
2. **Identify high-level capabilities** — What are the major things this project does? (e.g., "user authentication", "message sending", "search")
3. **Decompose each capability into individually testable features** — Each feature must be completable in a single session and have a clear pass/fail boundary. Run the INVEST readiness check (see `feature-schema.md`) on each feature.
4. **Assign each feature to a phase** — Infrastructure goes in Foundation. Core user flows go in MVP. Full functionality goes in Core. Refinements go in Polish.
5. **Write 3–7 concrete verification steps per feature** — These are the test script the agent will run after implementation
6. **Categorize each feature** — `functional`, `ui`, `integration`, `infrastructure`, or `polish`
7. **Assign priority** — `critical` (blocks other work), `high` (core), `medium` (important), `low` (nice-to-have)
8. **Map dependencies in both directions** — Fill both `depends_on` (what must pass first) and `blocks` (what this unblocks). This bidirectional mapping makes feature selection smarter.
9. **Order by phase, then by dependency** — Foundation features first, then MVP, then Core. Within each phase, features that others depend on come first.

### Expansion Target

Aim for granular coverage. A simple project might have 20–30 features. A complex full-stack application might have 100–200+. The number is not the goal — completeness is. Every user-visible behavior should be covered by at least one feature with verification steps.

### Expansion Example

User says: "Build me a chat application with real-time messaging."

**Wrong expansion (too coarse):**
- F001: Implement chat functionality
- F002: Add real-time messaging

**Right expansion (testable features):**
- F001: Project scaffolding — create project structure, install dependencies, verify dev server starts
- F002: Message input — user can type a message in a text field and submit with Enter key
- F003: Message display — submitted messages appear in the chat area in chronological order
- F004: Message persistence — messages survive a page refresh
- F005: Real-time delivery — messages appear on other connected clients within 2 seconds
- F006: New conversation — "New Chat" button creates a fresh conversation with empty state
- F007: Conversation list — sidebar shows all conversations, sorted by most recent activity
- F008: Conversation switching — clicking a conversation in the sidebar loads its messages
- ...and so on for every testable behavior.

## Step 3: Create PROGRESS.md

Create `PROGRESS.md` in the project root as a human-readable companion to `features.json`. Format:

```markdown
# Project Progress

**Project:** [name]
**Last updated:** [date]
**Session count:** 0
**Features:** 0/[total] passing (0.0%)

## Phase Status

| Phase | Status | Progress |
|-------|--------|----------|
| Foundation | not_started | 0/[n] |
| MVP | not_started | 0/[n] |
| Core | not_started | 0/[n] |
| Polish | not_started | 0/[n] |

**Current Phase:** Foundation

## Completed Features

(none yet)

## Current Focus

Ready to begin.

## Known Issues

(none)
```

This file serves two purposes: it gives a quick overview for humans reading the repository, and it provides the agent with narrative context that complements the structured JSON.

## Step 4: Create init.sh (If Applicable)

If the project requires environment setup (installing dependencies, starting servers, setting up databases), create an `init.sh` script that automates the process. The agent should be able to run `bash init.sh` at the start of any session to get a working environment.

Skip this step if the project is simple enough that no setup is needed, or if the user already has setup scripts in place.

## Step 5: Initial Git Commit

Stage `features.json` and `PROGRESS.md` (and `init.sh` if created). Commit with message:

```
init: set up feature tracking for [project name]
```

This baseline commit means every future session can `git log` to see the full history of progress.

## Step 6: Present the Feature List for Review

Before starting any implementation work, present the feature list to the user. Display:

- **Phase overview** — How many features in each phase, what each phase delivers
- Total feature count by category and by priority
- The full list with IDs, phases, descriptions, and dependencies
- The critical path — which features block the most downstream work
- Any assumptions made during expansion

Ask for confirmation or adjustments. The user may want to:
- Adjust phase boundaries (move features between phases)
- Reorder priorities
- Add features that were missed
- Remove features that are out of scope
- Re-scope features that are too coarse or too fine
- Adjust verification steps

**Never start implementation without user sign-off on the feature list.** This is the equivalent of the Review Gate in best-minds-optimizer — the feature list defines the contract for the entire project.
