# CLAUDE.md

This file provides guidance to Claude Code when working with Agent Skills in this repository.

## What This Repo Is

Superminds is a collection of **agent skills** (prompt-time plugins) for Claude Code, Cursor, and Codex. There build system, test suite are depend on **skill-creator** agent skills, and no compiled code — the repo Markdown skill definitions plus supporting infrastructure (hooks, eval workspaces, and a sub-project) and supportive scripts.

Skills are installed via `npx skills add https://github.com/MoGHenry/superminds --skill <name>`.

## Repository Layout

```
skills/                  # Source-of-truth skill definitions (3 first-party skills)
  <skill>/SKILL.md       # Skill entry point (YAML frontmatter + instructions)
  <skill>/references/    # On-demand reference files loaded by the skill
.claude/skills/          # Third-party skills installed via skills-lock.json
hooks/skill-directive/   # UserPromptSubmit hook that auto-invokes best-minds-optimizer
```

## First-Party Skills

| Skill | Purpose | Key references |
|-------|---------|----------------|
| `best-minds-optimizer` | Pre-processing prompt optimizer. Triages into Skip/Polish/Clarify/Optimize lanes, selects a domain expert, rewrites prompt through their frameworks using 4-D Methodology. | `references/optimize.md`, `references/methodology.md`, `references/polish.md`, `references/clarify.md` |
| `4d-mind-analyst` | Dispatches 4 parallel analysis agents (User-Centric, Product, Topic Selection, Curriculum) then synthesizes results. | `references/user-centric.md`, `references/product.md`, `references/topic-selection.md`, `references/curriculum.md`, `references/synthesis.md` |
| `feature-list-mind` | Session continuity for long-running multi-session agent work. Manages `features.json`, session init/resume, incremental commits. | `references/init-protocol.md`, `references/session-resume.md`, `references/feature-schema.md`, `references/completion-protocol.md`, `references/failure-guards.md` |

## Skill Structure Convention

Every skill follows the same pattern:
- `SKILL.md` — YAML frontmatter (`name`, `description`) + full instructions. The `description` field controls when the skill auto-triggers.
- `references/` — Detailed instruction files loaded on demand (progressive disclosure pattern). The skill's SKILL.md tells the agent when to read each reference file.

## Working on Skills

- Invoke `skill-creator` Agent Skills
- Edit skills in `skills/<name>/SKILL.md` and `skills/<name>/references/`.

## README Files

Each first-party skill has a dedicated README at the repo root (`README-best-minds-optimizer.md`, `README-4d-mind-analyst.md`, `README-feature-list-mind.md`) plus Chinese translations (`*-CN.md`). The main `README.md` is the project overview.

## Agent skills

### Issue tracker

GitHub Issues on `MoGHenry/superminds`, via `gh` CLI. See `docs/agents/issue-tracker.md`.

### Domain docs

Single-context: one `CONTEXT.md` plus `docs/adr/` at repo root. See `docs/agents/domain.md`.
