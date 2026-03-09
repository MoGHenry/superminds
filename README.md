# Best Minds — Prompt Optimizer

Every question you ask an LLM gets a generic answer. The same question, rewritten through Charlie Munger's mental models or Blair Enns' pricing frameworks, gets a fundamentally different — and better — one.

This agent skill does the rewriting automatically. You ask a question, it identifies the world's best expert for your specific problem, rewrites your prompt through their frameworks, and delivers the answer in plain English with a concrete next step.

## Before and After

### Pricing Strategy

**You type:** *"I'm thinking about raising prices for my freelance design work but I'm scared of losing clients"*

**Without this skill** — You get blog-post advice: "raise incrementally", "be confident." No frameworks, no reframing.

**With this skill** — Selects **Blair Enns** (author of *Pricing Creativity*). Rewrites your question into 5 diagnostic sub-questions, then delivers:

> **The fear is almost always bigger than the risk.** If you raise prices 30% and lose 20% of clients, you're ahead — fewer clients, more revenue, less management overhead. The clients you lose at higher prices are the ones who haggle on scope, pay late, and drain your energy. Raising prices is a filter, not a risk.

Includes the attrition math, a client segmentation framework (who to raise first), exact language to use in the conversation, and ends with: *"List your top 5 clients — which one would you actually lose at 25% higher?"*

### Hiring Decisions

**You type:** *"We're a 15-person startup that just raised Series A. Should we hire a VP of Engineering or promote our senior engineer who's been with us since day one?"*

**Without this skill** — A balanced pros-and-cons list. Reasonable but doesn't reframe the decision.

**With this skill** — Selects **Ben Horowitz** (*The Hard Thing About Hard Things*). Reframes the entire question:

> **This isn't about loyalty vs. capability. It's about one testable threshold: has she made other engineers better, or is she still the person who fixes the hardest bugs herself?** Managing 3 people is IC-plus. Managing 20+ requires a fundamentally different skill.

Surfaces a third option most founders miss (90-day eval with executive coaching), warns against the worst outcome ("promoting her into an ambiguous VP title while simultaneously recruiting externally"), and gives the next step: *"Have a direct conversation with her this week — tell her what the VP role requires at Series A scale and ask how she'd approach it."*

### Trivial Tasks

**You type:** *"Read the package.json file in this directory"*

**With this skill** — Just reads the file. No expert, no rewrite, no friction. The skill knows when to stay out of the way.

## How It Works

The skill runs a 5-step pipeline on every substantive prompt:

```
Your question
    │
    ▼
┌─────────────────────────────────┐
│  1. TRIAGE                      │
│  Skip (trivial) / Clarify       │
│  (ambiguous) / Optimize (clear) │
└──────────────┬──────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│  2. LOGIC MAPPING               │
│  Classify the problem shape:    │
│  Bottleneck, Resource,          │
│  Direction, Execution,          │
│  Tradeoff, or Diagnosis         │
└──────────────┬──────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│  3. EXPERT SELECTION            │
│  Pick a specific named person   │
│  (never "a marketing expert")   │
│  Extract their mental models    │
│  and success metrics            │
└──────────────┬──────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│  4. PROMPT REWRITE              │
│  High-density technical prompt  │
│  using expert's frameworks,     │
│  vocabulary, and blind spots    │
└──────────────┬──────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│  5. PLAIN-ENGLISH ANSWER        │
│  3-5 key points, scannable,     │
│  jargon-free, with a concrete   │
│  "Next step" at the end         │
└─────────────────────────────────┘
```

**Follow-ups skip the pipeline.** Asking "tell me more about point 3" goes deeper in the same expert's framework without re-running everything.

**Ambiguous prompts get clarification first** — via multiple-choice questions so you can reply with a letter instead of typing paragraphs.

## What Makes This Different

**Logic Mapping** — Before picking an expert, the skill classifies your problem's structural shape. A pricing question might look like a "Resource" problem (how to allocate a scarce thing) but actually be a "Direction" problem (which path to take). The classification determines which reasoning framework applies:

| Problem Shape | Framework Applied |
|---------------|-------------------|
| Bottleneck | Theory of Constraints |
| Resource | Opportunity Cost / Capital Allocation |
| Direction | First Principles / Inversion |
| Execution | Process Design / Decomposition |
| Tradeoff | Decision Matrix / Weighted Criteria |
| Diagnosis | Root Cause Analysis / 5 Whys |

**Bilingual Execution** — The optimized prompt uses high-density expert terminology to maximize the LLM's reasoning quality. The answer you read uses plain English. The technical language drives better thinking internally; the clear language is what you actually see.

**Expert Panels** — When a question spans multiple domains (e.g., "How should I price and present my SaaS landing page for conversions?"), the skill selects two complementary experts and synthesizes their frameworks into one coherent answer.

## Output Format

```
Expert: Blair Enns — author of Pricing Creativity
Logic Structure: Tradeoff / Competing Goods
Key Metrics: Average deal size, Client retention rate, Revenue per client

Optimized prompt:
> [High-density technical prompt the LLM reasons over]

---

[Plain-English answer you actually read]

Next step: [One concrete action you can take right now]
```

## Quality Benchmarks

We tested the current skill against its previous version across 3 eval cases:

| Eval | Current Skill <br>  (commit: d667f71) | Previous Version <br> (commit: ab70006) |
|------|:---:|:---:|
| Business pricing strategy | 9/10 | 8/10 |
| Trivial task (should skip) | 9/10 | 7/10 |
| Org scaling / hiring decision | 9.5/10 | 9/10 |
| **Average** | **9.2** | **8.0** |

Key quality differences:
- Current skill includes **diagnostic math** (attrition calculations, concrete numbers) where the old version stays abstract
- Current skill produces **cleaner skip behavior** — old version added unnecessary meta-commentary on trivial tasks
- Current skill surfaces **problem topology** in the header so you can see how your problem was classified
- Current skill costs ~11% more tokens but produces measurably sharper output

## Works Across Domains

Not just business strategy. The skill finds the right expert for any substantive question:

- **Learning piano as an adult** — Anders Ericsson (deliberate practice)
- **E-commerce conversion drop** — Peep Laja (conversion optimization)
- **Organizing a garage** — David Allen (systems thinking applied to physical space)
- **Sleep optimization** — Matthew Walker (sleep science)

If a domain has someone who wrote the definitive book or research, the skill finds them.

## Install

```bash
npx skills add https://github.com/MoGHenry/best-minds-optimizer --skill best-minds-optimizer
```

Or browse and install from [skills.sh](https://skills.sh).

## License

MIT
