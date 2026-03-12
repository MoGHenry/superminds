# 4D Mind Analyst

An agent skill that analyzes any problem, phenomenon, or topic from four independent perspectives simultaneously using parallel agents. Inspired by Edward de Bono's parallel thinking methodology.

## How It Works

Each perspective runs as an independent parallel agent, then results are synthesized into a unified tiered output. The power of this approach: each lens surfaces insights the others miss.

```
Input → Perspective Menu → Parallel Agents → Synthesis → Tiered Output
```

1. Receive the user's topic, problem, or phenomenon
2. Present the perspective menu (or run all four by default)
3. Dispatch one parallel agent per selected perspective
4. Collect all results and synthesize into a unified analysis
5. Deliver the final tiered output

## Perspectives

### 1. User-Centric Thinking

Simulates the person or group most affected by the topic. Surfaces true feelings, worries, and unstated expectations through specific persona simulation.

**Use when:** you need to understand the human side — who is affected, what they really feel, and what they won't say publicly.

### 2. Product Thinking

Decomposes the underlying need, analyzes why existing solutions fail, and hypothesizes what the ideal solution looks like.

**Use when:** you need to understand the problem-solution fit — what's the real need, what's been tried, and what would 10x better look like.

### 3. Topic Selection Thinking

Analyzes the collective emotional resonance of the topic — why it captures attention, what nerve it touches, and how long its relevance will last.

**Use when:** you need to read the cultural moment — why this matters now, who cares most, and whether it's a flash or a movement.

### 4. Curriculum Thinking

Extracts teachable methodology — replicable patterns, step decomposition, beginner obstacles, and course architecture.

**Use when:** you need to make the implicit explicit — what's teachable here, what's the learning path, and where do beginners get stuck.

## Installation

```bash
npx skills add https://github.com/moghenry/4d-mind-analyst --skill 4d-mind-analyst
```

Or install manually by copying the skill directory into your agent's skills folder:

| Agent | Project Path | Global Path |
|-------|-------------|-------------|
| Claude Code | `.claude/skills/` | `~/.claude/skills/` |
| Cursor | `.agents/skills/` | `~/.cursor/skills/` |
| Codex | `.agents/skills/` | `~/.codex/skills/` |

## Usage

Trigger the skill by asking for multi-dimensional analysis:

```
"Analyze the rise of AI coding agents"

"Break down the remote work backlash — what's really going on?"

"Look at this from different angles: why are junior developer roles disappearing?"

"What's really going on with the creator economy burnout trend?"
```

You can also select specific perspectives:

```
"Analyze X using just product and user-centric thinking"

"Run perspectives 1 and 3 on this topic"
```

### Output Format

The synthesized output follows a tiered structure:

| Section | What it contains | Who it's for |
|---------|-----------------|-------------|
| **Executive Summary** | The cross-perspective insight in 3-5 sentences | Busy decision-makers |
| **Individual Analyses** | Each perspective's full analysis with a "Key Insight" label | Deep thinkers who want the full picture |
| **Cross-Cutting Synthesis** | Convergences, tensions, blind spots, unexpected connections | Strategists looking for non-obvious insights |
| **Next Steps** | 3-5 prioritized actions tied to specific perspectives | Anyone who needs to act on the analysis |

## Skill Structure

```
4d-mind-analyst/
├── SKILL.md                    # Orchestrator — dispatch logic & perspective registry
├── references/
│   ├── user-centric.md         # Perspective 1: stakeholder empathy & persona simulation
│   ├── product.md              # Perspective 2: need decomposition & solution hypothesis
│   ├── topic-selection.md      # Perspective 3: cultural resonance & emotional lifecycle
│   ├── curriculum.md           # Perspective 4: teachable methodology & course design
│   └── synthesis.md            # Merge logic for combining all perspectives
├── docs/
│   └── plan.md                 # Implementation plan & design decisions
└── README.md
```

## Key Design Principles

- **Specific over generic** — every perspective identifies concrete, named experts and specific archetypes, never "an expert in X" or "users"
- **Independent then synthesized** — perspectives work in isolation first; the magic happens when contradictions and convergences reveal what no single lens could see
- **Calibrate depth to stakes** — a casual question gets lighter treatment than a strategic market analysis
- **Free-form over rigid templates** — each perspective writes naturally in whatever structure best serves its analysis
- **Language flexibility** — output language matches your input language, or specify one explicitly

## Adding New Perspectives

The skill is designed to scale. To add a new perspective:

1. Create `references/new-perspective.md` following the existing pattern
2. Add one row to the perspective registry table in `SKILL.md`

No other files need to change.

## Key Patterns

| Pattern | How it's applied |
|---------|-----------------|
| Expert selection | Each perspective identifies the real-world expert most relevant to the specific input |
| Parallel agents | All perspectives run simultaneously for speed |
| Tiered output | Executive summary for skimmers, full analysis for deep divers |
| Bilingual execution | Internal reasoning can be dense; user-facing output is clear and scannable |
| Reference file architecture | `SKILL.md` orchestrates, detailed instructions live in `references/` |

## Related

- [Agent Skills Specification](https://agentskills.io)
- [Skills Directory](https://skills.sh)
- [Claude Code Skills Documentation](https://code.claude.com/docs/en/skills)

## License

GPL-3.0 license
