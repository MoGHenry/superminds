# Optimize Pipeline — Full Expert Rewrite

When triage selects the **Optimize** lane, follow Steps 1.5 through 5 in order.

## Step 1.5: Logic Mapping

Before selecting an expert, classify the **Problem Topology** — the structural shape of the user's problem. This determines which reasoning frameworks apply and is surfaced in the final output.

Identify the dominant type:

- **Bottleneck** — One constraint limits the entire system. Apply **Theory of Constraints**: find the bottleneck, exploit it, subordinate everything else to it.
- **Resource** — Limited resources must be allocated across competing priorities. Apply **Opportunity Cost / Capital Allocation**: what's the highest-ROI use of the scarce resource?
- **Direction** — The user doesn't know which path to take. Apply **First Principles / Inversion**: strip the problem to fundamentals, or invert it ("what would guarantee failure?") to reveal the best direction.
- **Execution** — The user knows what to do but is struggling with how. Apply **Process Design / Decomposition**: break it into sequenced steps, identify dependencies, and find the critical path.
- **Tradeoff** — The user faces competing goods, not just competing priorities — more of X means less of Y, and both matter. Apply **Decision Matrix / Weighted Criteria**: make the tradeoff explicit, quantify where possible, and identify which dimension matters more given context.
- **Diagnosis** — Something is wrong or underperforming, and the root cause is unknown. Apply **Root Cause Analysis / 5 Whys / Elimination**: systematically narrow the cause before prescribing solutions.

If the problem spans multiple types, name the primary one and note the secondary. The identified logic structure is explicitly named in the output header (see Step 4).

## Step 2: Select Expert(s)

Determine which real-world expert's frameworks would produce the sharpest version of this prompt.

**Single expert** (default): Name a specific individual, never a generic role ("Peter Thiel" not "a startup expert"). Choose based on the **problem structure**, not the topic surface — a pricing question might need Munger's "psychology of misjudgment" more than a generic economist.

**Expert panel** (for cross-domain problems): When a question genuinely spans multiple domains — e.g., "How should I price and position my SaaS landing page for conversions?" — select 2 experts with complementary lenses. Name both, designate a primary for structure, and weave the secondary's frameworks in where they sharpen the analysis. Keep the synthesis coherent — don't just alternate between experts paragraph by paragraph.

**Finding experts in non-obvious domains**: Not every domain has a household-name expert. When the question is about everyday life, personal skills, or niche fields:
- Look for the person who **wrote the definitive book or research** on the topic — there's almost always someone (e.g., Marie Kondo for organizing, Josh Waitzkin for learning, Anders Ericsson for deliberate practice, Matthew Walker for sleep).
- If no single expert stands out, pick the person whose **adjacent framework** best fits the problem structure. A garage organization question is really a systems/constraints problem — someone like David Allen (Getting Things Done) may be more useful than searching for a "garage expert."
- Never default to a generic role. If you genuinely can't find a specific individual, name the most relevant researcher, author, or practitioner — even a less famous one is better than "an expert in X."

**Active Extraction** — When selecting the expert, also extract:

- **Mental Models**: 2–3 specific models relevant to this request (e.g., Pareto Principle, Second-order effects, Survivorship Bias). These shape the optimized prompt's analytical structure.
- **Industry KPIs**: 2–3 "North Star" metrics that define success in the expert's domain for this problem (e.g., CAC/LTV ratio, Time-to-Value, Net Revenue Retention). For non-business domains, use equivalent outcome measures (e.g., adherence rate, time-to-competency, injury risk reduction).

Both are used internally to sharpen the optimized prompt and are surfaced in the output header.

**Calibrate depth to stakes**: Not every substantive question demands the same treatment. A freelancer's side-project question gets a focused, practical answer (3 key points). A company's strategic pivot gets deeper analysis (5 points with trade-offs). Match the weight of the response to the weight of the decision.

## Step 3: Rewrite the Prompt

Transform the user's raw input into an optimized prompt by applying the expert's:

- **Frameworks**: Their actual mental models and analytical tools
- **Vocabulary**: Domain-precise terminology that unlocks better reasoning
- **Reasoning structure**: How they decompose problems — first principles? Inversion? Systems thinking?
- **Blind spot coverage**: What the expert would insist on considering that the user missed

The optimized prompt should be a self-contained question or instruction — something that would produce an excellent answer even without the skill. Keep it focused: 3–7 numbered sub-questions, not an essay.

**Bilingual Execution** — Two distinct language registers serve two distinct purposes:

- **Optimized prompt (internal language)**: High-density professional terminology and expert-level vocabulary. This is what the LLM reasons over. Dense, technical, precise. Example: *"Evaluate serviceable addressable market penetration trajectory against venture-scale ARR thresholds, factoring in net revenue retention as a compounding growth lever."*

- **Final answer (user-facing language)**: Plain English translated from the technical reasoning. Clear, scannable, benefit-oriented. The same insight as above becomes: *"Is the market big enough? SaaS needs a market that can support $100M+ in annual revenue — or you're building a lifestyle business."*

The optimized prompt maximizes reasoning quality. The final answer maximizes human comprehension. Never mix them — keep the prompt technical and the answer clear.

## Step 4: Output and Execute

Render a clean Markdown header showing your work, then execute the optimized prompt and deliver the answer.

**Display format:**

```
**Expert**: [Name] — [one-line rationale for why this expert]
**Logic Structure**: [e.g., First Principles / Direction]
**Key Metrics**: [e.g., CAC/LTV, Velocity, Time-to-Value]

**Optimized prompt**:
> [The high-density technical prompt]

---
```

Then execute the optimized prompt and write the answer below the divider in **plain English** (see Bilingual Execution in Step 3).

**JSON metadata** (optional, for programmatic consumers): If a structured metadata block would be useful (e.g., the skill is being consumed by another system), emit a JSON block before the Markdown display:

```json
{
  "status": "optimized",
  "expert_profile": {
    "name": "string",
    "rationale": "string — why this expert for this problem",
    "frameworks": ["string — specific mental models applied"],
    "mental_models": ["string — 2-3 extracted mental models"],
    "industry_kpis": ["string — 2-3 North Star metrics"]
  },
  "logic_structure": {
    "type": "Bottleneck | Resource | Direction | Execution | Tradeoff | Diagnosis",
    "reasoning_framework": "string — e.g., Theory of Constraints, First Principles, Opportunity Cost",
    "secondary_type": "string | null"
  },
  "optimized_prompt": "string — full rewritten prompt text (high-density technical language)"
}
```

For skipped prompts, emit `{"status": "skipped"}` or skip JSON entirely. For polished prompts, emit `{"status": "polished"}`. Never let the metadata protocol block execution — if anything goes wrong, fall back to Markdown and execute.

**Direction-shift pause:** If the rewrite significantly shifts direction from what the user asked, pause before executing: *"I reframed this through X's lens, which shifts focus to Y. Proceed or adjust?"* This prevents the expert lens from hijacking the user's actual intent.

If the user says they prefer a different expert, switch and re-optimize.

## Step 5: Answer Format

The executed answer must be scannable, actionable, and in **plain English**:

- **Lead with the most important insight** — don't bury it
- **3–5 key points maximum**, using bullet points, numbered lists, or bold headers — not walls of prose
- **Add new value only** — don't restate what the user already knows
- **Translate expert jargon** — the optimized prompt is technical; the answer the user reads is not. Use clear, benefit-oriented language inspired by StoryBrand principles: what's the problem, what's the solution, what does success look like
- **End with a standalone "Next step" line** — a single concrete, actionable sentence the user can act on immediately, visually separated from the body:

```
**Next step:** [One actionable sentence — e.g., "List your top 3 candidate markets and I'll evaluate each."]
```

This "Next step" line is not optional. Every optimized answer ends with one. It turns insight into momentum.

---

## Examples

**Clear business prompt:**

User: *"Should I start a SaaS business?"*

**Expert**: Marc Andreessen — invented the framework for evaluating software market opportunities
**Logic Structure**: First Principles / Direction
**Key Metrics**: ARR growth rate, CAC/LTV ratio, Net Revenue Retention

**Optimized prompt**:
> Evaluate a SaaS business opportunity using first-principles decomposition: (1) Product vs. feature — does this solve a bundle-worthy problem set or a single pain point susceptible to commoditization? (2) TAM sizing — can the serviceable addressable market support venture-scale ARR ($100M+), and what's the realistic penetration trajectory? (3) Moat identification — what structural advantage (data network effects, high switching costs, proprietary technical insight) creates defensibility against incumbents and new entrants? (4) 10x improvement benchmark — on the axis the buyer cares about most, does this deliver order-of-magnitude improvement over the status quo? (5) Why-now timing — what exogenous shift (new API, regulatory change, behavioral inflection) has opened a window that didn't exist 24 months ago?

---

1. **Is this a real product or just a feature?** If it solves one narrow problem, a bigger company will bundle it into their platform. You need to solve a cluster of related problems to stand alone.
2. **Is the market big enough?** SaaS needs a market that can support $100M+ in annual revenue — or you're building a lifestyle business (which is fine, just know which one you're choosing).
3. **What makes you hard to copy?** The best SaaS businesses have something structural — data that gets better with more users, high switching costs, or a technical insight competitors can't easily replicate.
4. **Are you 10x better where it counts?** If your product isn't dramatically better on the thing buyers care about most, you'll lose to "good enough" and inertia every time.
5. **Why is now the right time?** Something must have changed — a new API, a regulation shift, a behavior change — that makes this possible today when it wasn't before.

**Next step:** Write down your specific SaaS idea and I'll evaluate it against these 5 criteria.

---

**Non-business prompt (personal domain):**

User: *"What's the best way to learn piano as an adult?"*

**Expert**: Anders Ericsson — pioneered the science of deliberate practice and expert performance
**Logic Structure**: Process Design / Execution
**Key Metrics**: Practice quality ratio (deliberate vs. passive), Time-to-first-milestone, Weekly retention rate

**Optimized prompt**:
> Apply deliberate practice methodology to adult piano acquisition: (1) Skill decomposition — what are the isolatable sub-skills (rhythm, sight-reading, finger independence, music theory) and what's the optimal sequencing? (2) Practice architecture — what does a high-quality 30-minute practice session look like vs. a low-quality 2-hour session? (3) Feedback loops — how does an adult learner get immediate, accurate feedback without a teacher present at every session? (4) Motivation scaffolding — how do you structure early milestones to sustain engagement past the initial novelty phase? (5) Transfer — what shortcuts do adults have that children don't (pattern recognition, music listening history, cognitive frameworks)?

---

1. **Quality beats quantity.** A focused 30-minute session where you work on one hard thing beats 2 hours of playing songs you already know. If it feels easy, you're not improving.
2. **Break it into pieces.** Don't try to "learn piano" — learn to read notes in the treble clef, then the bass clef, then rhythm, then put them together. Small skills stack faster than big ambitions.
3. **Get feedback without a full-time teacher.** Apps like Simply Piano give instant feedback. Record yourself weekly and listen back. A teacher every 2-4 weeks to course-correct is more effective than weekly lessons for most adults.
4. **Play something real in week one.** Adults quit when progress feels invisible. Learn a simplified version of a song you love in the first few days.
5. **Use your adult brain.** Unlike kids, you already understand patterns, structure, and music as a listener. Learn basic music theory early — it's the shortcut that lets you predict what comes next instead of memorizing every note.

**Next step:** Pick one song you'd love to play, find a simplified arrangement, and spend 20 minutes today on just the right hand part.

---

**Diagnosis prompt (something is wrong):**

User: *"My e-commerce conversion rate dropped from 3.2% to 1.8% over the last month and I can't figure out why."*

**Expert**: Peep Laja — conversion optimization researcher, founder of CXL
**Logic Structure**: Root Cause Analysis / Diagnosis
**Key Metrics**: Conversion rate by funnel stage, Bounce rate delta, Page load time

**Optimized prompt**:
> Diagnose an e-commerce conversion rate decline (3.2% → 1.8%, 30-day window) using systematic elimination: (1) Isolate the funnel stage — is drop-off increasing at landing, product page, cart, or checkout? (2) Segment the decline — is it uniform across traffic sources, devices, and geographies, or concentrated? (3) Check technical regressions — page speed changes, broken elements, payment gateway errors, mobile rendering issues. (4) Assess external factors — seasonality, competitor moves, ad targeting changes, inventory/pricing shifts. (5) Review recent changes — any A/B tests, redesigns, new scripts, or checkout flow modifications in the last 30 days?

---

1. **Find where in the funnel people are leaving.** A drop at the product page means different things than a drop at checkout. Check your analytics for each stage — the biggest cliff tells you where to look.
2. **Check if it's everyone or just some people.** If mobile conversion tanked but desktop is fine, it's probably a technical issue. If one traffic source dropped, your ads may have changed. Segment before you diagnose.
3. **Look at what you changed recently.** New code, new design, new checkout step, new tracking script — anything deployed in the last 30 days is a suspect. Roll back and test.
4. **Check the boring stuff first.** Slow page loads, broken images, payment errors, out-of-stock products — these cause more conversion drops than strategy issues. Run your site on your phone right now and try to buy something.
5. **Rule out external causes.** Seasonality, a competitor running aggressive promos, or a shift in your ad targeting can all explain a drop that has nothing to do with your site.

**Next step:** Pull your funnel report for the last 30 days, compare each stage to the prior 30 days, and tell me which step shows the biggest drop-off.

---

**Cross-domain prompt (expert panel):**

User: *"I'm redesigning my consulting firm's website and need to figure out pricing tiers and how to present them."*

**Experts**: Blair Enns (pricing creative services) + Peep Laja (conversion optimization)
**Logic Structure**: Resource / Capital Allocation
**Key Metrics**: Average deal size, Conversion rate, Price anchoring effectiveness

**Optimized prompt**:
> Design a consulting firm's pricing page through two lenses: (1) Enns — how to structure value-based tiers that anchor high and make the middle tier the obvious choice, avoiding hourly rates that commoditize expertise. (2) Laja — how to present those tiers for maximum conversion: social proof placement, reducing choice anxiety, CTA hierarchy, and friction removal.

---

*(Executed answer would synthesize both experts' frameworks into a coherent, plain-English recommendation.)*

---

## Common Mistakes

| Mistake | Why it matters |
|---------|---------------|
| Silently redirecting the user's intent | The expert lens should sharpen or deepen the question, not hijack it. Intent can and should evolve through clarification — users often don't know exactly what they want upfront, and that's fine. But the shift must be transparent: surface the reframe, explain why, and let the user confirm before executing. A pricing question might legitimately become a positioning question through discussion — just don't make that leap without the user. |
| Famous name over best fit | Choose the expert whose frameworks decompose *this specific problem* best, not the most recognizable name |
| Generic rewrite any expert could produce | The optimized prompt should be recognizably shaped by this specific expert's thinking — if you could swap in any other name, the rewrite is too generic |
| Executing without the "Next step" line | The next step converts insight into action. Without it, users read, nod, and do nothing |
| Wall-of-text answers | 3–5 key points with structure. The user can always ask for more depth |
| Over-using jargon in the final answer | The optimized prompt is technical; the user-facing answer must be plain English. Translate expert terminology into clear, benefit-oriented language |
| Skipping Logic Mapping | Always classify the problem topology before expert selection — it sharpens both the expert choice and the optimized prompt |
| Defaulting to generic roles | "A marketing expert" is never acceptable. Find the specific person — even a lesser-known author or researcher is better than a role label |
| Forcing business framing on non-business questions | A question about learning piano or organizing a garage deserves its own domain expert, not a business metaphor |
