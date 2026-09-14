---
name: best-minds-drill
description: Diagnose your prompt-writing habits from your own Claude Code transcripts, then drill them with a generated lesson and graded practice.
disable-model-invocation: true
argument-hint: "<repo name or absolute path>"
---

# Best Minds Drill

Turn the user's own transcripts into a lesson about how they write prompts, then make them write one and grade it.

Knowing the three layers does not put them to use. The gap is recognition: the habit fires in the moment or it doesn't, and reading about it changes nothing. So this skill never lectures from theory. Every claim it makes is a line the user typed, quoted back with a date, and every drill is scored against what they wrote.

Write everything the user reads in the language they wrote to you in, keeping technical terms (Review Gate, hook, spec, SEO) in English so they stay greppable.

## The three layers

The frame for every diagnosis, lesson and grade. Detailed detection rules live in [`references/diagnosis.md`](references/diagnosis.md).

| Layer | The question it answers | Missing when the prompt… |
|-------|------------------------|--------------------------|
| **Spec** | What am I actually trying to decide, and how big is this? | names a task with no goal behind it, or no boundary on size |
| **Verifier** | How will we both know this came out right? | leaves "good" undefined until after the draft arrives |
| **Environment** | What should hold without me saying it again? | repeats context that belongs in CLAUDE.md, a skill, or a hook |

A **correction pair** is the core evidence unit: an original prompt plus the turn where the user had to correct, redirect or re-explain. The correction is testimony about what the original failed to say, and the layer it belongs to names the gap.

## Steps

0. **Check for a first run.** If `~/.claude/best-minds-drill/` exists, go to step 1. If it doesn't, this user has never run the skill, and every step below assumes they already know the three layers — without them, the drills can only be answered from the answer key. So before step 1:
   - point them to the README in their language, [English](https://github.com/MoGHenry/superminds/blob/main/readme/README-best-minds-drill.md) or [中文](https://github.com/MoGHenry/superminds/blob/main/readme/README-best-minds-drill-CN.md), and then to the starter guide at `<skill dir>/assets/onboarding.html`, given as an absolute path they can open;
   - create `~/.claude/best-minds-drill/`, so the reminder shows only once;
   - ask whether they want to read first or start now, then stop and wait.

   **Done when** the user has answered. If they start now, carry their argument into step 1.

1. **Pick the transcripts.** Take the repo from the argument, or ask which repo to analyse. Then run:
   ```
   bash <skill dir>/scripts/find-sessions.sh <repo name or absolute path>
   ```
   Show the user the table it prints and ask which files to use. A repo holds many sessions and the user cannot name one from memory, so hand them the directory and the per-file turn counts and dates, and let them answer with absolute paths. Suggest the files with the most turns when they have no preference. **Done when** the user has named at least one absolute path.

2. **Extract.** For the chosen files:
   ```
   bash <skill dir>/scripts/extract-turns.sh --stats <path> [more...]
   bash <skill dir>/scripts/extract-turns.sh <path> [more...]
   ```
   The first gives the length distribution, the second the turns themselves. **Done when** every file the user named has been read this way.

3. **Diagnose.** Read [`references/diagnosis.md`](references/diagnosis.md) and apply it. Find the correction pairs first — they are the richest signal and they cost the user real turns. Then sweep for the standing patterns. **Done when** every problem you will report carries at least one verbatim quote with its date, and you have also found the user's strongest prompts, which become the drill's model answers.

4. **Check for relapse.** Read [`references/records.md`](references/records.md), then read `~/.claude/best-minds-drill/current.md` and `archive.md` if they exist. Three outcomes per recorded problem: still present, gone (move to archive), or **relapse** — present again after being archived. Say relapse out loud to the user with the old date: "this one showed up in <repo> on <first-seen date>, and you'd cleared it." A problem they remember committing lands harder than any rule.

5. **Write the lesson.** Read [`references/lesson.md`](references/lesson.md) and write one self-contained HTML file to `./docs/learning/` (create the directory if needed), named `NNNN-<dash-case>.html` with the number one past the highest already there. Print the path. **Done when** the file exists on disk and carries at least one drill for each of the three layers.

6. **Hand over and stop.** Tell the user to open the file, and that the drills ask them to write a prompt and send it back here. Then stop and wait. Do not grade an answer you have not received, and do not answer the drills yourself.

7. **Grade what they send.** Read [`references/grading.md`](references/grading.md) and apply it to the prompt they wrote. **Done when** all three layers have a verdict and the feedback names the one change with the highest payoff.

8. **Record.** Per [`references/records.md`](references/records.md), write `current.md` and `archive.md` under `~/.claude/best-minds-drill/`. These stay at user scope on purpose: the habits are the user's, not a repo's, and relapse shows up in whichever project they work in next.

## Scope

Hold to the three layers. The transcripts will show plenty else worth saying — architecture, security, how they run their team — and naming those trades the one frame the user is building for a pile of observations they will not retain. Mention anything urgent in a line at the end, outside the lesson.
