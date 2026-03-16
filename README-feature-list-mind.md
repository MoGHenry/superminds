<div align="center">

# Feature List Mind

English | [中文](https://github.com/MoGHenry/superminds/blob/main/README-feature-list-mind-CN.md) | [skills.sh](https://skills.sh/moghenry/superminds/feature-list-mind)

</div>

Agents working on large projects across multiple context windows lose memory between sessions. They either try to do everything at once (over-ambition) or declare the project finished when it isn't (premature completion). Feature List Mind solves this by establishing a JSON feature list as the single source of truth, a session init protocol that recovers state, and an incremental commit discipline.

Based on patterns from Anthropic's research on [Effective Harnesses for Long-Running Agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents).

## How It Works

The skill has two modes:

**Init Mode** — When starting a new project, it expands your description into a granular, testable feature list (`features.json`) organized into phases (Foundation, MVP, Core, Polish). It creates a progress file, makes the initial git commit, and presents the full feature list for your review before any implementation begins.

**Resume Mode** — When returning to an existing project (or when `features.json` already exists), it runs a session init sequence: reads the feature list, checks git history, reports phase progress, selects the next highest-priority feature using critical-path awareness, and announces intent before starting.

```
Session Start → Read features.json → Report Phase Progress → Pick Next Feature → Implement → Verify → Commit → Update Tracker → Commit Again
```

## Before / After

**Without Feature List Mind:**
```
Session 1: Agent builds login page, navigation, and starts on the dashboard
Session 2: Agent sees some code, adds a few more features, declares "looks good!"
Session 3: Agent rebuilds parts of session 1 because it doesn't remember what was done
Result: Half-built project with no way to track what works and what doesn't
```

**With Feature List Mind:**
```
Session 1: Agent creates features.json with 47 features across 4 phases, implements F001 (scaffolding)
Session 2: Agent reads features.json → "Phase 1 (MVP): 2/12 passing, 42.5% overall" → picks F003 → verifies → commits
Session 3: Agent reads features.json → "Phase 1 (MVP): 5/12 passing" → picks F006 (blocks 3 others) → verifies → commits
Result: Steady, auditable progress with every feature verified, committed, and phase-tracked
```

## The Feature List

Features are organized into **phases** (delivery milestones) and tracked with bidirectional dependencies:

```json
{
  "phases": [
    { "id": "phase-0", "name": "Foundation", "status": "complete" },
    { "id": "phase-1", "name": "MVP", "status": "in_progress" }
  ],
  "current_phase": "phase-1",
  "features": [
    {
      "id": "F003",
      "phase": "phase-1",
      "category": "functional",
      "priority": "high",
      "description": "New chat button creates a fresh conversation",
      "depends_on": ["F001"],
      "blocks": ["F007", "F008"],
      "steps": [
        "Navigate to the main interface",
        "Click the 'New Chat' button",
        "Verify a new conversation is created with an empty message area",
        "Check that the chat area shows a welcome state",
        "Verify the new conversation appears in the sidebar list"
      ],
      "status": "not_started"
    }
  ],
  "summary": {
    "total": 47,
    "passing": 5,
    "completion_percentage": 10.6,
    "by_phase": {
      "phase-0": { "total": 4, "passing": 4 },
      "phase-1": { "total": 12, "passing": 1 }
    }
  }
}
```

## Key Principles

- **Phases before features** — Work is organized into delivery milestones (Foundation → MVP → Core → Polish); complete the current phase before starting the next
- **One feature per session** — Complete and verify one feature before moving to the next
- **Critical path first** — When choosing between equal-priority features, pick the one that unblocks the most downstream work
- **INVEST readiness** — Every feature is checked for Independence, Negotiability, Value, Estimability, Smallness, and Testability before entering the list
- **Verification steps are immutable** — Never edit tests to match broken code; fix the code
- **Double-commit pattern** — One commit for code, one commit for tracking updates
- **Trust the JSON, not memory** — Always re-read `features.json` before reporting progress
- **Never delete features** — Mark them as passing, blocked, or superseded

## Installation

### Claude Code

```bash
npx skills add https://github.com/MoGHenry/superminds --skill feature-list-mind
```

Or copy the `skills/feature-list-mind/` directory into your agent's skills folder:

| Agent | Project Path | Global Path |
|-------|-------------|-------------|
| Claude Code | `.claude/skills/` | `~/.claude/skills/` |
| Cursor | `.agents/skills/` | `~/.cursor/skills/` |
| Codex | `.agents/skills/` | `~/.codex/skills/` |

## What's Inside

```
skills/feature-list-mind/
├── SKILL.md                     — Core skill: two modes, the loop, common mistakes
└── references/
    ├── init-protocol.md         — Phase planning, feature expansion, INVEST checks, user review gate
    ├── session-resume.md        — Session init sequence, phase-aware selection, critical path, state recovery
    ├── feature-schema.md        — JSON schema with phases, INVEST criteria, granularity guide, status transitions
    ├── completion-protocol.md   — End-to-end verification, double-commit, session wrap-up
    └── failure-guards.md        — Guards against premature completion, scope creep, test mutation
```
