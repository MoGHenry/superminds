# Lesson

One self-contained HTML file per run, written to `./docs/learning/NNNN-<dash-case>.html`.

The user opens it in a browser, reads it in a few minutes, and comes back to the session with a prompt they wrote. Keep it short: a lesson that outlasts working memory teaches the first half only.

## Shape

Single file, CSS inline in a `<style>` block, no scripts and no external requests, so it opens offline and prints cleanly. Serif body text, one column, `max-width: 34em`, generous line height. Include a `prefers-color-scheme: dark` block. Every quote from the user carries its date.

## Sections, in order

1. **What this is from.** One line: which transcripts, what date range, how many turns. Then the metrics table from [`diagnosis.md`](diagnosis.md) §3 — and when a previous run exists, the previous numbers beside them so movement is visible.

2. **What the transcripts show.** Two to four named problems, most costly first. Each gets: the problem in one sentence, a verbatim correction pair with dates, the turns it burnt, and which layer it belongs to. Quotes carry this section — keep your own prose to the sentence that frames each one.

3. **Relapse**, only when there is one. The problem, the date it was cleared, the date it came back. Put it above the drills: a mistake the user remembers committing is the strongest cue available, and it makes everything after it land harder.

4. **What already works.** The strongest prompts found in the corpus, quoted, with what made each one work. This section is load-bearing, not encouragement — it shows the target behaviour already exists in the user's own writing, which makes the drills a matter of frequency rather than a new skill to acquire.

5. **The three layers**, compact. A table, not an essay: the question each layer answers and the tell that it is missing. The user already knows this; it is here to be glanced at during the drills.

6. **Drills.** See below.

7. **How to answer.** Tell the user to write their answers and paste them back into the Claude Code session — the grading happens there, not in the page.

## Drills

Four to six, no more. Mix the three kinds rather than grouping them — interleaving is what trains the discrimination between layers, and blocked practice trains the answer to the heading instead.

| Kind | The user is given | The user produces |
|------|-------------------|-------------------|
| **Diagnose** | A real exchange of theirs where the answer missed | Which layer the prompt was missing, and the sentence that would have fixed it |
| **Review** | A prompt — theirs, or one from another project | The missing layer, named |
| **Write** | A real situation from their repo, stated as a situation and not as a task | A prompt, written out in full |

Build every drill from material found in the transcripts. Invented scenarios teach recognition of invented scenarios; the research on cognitive training is clear that nothing generalises for free, so the drills have to run on the user's own work.

At least one drill per layer. End with a **Write** drill — identification is the skill being trained, production is where it has to show up.

Give each drill a collapsed answer (`<details><summary>`) holding what to compare against, so the page is useful on a second reading. The graded answer still comes from the session.
