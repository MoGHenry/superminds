<div align="center">

# Superminds

English | [中文](https://github.com/MoGHenry/superminds/blob/main/README-CN.md) | [skills.sh/superminds](https://skills.sh/moghenry/superminds)

</div>

Every question you ask an LLM gets a generic answer. The same question, rewritten through Charlie Munger's mental models or analyzed from four independent perspectives simultaneously, gets a fundamentally different — and better — one.

Superminds is a set of agent skills that make your AI agent *think* before it answers. One skill rewrites your prompt through the world's best domain expert. Another analyzes your topic from four parallel perspectives — user-centric, product, cultural, and educational — then synthesizes them into a unified analysis. A third manages long-running agent work across multiple context windows using a feature list, session init protocol, and incremental commit discipline. Together, they turn any AI agent — coding assistant, research tool, or general-purpose chatbot — into a strategic thinking partner.

## Installation

### Claude Code

```bash
npx skills add https://github.com/MoGHenry/superminds --skill best-minds-optimizer
npx skills add https://github.com/MoGHenry/superminds --skill 4d-mind-analyst
npx skills add https://github.com/MoGHenry/superminds --skill feature-list-mind
```

#### Make Best Minds Optimizer fire on its own

Installing the skill is not enough by itself — Claude decides when to load it. To have it offered on every substantive prompt, install the trigger, a `UserPromptSubmit` hook:

```bash
npx skills add https://github.com/MoGHenry/superminds --skill best-minds-setup
```

Then run `/best-minds-setup` in Claude Code and choose a scope:

| Scope | Settings file | Applies to |
|-------|---------------|------------|
| `user` | `~/.claude/settings.json` | you, in every project |
| `project` | `<project>/.claude/settings.local.json` | you, in this project only |
| `project-shared` | `<project>/.claude/settings.json` | everyone working in the repo (committed) |

The trigger only speaks up for substantive prompts: 50+ characters, 10+ words, a question mark, or a phrase like "best minds". Short instructions such as "commit this" pass through untouched, so they cost nothing. `jq` is required. Remove it any time with `/best-minds-setup uninstall`.

#### Optional: keep the first pass cheap

`best-minds-triage` decides whether a prompt is worth optimizing at all. It runs in an isolated subagent on a small model and returns a single lane, so your session model only pays for the prompts that actually get optimized:

```bash
npx skills add https://github.com/MoGHenry/superminds --skill best-minds-triage
```

Claude Code only, since it relies on `context: fork`. Without it, `best-minds-optimizer` triages itself on the session model — which works fine and keeps the skill portable to Cursor and Codex.

Or install manually by copying the skill directories into your agent's skills folder:

[Github/superminds](https://github.com/MoGHenry/superminds)

| Agent | Project Path | Global Path |
|-------|-------------|-------------|
| Claude Code | `.claude/skills/` | `~/.claude/skills/` |
| Cursor | `.agents/skills/` | `~/.cursor/skills/` |
| Codex | `.agents/skills/` | `~/.codex/skills/` |

### Verify Installation

Start a new session and ask a substantive question (e.g., "How should I price my SaaS product?"). The agent should automatically invoke the Best Minds Optimizer. For 4D analysis, ask something like "Analyze the rise of AI coding agents from different angles."

## What's Inside

### Skills Library

**Thinking Enhancement**
- **[best-minds-optimizer](README-best-minds-optimizer.md)** — Prompt optimizer that identifies the world's top domain expert for your question, rewrites your prompt through their frameworks using a structured 4-D Methodology (Deconstruct → Diagnose → Develop → Deliver), and delivers a plain-English answer with a concrete next step. Handles four lanes: Skip, Polish, Clarify, and Optimize.
- **[4d-mind-analyst](README-4d-mind-analyst.md)** — Multi-perspective analysis engine that dispatches four parallel agents — User-Centric, Product, Topic Selection, and Curriculum thinking — then synthesizes their independent analyses into a unified tiered output.

**Agent Workflow**
- **[feature-list-mind](README-feature-list-mind.md)** — Human-AI collaborative session continuity protocol for long-running agent work. **This is not a fully automated pipeline** — it requires human oversight at every verification gate. The LLM implements and verifies, but only the human user holds the authority to mark features as complete. Manages a JSON feature list, session init sequence, incremental commit discipline, project test suite verification, and user notification gates. Based on Anthropic's [Effective Harnesses for Long-Running Agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents).

## How It Works

Superminds starts working the moment you ask a substantive question. The skills trigger automatically based on your input — you don't need to do anything special.

**Best Minds Optimizer** | [skills.sh/superminds/best-minds-optmizer](https://skills.sh/moghenry/superminds/best-minds-optimizer)

runs a 4-lane triage on the prompts it sees:

```
Input → Triage (Skip | Polish | Clarify | Optimize) → Expert-Framed Answer
```

- **Skip** — Mechanical tasks pass through untouched. No friction.
- **Polish** — User-authored text gets a quick wording pass. Voice preserved.
- **Clarify** — Ambiguous questions get targeted multiple-choice questions first.
- **Optimize** — Substantive questions get the full pipeline: Logic Mapping → Expert Selection → 4-D Methodology (Deconstruct → Diagnose → Develop → Deliver) → Plain-English Answer.

**4D Mind Analyst**  | [skills.sh/superminds/4d-mind-analyst](https://skills.sh/moghenry/superminds/4d-mind-analyst)

activates when you need multi-dimensional analysis:

```
Input → Perspective Menu → Parallel Agents → Synthesis → Tiered Output
```

Four independent agents analyze simultaneously, then a synthesis agent merges their insights — surfacing convergences, tensions, and blind spots that no single perspective could find alone.

**Feature List Mind** | [skills.sh/superminds/feature-list-mind](https://skills.sh/moghenry/superminds/feature-list-mind)

manages long-running agent work with human-in-the-loop verification:

```
Resume → Pick Feature → Implement → Verify (steps + test suite) → Commit → Inform User → Update (after authorization) → Commit Again
```

- **Human-AI collaborative** — The LLM implements and runs verification, but only the human user can authorize marking a feature as complete
- **LLM has READ-only access to `features.json`** — The agent reads the tracker for state but never edits status fields independently
- **Verification before notification** — Both feature-specific steps and the project test suite must pass before the user is informed

#### Required CLAUDE.md Setup

Feature List Mind requires a `CLAUDE.md` configuration in your project root to enforce the human-in-the-loop protocol. Add the following to your project's `CLAUDE.md`:

```markdown
## Project State Protocol

### 1. Mandatory Initialization
Before executing any planning, implementation, or debugging request, you MUST read
features.json and PROGRESS.md to establish the current project state.

### 2. Single Source of Truth
features.json is the definitive record of features, phases, and dependencies.
Do not rely on memory or implicit context. LLM only have the READ privilege
to features.json, no EDIT privilege.

### 3. Human-in-the-Loop Verification
You are prohibited from marking any feature as passes or updating completion
metrics independently. Only the human user holds the authority to verify a
feature and authorize a status change.

### 4. Dependency Enforcement
Prior to starting work on any feature, you must verify in features.json that
all of its listed depends_on features are marked as passes. If dependencies
are incomplete, halt and notify the user.
```

This configuration ensures the LLM cannot silently advance the project state. Every status transition requires explicit human authorization.

### How They Work Together

The skills are complementary:

| Scenario | Which skill fires | What happens |
|----------|------------------|-------------|
| "How should I price my freelance work?" | Best Minds Optimizer | Selects Blair Enns, rewrites through pricing frameworks, delivers expert-framed answer |
| "Analyze the remote work backlash" | 4D Mind Analyst | Four parallel agents examine from user, product, cultural, and educational angles |
| "What's really going on with junior dev roles disappearing?" | Both | Optimizer reframes the question; 4D Analyst runs full multi-perspective analysis |
| "Build me a full-stack chat app" | Feature List Mind | Expands into 50+ granular features, tracks progress across sessions |
| "Pick up where we left off" | Feature List Mind | Reads features.json, selects next priority feature, announces intent |
| "Read this file" / "commit this" | Neither (Skip) | Passes through untouched — no friction on mechanical tasks |

## The Core Patterns

| Pattern | How it's applied |
|---------|-----------------|
| Expert selection | Both skills identify concrete, named real-world experts — never "an expert in X" |
| Parallel agents | 4D Analyst runs all perspectives simultaneously for speed |
| Progressive disclosure | Only triage logic loads on every invocation — detailed instructions load on demand |
| Bilingual execution | Internal reasoning uses high-density expert terminology; user-facing output is clear and scannable |
| Tiered output | Executive summary for skimmers, full analysis for deep divers |
| Auto-triage | Skills know when to stay out of the way — mechanical tasks get zero friction |

## Philosophy

- **Expert-framed over generic** — A question through Charlie Munger's frameworks gets a fundamentally different answer than a vague prompt
- **Specific over abstract** — Named individuals, concrete frameworks, actionable next steps
- **Independent then synthesized** — Perspectives work in isolation first; the magic happens when contradictions reveal what no single lens could see
- **Know when to stay silent** — The best skill is one that adds zero friction when it's not needed

## Contributing

Skills live directly in this repository. To contribute:

1. Fork the repository
2. Create a branch for your skill or improvement
3. Follow the existing skill structure (`SKILL.md` + `references/` pattern)
4. Submit a PR

## License

GPL-3.0 License — see LICENSE file for details.

## Support

- **Issues**: https://github.com/MoGHenry/superminds/issues
- **Skills Directory**: [skills.sh/superminds](https://skills.sh/moghenry/superminds)
