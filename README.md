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
- **[feature-list-mind](README-feature-list-mind.md)** — Session continuity protocol for long-running agent work. Manages a JSON feature list, session init sequence, incremental commit discipline, and failure guards to keep agents productive across multiple context windows. Based on Anthropic's [Effective Harnesses for Long-Running Agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents).

## How It Works

Superminds starts working the moment you ask a substantive question. The skills trigger automatically based on your input — you don't need to do anything special.

**Best Minds Optimizer** | [skills.sh/superminds/best-minds-optmizer](https://skills.sh/moghenry/superminds/best-minds-optimizer)

intercepts every prompt and runs a 4-lane triage:

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
