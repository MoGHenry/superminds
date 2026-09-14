# CLAUDE.md

This file provides guidance to Claude Code when working with Agent Skills in this repository.

## What This Repo Is

Superminds is a collection of **agent skills** (prompt-time plugins) for Claude Code, Cursor, and Codex. There build system, test suite are depend on **skill-creator** agent skills, and no compiled code — the repo Markdown skill definitions plus supporting infrastructure (hooks, eval workspaces, and a sub-project) and supportive scripts.

Skills are installed via `npx skills add https://github.com/MoGHenry/superminds --skill <name>`.

## Repository Layout

```
skills/                  # Source-of-truth skill definitions (6 first-party skills)
  <skill>/SKILL.md       # Skill entry point (YAML frontmatter + instructions)
  <skill>/references/    # On-demand reference files loaded by the skill
  <skill>/scripts/       # Shell scripts the skill runs (best-minds-setup, best-minds-drill)
.claude/skills/          # Third-party skills installed via skills-lock.json
```

## First-Party Skills

| Skill | Purpose | Key references |
|-------|---------|----------------|
| `best-minds-optimizer` | Pre-processing prompt optimizer. Triages into Skip/Polish/Clarify/Optimize lanes, selects a domain expert, rewrites prompt through their frameworks using 4-D Methodology. | `references/optimize.md`, `references/methodology.md`, `references/polish.md`, `references/clarify.md` |
| `best-minds-triage` | Forked small-model first pass. Returns one lane (skip/polish/clarify/optimize) so the session model only pays for prompts worth optimizing. Claude Code only — uses `context: fork`, `model:`, `background:`. | none |
| `4d-mind-analyst` | Dispatches 4 parallel analysis agents (User-Centric, Product, Topic Selection, Curriculum) then synthesizes results. | `references/user-centric.md`, `references/product.md`, `references/topic-selection.md`, `references/curriculum.md`, `references/synthesis.md` |
| `feature-list-mind` | Session continuity for long-running multi-session agent work. Manages `features.json`, session init/resume, incremental commits. | `references/init-protocol.md`, `references/session-resume.md`, `references/feature-schema.md`, `references/completion-protocol.md`, `references/failure-guards.md` |
| `best-minds-setup` | Slash command that installs, moves, or removes the best-minds-optimizer trigger (a `UserPromptSubmit` hook) at user or project scope. Replaces the retired `hooks/skill-directive/`. | `scripts/install-trigger.sh`, `scripts/best-minds-gate.sh` |
| `best-minds-drill` | Slash command that mines the user's own Claude Code transcripts, diagnoses their prompt-writing habits against the Spec/Verifier/Environment layers, writes an HTML lesson to `docs/learning/`, grades the prompt they write back, and tracks recurring problems in `~/.claude/best-minds-drill/`. | `references/diagnosis.md`, `references/lesson.md`, `references/grading.md`, `references/records.md`, `references/evidence.md`, `scripts/find-sessions.sh`, `scripts/extract-turns.sh` |

## Skill Structure Convention

Every skill follows the same pattern:
- `SKILL.md` — YAML frontmatter (`name`, `description`) + full instructions. The `description` field controls when the skill auto-triggers.
- `references/` — Detailed instruction files loaded on demand (progressive disclosure pattern). The skill's SKILL.md tells the agent when to read each reference file.
- `scripts/` — Shell scripts the skill runs (`best-minds-setup`, `best-minds-drill`). Always invoke them as `bash <path>`; the executable bit does not survive every install path.
- Command-style skills (`best-minds-setup`, `best-minds-drill`) set `disable-model-invocation: true`, so they run only when the user types the slash command.

## Working on Skills

- Invoke `skill-creator` Agent Skills
- Edit skills in `skills/<name>/SKILL.md` and `skills/<name>/references/`.

## README Files

Each first-party skill has a dedicated README in `readme/` (`README-best-minds-optimizer.md`, `README-4d-mind-analyst.md`, `README-feature-list-mind.md`) plus Chinese translations (`*-CN.md`). The main `README.md` is the project overview and the only README at the repo root; its Chinese translation is `readme/README-CN.md`. `best-minds-setup` has no separate README — it is covered in `README.md` and in its own `SKILL.md`.

## Agent skills

### Issue tracker

GitHub Issues on `MoGHenry/superminds`, via `gh` CLI. See `docs/agents/issue-tracker.md`.

### Domain docs

Single-context: one `CONTEXT.md` plus `docs/adr/` at repo root. See `docs/agents/domain.md`.
