# Diagnosis

How to turn a pile of transcript turns into a short list of named problems, each backed by the user's own words.

## 1. Hunt correction pairs first

A **correction pair** is an original prompt plus the later turn where the user had to correct, redirect or re-explain. It is the strongest evidence available: the user paid real turns for it, and the correction states exactly what the original left out.

Scan for correction markers:

- Chinese: 不对, 我是说, 我的意思是, 不是这个, 重新, 还是不对, 我要的是, 你理解错了, 调整, 修改, 移除, 不用管, 暂时不, 其实
- English: no, I meant, actually, not that, redo, what I want is, ignore, remove, just

For each hit, walk back to the prompt that caused it and quote both. Then ask the one question that does the work:

> **Which turn should this sentence have arrived in?**

If the answer is "the first one", you have found a gap. Name the layer it belongs to. Count the turns burnt between original and correction — that number is what the gap costs, and it belongs in the lesson.

Keep the ten or so most instructive pairs. A pair where the correction supplies a *goal* beats one that fixes a typo.

## 2. Sweep the standing patterns

Then go over every turn once, per layer.

### Spec

| Pattern | What to look for |
|---------|------------------|
| Missing goal | An artifact or action is named with no decision behind it. Count turns containing a why-marker (因为, 为了, 这样, so that, in order to) against total task turns. |
| Missing scope | No bound on size, depth or how many. Scope that arrives in a later turn is a correction pair, not a scope. |
| Multi-intent | Several deliverables chained in one turn with no priority. Count the imperative verbs. |
| Un-verified premise | A claim handed over as fact that the model then builds on. Often begins 既然 / since / 我记得. |
| Pointer-only context | An `@path` or issue number standing in for a briefing, on the assumption the file says what the user means. |

### Verifier

| Pattern | What to look for |
|---------|------------------|
| No acceptance criteria | Nothing states what a good result looks like. Count turns that do. |
| Post-hoc criteria | Criteria that only appear after a draft ("shorter", "4 句话左右"). Each round is a turn the first prompt could have saved. |
| Vague quality words | 更好, 优化, 完善, 补充, 调整, make it better — a target state with no target. |
| No verification asked | Work that could be checked against a real signal (a run, a page, a file) accepted on the model's word. |

### Environment

| Pattern | What to look for |
|---------|------------------|
| Repeated context | The same background retyped across sessions instead of living in CLAUDE.md or a skill. |
| Standing rule done right | A turn like "从现在开始，每次…" — praise these by name, they are the layer working. |
| Context destroyed then used | Real work started inside `/compact <instruction>`, or a fresh session opened with no carried state. |

## 3. Measure, so the next run can compare

Compute these every run and write them to the record. They make progress and relapse checkable instead of a matter of impression.

| Metric | How |
|--------|-----|
| `task_turns` | Turns that ask for work, excluding acknowledgements (`ok`, `go`, `继续`, single letters) |
| `why_rate` | Turns with a why-marker ÷ `task_turns` |
| `criteria_rate` | Turns stating what a good result looks like ÷ `task_turns` |
| `correction_pairs` | Count found in step 1 |
| `turns_burnt` | Total turns between originals and their corrections |
| `multi_intent_rate` | Turns with 3+ chained deliverables ÷ `task_turns` |
| `median_chars` | From `extract-turns.sh --stats` |

## 4. Name each problem with a stable ID

Relapse detection needs the same problem to carry the same name across runs. Use `P-<layer>-<slug>`:

`P-spec-goal-missing`, `P-spec-scope-late`, `P-verifier-criteria-posthoc`, `P-env-context-repeated`

Reuse an existing ID from `current.md` or `archive.md` whenever the evidence matches it. Coin a new one only for a genuinely new shape, and keep the slug descriptive enough to recognise a year later.

## 5. Find the model answers

Before finishing, pick the three to five **strongest** prompts in the corpus — the ones that needed no correction — and say precisely what made each work. These carry more weight than any rule, because the user wrote them: the skill is not teaching a new behaviour, it is making an occasional one default. They become the comparison target in [`grading.md`](grading.md).

## 6. Report before you build

Give the user the diagnosis and ask whether it lands, before writing the lesson. A diagnosis they reject is a lesson wasted, and their correction is better evidence than any inference from files.
