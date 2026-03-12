---
name: 4d-mind-analyst
description: Analyze any problem, phenomenon, or topic from four independent perspectives simultaneously using parallel agents. Use when the user wants multi-dimensional analysis, needs to understand a problem deeply before acting, or says "analyze this", "break this down", "what's really going on with X", "look at this from different angles", or any request for comprehensive analysis of a trend, product idea, social phenomenon, or complex situation. Even if the user doesn't explicitly ask for multi-perspective analysis, trigger this skill when the topic clearly benefits from examining human, product, cultural, and educational dimensions together.
---

# 4D Mind Analyst

Analyze any problem, phenomenon, or topic from four independent perspectives simultaneously. Each perspective runs as an independent parallel agent, then results are synthesized into a unified tiered output.

The power of this approach: each lens surfaces insights the others miss. A product thinker sees market gaps; a user-centric thinker feels the human pain; a topic analyst reads the cultural moment; a curriculum designer extracts what's teachable. Together, they produce analysis with depth no single perspective can match.

## Perspective Registry

| # | Perspective | What it does | Reference |
|---|------------|-------------|-----------|
| 1 | User-Centric Thinking | Simulates real stakeholders — their feelings, worries, and unstated expectations | `references/user-centric.md` |
| 2 | Product Thinking | Decomposes underlying needs, gap analysis, core solution hypothesis | `references/product.md` |
| 3 | Topic Selection Thinking | Captures collective emotions, cultural timing, discourse layers, topic lifecycle | `references/topic-selection.md` |
| 4 | Curriculum Thinking | Extracts teachable methodology, step decomposition, course architecture | `references/curriculum.md` |

To add a new perspective: create a reference file in `references/` and add a row to this table.

## Orchestration Flow

### Step 1: Receive Input

Accept the user's topic, problem, phenomenon, or question. This skill handles any analytical input — a specific problem statement, a cultural trend, a product idea, a social phenomenon, or a feature request.

### Step 2: Present the Perspective Menu

Show the user the four available perspectives and ask which to run:

```
Which perspectives would you like to analyze this from?

[1] User-Centric Thinking — stakeholder empathy & persona simulation
[2] Product Thinking — need decomposition & solution hypothesis
[3] Topic Selection Thinking — cultural resonance & emotional lifecycle
[4] Curriculum Thinking — teachable methodology & course design

Default: all four. You can pick a subset (e.g., "1,3" or "just product and curriculum").
You can also specify an output language (default: matches your input language).
```

If the user has already specified perspectives or said "all," skip the menu and proceed.

### Step 3: Dispatch Parallel Agents

For each selected perspective, dispatch one independent Agent. Each agent:

1. Reads its reference file (see the registry above)
2. Receives the user's original input verbatim
3. Analyzes independently — no cross-agent communication
4. Returns its free-form analysis

**Agent prompt template** (adapt for each perspective):

```
You are the [Perspective Name] analyst in a multi-perspective analysis framework.

Read the reference file at `references/[perspective].md` for your detailed instructions.

Analyze the following topic through your perspective's lens:

---
[User's original input]
---

Language: [user-specified language, or "match the input language"]

Follow the instructions in your reference file. Write in free-form prose — be sharp, specific, and insightful. Identify the most relevant real-world expert for this specific topic (a named individual, never a generic role) and apply their frameworks.

Return only your analysis. Do not reference other perspectives or attempt synthesis.
```

Dispatch all selected perspective agents in parallel using the Agent tool.

### Step 4: Synthesize

After all perspective agents return, dispatch one more agent that reads `references/synthesis.md` and all the collected analyses. This agent produces the final tiered output:

1. **Executive Summary** — the cross-perspective insight in 3-5 sentences
2. **Individual Analyses** — each perspective's full analysis with a "Key Insight" label
3. **Cross-Cutting Synthesis** — convergences, tensions, blind spots, unexpected connections
4. **Next Steps** — 3-5 prioritized actions tied to specific perspectives

### Step 5: Present to User

Deliver the synthesized output. The format should be scannable — a busy person reads the executive summary and next steps; a deep thinker reads the full analyses and synthesis.

## Key Principles

**Specific over generic.** Every perspective must identify concrete, named experts and specific archetypes — never "an expert in X" or "users." This is the single most important pattern borrowed from best-minds-optimizer. A named individual's frameworks produce sharper analysis than a generic role ever could.

**Independent then synthesized.** The perspectives must work in isolation first. The magic happens in synthesis — when contradictions and convergences across independent analyses reveal what no single lens could see alone.

**Calibrate depth to stakes.** A casual question about a meme gets lighter treatment than a strategic analysis of a market shift. Match the weight of the analysis to the weight of the topic.

**Free-form over rigid templates.** Each perspective writes naturally in whatever structure best serves its analysis. The synthesis agent handles consistency. Forcing all perspectives into the same template flattens the diversity that makes this approach valuable.

**Language flexibility.** Propagate the user's language preference to all agents and the synthesis. Default to matching the input language.
