# Three-layer audit: best-minds-optimizer

Draft for review · 2026-09-11 · line numbers refer to commit `8040f3f`

## TL;DR

- **The video** repackages a Karpathy talk as three layers. First, write a real spec: your goal, a small scope, and precise requirements. Second, verify output against criteria and outside signals. Third, build an environment (CLAUDE.md, skills, hooks) where the rules that matter are enforced. Most of it holds up. The claim that "validation is the only lever" doesn't, and neither does the robot-librarian metaphor.
- **The audit** found 7 gaps in best-minds-optimizer and its hook. The top three:
  - The hook's install snippet doesn't work (reproduced locally).
  - The Review Gate asks users to approve a jargon-heavy prompt instead of confirming their goal.
  - `optimize.md` still describes the flow from before the gate existed.

## Scope and method

- **Audited:** `skills/best-minds-optimizer/` (SKILL.md and its four reference files) and `hooks/skill-directive/skill-directive.sh`.
- **Not audited:** the other skills, the README files (cited only for what they promise users), and the dev setup.
- **Criteria:** the video's claims that survive the critique in section 2, listed in section 3.
- **Ranking:** how costly the mistake is for someone using the skill comes first. Effort to fix breaks ties.
- **Evidence labels:** *Read* means inferred from the files. *Checked* means reproduced locally. No finding comes from a live run of the skill.

## 1. Source

- **What:** a YouTube video that turns a talk by Andrej Karpathy into a "three-layer method". The transcript calls the event "AISN 2026" and never names the video's creator. Video: `TODO(user): URL or title`.
- **Transcript:** auto-generated and saved locally as `docs/three_layer.txt`. It is a word-for-word copy of someone else's video, so it isn't committed. `[T:n]` refers to its line numbers.
- **Cleanup:**
  - "the cloud" is read as "Claude" [T:85, 198, 323].
  - Repeated lines are treated as transcription errors.
  - The subscribe/giveaway segment [T:218–229] is dropped.
  - "building ten" [T:7] is unintelligible.
- **Labels:**
  - *Karpathy*: his own words, in a clip the video plays.
  - *Attributed*: the creator quoting someone else.
  - *Creator*: the creator's own framing or advice.
- **Critique method:** reasoning only, with no sources checked. Claim 17 is the one exception and says so.

## 2. Summary and critique

### Layer 1: Spec

**1. AI misses context it isn't given.** *Creator, crediting the example to Karpathy* [T:13–28]
The question: "The car wash is 50 meters away; should I drive or walk?" Models say walk, missing that the car has to get there. The creator reports that Claude, Gemini, Grok and ChatGPT all gave that answer.
**Critique:** A good illustration: an unstated goal ("wash the car") produces a confident wrong answer. One anecdote doesn't prove a general limit, and results vary by model version. **Verdict: holds as an illustration.**

**2. Plan mode is too high-level; build a detailed spec together.** *Karpathy* [T:34–44]
"I'm not even a big fan of plan mode… you have to work with your agent to design a spec that is very detailed." The creator adds that this doesn't reject plan mode; it says to go deeper.
**Critique:** A spec is something you can review and check the work against. A plan is only a list of steps. **Verdict: holds.**

**3. Step 1: uncover the goal.** *Creator* [T:47–56]
"Create an end-of-month report" is a task. The goal is the decision the report should drive. "AI will literally never be able to decide [that] for you", so have Claude interview you.
**Critique:** The goal is the user's call. "Literally never" goes too far: an AI can propose candidate goals, it just can't pick one for you. **Verdict: holds, softened.**

**4. Step 2: work agile, not waterfall.** *Creator* [T:57–72]
Set a tight scope and a clear checkpoint, then review, adjust and repeat. Tell Claude to prefer smaller, self-contained specs.
**Critique:** Sound advice, but it ignores the cost: every checkpoint is a round trip for the human. The video sizes guardrails to the cost of a mistake (claim 18) but never does the same for checkpoints. **Verdict: holds, incomplete.**

**5. Step 3: be precise and check the key decisions.** *Creator* [T:73–82]
"Every assumption that AI makes is a chance for it to drift." Read what the spec actually says.
**Critique:** One consequence matters for this audit: a person can only catch an assumption they can see and understand. **Verdict: holds.**

> **Spec prompt (on screen):** `TODO(user): paste prompt text`

### Layer 2: Verifier

**6. Ghosts, not animals.** *Karpathy* [T:98–118]
"We're not building an animal. We are summoning a ghost." Yelling at a model doesn't make it work better or worse. Models are "statistical simulation circuits", so stay skeptical and learn how they behave over time.
**Critique:** The practical point holds: pressure isn't a reliable way to get quality. Read literally, "it has absolutely no effect" [T:115] is too strong, since wording does change output, and that line may just be the transcript repeating [T:114]. The "simulation" idea also works against how the video uses the clip. If a model simulates, the context and framing you give it shape what it simulates, which is exactly best-minds-optimizer's premise (`SKILL.md:10`). **Verdict: holds, narrowed.**

**7. The robot librarian.** *Creator* [T:132–146]
A librarian can only offer the books it has, and doesn't know when one is missing, so it is confidently wrong. The creator says this is why AI is "so good at math problems" but "fumbles things with context".
**Critique:** Helpful for explaining confident errors, but a misleading picture of how LLMs work. They generalize rather than look things up, which is also how they invent believable answers. And "math versus context" is the wrong split. What matters is whether an answer can be checked, which is the real reason to have a verifier. **Verdict: a metaphor only; not used as a criterion.**

**8. Validation is "the only real lever".** *Creator* [T:147–158]
Treating the model like a person (yelling, begging, "just make it better") fails; validation works.
**Critique:** Overstated, and it contradicts the rest of the video: specs (Layer 1) and CLAUDE.md or skills (Layer 3) are levers too. The defensible version is that validation is the most under-used lever. **Verdict: partly holds.**

**9. Set evaluation criteria up front.** *Creator* [T:160–178]
Replace "make this report look good" with "three sections, each ending with a recommendation". Ask Claude to list, precisely, the criteria it will judge its work by.
**Critique:** The most actionable advice in the video. **Verdict: holds.**

**10. Have a second model grade the work.** *Creator* [T:179–190]
A librarian from a different library checks the first one's work. The example is Codex, used through its Claude Code plugin.
**Critique:** Worth doing when stakes are high. Two models agreeing doesn't make them right, since they can make the same mistakes, and each extra pass costs time. I didn't check the plugin. **Verdict: holds for high-stakes work.**

**11. Bring in outside signals.** *Creator* [T:191–206]
Let Claude check the deployment system itself, and give it past reports to compare against. "If it says the deployment was successful, then we can be sure it actually was."
**Critique:** A real signal beats the model's own report. But "we can be sure" doesn't follow: a check only proves what it measures. **Verdict: holds, with that caveat.**

**12. A feedback loop makes results 2–3× better.** *Attributed to Boris Cherny* [T:213–215]
**Critique:** A practitioner's rule of thumb, with no defined measure of "quality". The direction is believable; the number can't be used. I didn't check the quote. **Verdict: the direction holds; the number is dropped.**

> **Verification prompt (on screen):** `TODO(user): paste prompt text`

### Layer 3: Environment

**13. The environment is the workshop.** *Creator* [T:230–244]
The spec is the blueprint on the wall, the verifier is the quality check by the door, and the environment is the workshop itself. Most people rebuild it every session, and one long chat doesn't count.
**Verdict: holds.**

**14. CLAUDE.md sets the working rules.** *Creator* [T:245–265]
It loads automatically. Example rule: "Before building anything multi-step, include a verification plan."
**Verdict: holds.**

**15. Build an LLM knowledge base.** *Creator, crediting a Karpathy post* [T:266–273]
Organize your material into folders so Claude knows where to look. "Your data is your moat."
**Critique:** Sensible organizing advice with a marketing slogan attached. It doesn't apply to a prompt-optimizer skill. **Verdict: holds; not used.**

**16. Skills get better the more you use them.** *Creator* [T:274–285]
"Find the leak in the pipe" and patch it.
**Critique:** Using a skill doesn't improve it by itself. Someone has to notice a failure and edit the skill, so this only works if failures get recorded somewhere. **Verdict: holds only with a feedback loop.**

**17. Instructions are requests; hooks are rules.** *Creator* [T:286–311]
Claude can ignore a CLAUDE.md line like "don't make up information". A PreToolUse hook that checks the target file makes a forbidden edit impossible.
**Critique:** Holds. Claude Code's settings reference, which I loaded while auditing the hook, confirms PreToolUse hooks can block a tool call. There are two limits:
- Hooks only guard tool calls. A rule about what the model *says*, like the example, can't be enforced this way.
- "80% of the time" [T:302] has no source.

**Verdict: holds for tool actions.**

**18. Sort actions into always do, ask first, and never do, based on the cost of a mistake.** *Creator* [T:286–288, 312–320]
**Verdict: holds.**

> **Environment audit prompt (on screen):** `TODO(user): paste prompt text`

### Closing

**19. "You can outsource your thinking, but you can't outsource your understanding."** *Karpathy* [T:331–333]
**Critique:** A restatement of claim 3: the goal stays yours. **Verdict: holds.**

**Overall.** The three-layer structure is the creator's; Karpathy appears in three short clips. The video's weak spot is that it sizes guardrails to the cost of a mistake but never does the same for checkpoints or verification. Applied at full strength to everything, the three layers add friction the video doesn't account for.

## 3. Audit criteria

| ID | Criterion | From claims |
|----|-----------|-------------|
| C1 | **Goal confirmed:** the user's goal is repeated back in plain words and confirmed, not quietly inferred. | 3, 19 |
| C2 | **Assumptions visible:** anything the agent adds (scope, context, framing) is shown in a form the user can read. | 5 |
| C3 | **Checkpoints sized to stakes:** checkpoints exist, and how many there are and how much they demand depends on the cost of a wrong result. | 4, 18 |
| C4 | **Criteria before the work:** what a good result looks like is written down before the work starts. | 9 |
| C5 | **Checked, not asserted:** quality claims are backed by a check (a test, an eval, an outside signal), including claims about the method itself. | 8, 11, 12, 16 |
| C6 | **Independent review when stakes justify it.** | 10 |
| C7 | **Enforce what can be enforced:** critical tool actions are guarded by hooks, and prompt rules are treated as requests. | 17 |
| C8 | **Works as shipped:** the pieces the skill depends on install as documented and don't contradict each other. | 13, 14 |

**Not used as criteria:** the librarian metaphor (7), "the only lever" (8), the 2–3× figure (12), the knowledge base (15), and the 80% figure (17).

## 4. Findings

| # | Finding | Criteria | Cost to user | Fix effort | Evidence |
|---|---------|----------|--------------|------------|----------|
| 1 | The hook's install snippet doesn't work | C8 | High | Low | Checked |
| 2 | The Review Gate asks users to approve jargon, not a stated goal | C1, C2 | High | Low | Read |
| 3 | `optimize.md` still describes the flow from before the gate | C2, C8 | Medium | Low | Read |
| 4 | Every substantive prompt stops at one or two blocking gates | C3 | Medium | Medium | Read |
| 5 | Answers have no acceptance criteria | C4 | Medium | Medium | Read |
| 6 | The skill's core claim is never measured | C5 | Unknown until measured | High | Read + checked |
| 7 | The hook adds status lines to every prompt and lists 3 of 4 lanes | C3, C8 | Low | Low | Read |

Finding 6 is ranked by known cost only. It may turn out to matter most.

**No finding for C6 or C7.** The skill takes no tool actions that a hook could guard (C7). Having a second model grade every answer would conflict with C3 (C6), though it could become an opt-in for high-stakes questions.

**Already aligned:**
- There is already a human checkpoint before the answer (`SKILL.md:41-69`). Findings 2 and 4 are about making that checkpoint work, not adding one.
- The Skip lane keeps mechanical prompts out of the pipeline (`SKILL.md:35-39`). Finding 7 is the hook undoing that.
- The Clarify lane asks questions instead of guessing when a prompt is ambiguous (`references/clarify.md`).
- The depth of the answer already scales with stakes (`references/optimize.md:40`). Finding 4 applies the same idea to the gate.

### Finding 1: The hook's install snippet doesn't work

**Evidence (checked locally):**
- **Wrong nesting.** `hooks/skill-directive/skill-directive.sh:5-12` registers the hook as `"UserPromptSubmit": [{"type": "command", "command": "/path/to/skill-directive.sh"}]`. Claude Code's settings schema requires each entry to contain its own `hooks` array. I ran `jq -e '.hooks.UserPromptSubmit[] | .hooks[] | select(.type=="command") | .command'` on both versions:
  - The documented snippet fails (exit 5, "Cannot iterate over null").
  - The nested version prints the command (exit 0).
- **Not executable.** The script is committed as mode `100644`. Claude Code runs a hook's `command` through a shell, so running the file directly by path fails: `bash -c <path>` gives `Permission denied` (exit 126). `bash <path>` exits 0 and prints the directive.
- **No other install guide.** Neither `README.md` nor `readme/README-best-minds-optimizer.md` explains how to install the hook, so this comment is the only guide. Yet `README.md:54` says the skill "intercepts every prompt".

**Cost:** Anyone who follows the snippet gets no interception. Claude Code's settings guidance also warns that a settings file broken this way silently disables every setting in it; the guidance groups wrong nesting with malformed JSON. I haven't seen that happen.

**Fix:** Nest the entry, and either run the script through `bash` or commit it as executable (`git update-index --chmod=+x`):

```json
"hooks": {
  "UserPromptSubmit": [
    { "hooks": [ { "type": "command", "command": "bash /path/to/skill-directive.sh" } ] }
  ]
}
```

**Status (2026-09-11):** superseded. `hooks/skill-directive/` was retired and replaced by `skills/best-minds-setup/`, whose installer nests the settings entry correctly, runs the gate through `bash`, and verifies both after writing.

### Finding 2: The Review Gate asks users to approve jargon, not a stated goal

**Evidence (read):**
- **The goal is guessed.** The Deconstruct step extracts "core intent" by stripping "surface phrasing to find the underlying goal" (`references/methodology.md:9`). The Clarify lane only runs when a prompt looks ambiguous, and it stops at 2–3 multiple-choice questions (`references/clarify.md:15`).
- **The rewrite adds things the user didn't say.** It fills gaps "by embedding necessary context, constraints, or scope directly into the optimized prompt" (`methodology.md:47`) and expands the question into 3–7 sub-questions (`references/optimize.md:60`). The step that detects assumptions looks at the user's assumptions (`methodology.md:25`), not the ones the rewrite introduces.
- **The gate doesn't show the goal or the additions.** It shows the expert, framework, metrics and rewritten prompt (`SKILL.md:47-55`), but not the goal in plain words or what was added. The rewritten prompt uses "high-density professional terminology" (`optimize.md:64`), the style the skill otherwise keeps away from users (`optimize.md:66-68`).

**Cost:** The gate exists so the expert framing can't hijack what the user actually wants (`optimize.md:112`, `:226`). If users can't read what they're approving, they approve anyway, and the gate stops protecting them. This affects every Optimize run.

**Fix:** Start the gate with two plain-English lines: "Your goal, as I understand it" and "What I added" (scope, assumptions, framing). Put the dense prompt below them. If the goal line is a guess, ask the user before rewriting.

### Finding 3: `optimize.md` still describes the flow from before the gate

**Evidence (read + git history):**
- **The gate commit skipped `optimize.md`.** Commit `34f9669` (2026-03-15) added the gate and changed only `SKILL.md`. Commit `a2ad8c7` edited `optimize.md` later that day, but its Step 4 still says to render the header "then execute the optimized prompt and deliver the answer" (`references/optimize.md:72`, `:87`). It also still defines its own Direction-shift pause (`optimize.md:112`), which `SKILL.md:69` declares replaced by the gate but never removes.
- **The agent is sent there.** `SKILL.md:22` points to `optimize.md` "for the full pipeline", including the output step.
- **The names don't match.** The two display formats label the same fields differently: Expert Persona, Reasoning Framework and Rewritten Prompt (`SKILL.md:50-55`) versus Expert, Logic Structure and Optimized prompt (`optimize.md:77-82`). "Step 2" is the Review Gate in `SKILL.md:41` but Expert Selection in `optimize.md:20`, and `SKILL.md:67` uses the second meaning.

**Cost:** The agent has to reconcile two conflicting specs on every Optimize run. The likely results are the header appearing twice or, when `optimize.md` wins, the answer being delivered without stopping at the gate. Neither has been observed.

**Fix:**
- Make the gate its own step in `optimize.md`, between Rewrite and Output.
- Delete the Direction-shift pause.
- Use one set of field names.
- Renumber so each step number means one thing.

### Finding 4: Every substantive prompt stops at one or two blocking gates

**Evidence (read + git history):**
- **The gate is unconditional.** The Review Gate applies to every Optimize-lane prompt, whatever the stakes: "never skip it" (`SKILL.md:43`), "Silence is not consent" (`SKILL.md:65`). Stakes only change how deep the answer goes (`references/optimize.md:40`).
- **The hook adds a second one.** With the hook installed there is another question: list the matching skills, then "ask the user for permission before invoking" (`hooks/skill-directive/skill-directive.sh:23`).
- **They were never designed together.** The hook (`876bbbe`, 2026-03-12) was written before the gate (`34f9669`, 2026-03-15) and hasn't changed since.

**Cost:** A low-stakes question like "best way to learn piano as an adult?" takes one or two extra round trips before any answer. Frequent gates also train users to approve without reading, which weakens the gate from finding 2 even further.

**Fix:** Keep a single checkpoint and size it to the stakes:
- For low-stakes prompts, answer directly, show how the question was reframed, and offer "redo without the expert framing".
- Stop at the gate only for high-stakes rewrites or ones that change the question's direction.
- Move the skill-match question into that same gate.

**Status (2026-09-11):** half fixed. The second gate is gone with `skill-directive.sh`; the shipped trigger asks nothing. The Review Gate is still unconditional, so the rest of this finding stands.

### Finding 5: Answers have no acceptance criteria

**Evidence (read):**
- **The metrics aren't about the answer.** The rewrite extracts "Key Metrics" (`references/optimize.md:36`), but these measure success at the user's underlying problem (e.g. CAC/LTV, adherence rate), not the quality of the answer.
- **The only checks are self-checks of the prompt.** The model judges whether its prompt "would produce an excellent answer even without the skill" (`references/methodology.md:58`) and whether it's too generic (`optimize.md:228`).
- **The answer rules cover format only.** Step 5 asks for 3–5 points, plain English, and a Next step line (`optimize.md:116-130`). Nothing checks whether the answer serves the goal.

**Cost:** An answer can be well formatted and still miss the goal, and nothing in the pipeline would notice. This affects every Optimize run.

**Fix:** Have the rewrite produce 2–3 acceptance criteria tied to the confirmed goal (finding 2), show them at the gate, and check the answer against them before sending it.

### Finding 6: The skill's core claim is never measured

**Evidence (read + checked):**
- **The premise is asserted, not tested.** The skill rests on three claims:
  - A prompt framed through an expert "produces a fundamentally different response" (`SKILL.md:10`).
  - Expert vocabulary "unlocks better reasoning" (`references/optimize.md:56`).
  - The dense prompt "maximizes reasoning quality" (`optimize.md:68`).

  "Different" is claimed, and "better" is simply assumed.
- **There are no evals.** No eval, benchmark, or workspace files exist anywhere in the working tree.
- **Failure signals are thrown away.** When a user replies "adjust" or "skip" at the gate (`SKILL.md:60-61`), that's direct evidence a rewrite missed, and nothing records it.

**Cost:** Unknown, and that is the finding. If the rewrite doesn't help for some kinds of questions, those users sit through the gate and get nothing for it.

**Fix:** Build a small eval set of about 20 real prompts across the lanes. Answer each one with and without the skill, and compare the pairs blind against criteria like those in finding 5. Start with prompts where users replied "adjust" or "skip".

### Finding 7: The hook adds status lines to every prompt and lists 3 of 4 lanes

**Evidence (read + git history):**
- **The hook contradicts the skill.** The skill says it "does NOT trigger on mechanical tasks" (`SKILL.md:3`). The hook says to invoke it "for every prompt" (`hooks/skill-directive/skill-directive.sh:21`) and requires three status lines each time:
  - "triggered successfully" (`:17`)
  - a one-sentence summary (`:21`)
  - "No matched Skills" or a list of skills (`:23`)

  A prompt like "commit this" gets all three.
- **It breaks a README promise.** `README.md:127` says mechanical prompts pass through "untouched — no friction", and `README.md:145` says "know when to stay silent".
- **Its lane list was always incomplete.** The hook lists the lanes as "skip/clarify/optimize" (`:21`). Polish was already a lane when the hook was written (`git show 876bbbe:skills/best-minds-optimizer/SKILL.md`, line 14).

**Cost:** Three extra lines and a skill load on every prompt. The harm is small but constant, and it breaks what the README promises. The wrong lane list is a sign of drift rather than a behavior bug, because the skill defines its own lanes.

**Fix:** Keep forcing the skill on every prompt if you want that behavior, but drop the status lines for Skip-lane prompts. Refer to "the skill's triage" instead of naming lanes.

**Status (2026-09-11):** fixed. The shipped trigger is now `best-minds-gate.sh`, which prints nothing for short prompts, adds no status lines, and names no lanes.

## 5. Draft issues

Nothing has been filed. Each issue body will be its finding's Evidence, Cost and Fix, rewritten to stand on its own so it doesn't depend on this doc being committed. Only the issues you approve get filed, with `gh issue create` as described in `docs/agents/issue-tracker.md`.

| # | Title | Done when |
|---|-------|-----------|
| 1 | skill-directive hook: install snippet fails the settings schema and the script isn't executable | The documented snippet passes the `jq -e` check above, and its command exits 0 on a fresh clone |
| 2 | best-minds-optimizer: Review Gate should state the goal and what was added, in plain English | The gate opens with a goal line and a "what I added" line, with the rewritten prompt below |
| 3 | best-minds-optimizer: move the Review Gate into optimize.md and remove the old Step 4 flow | `optimize.md` has the gate as a step and no Direction-shift pause, and both files use the same field names and step numbers |
| 4 | best-minds-optimizer: size checkpoints to stakes and merge the hook's permission question into the gate | A written rule says when the gate is shown, and the hook no longer asks a separate permission question |
| 5 | best-minds-optimizer: define acceptance criteria before answering | The rewrite produces 2–3 criteria, the gate shows them, and the answer is checked against them |
| 6 | best-minds-optimizer: add an eval set comparing answers with and without the skill | Paired results exist for about 20 prompts, with a stated bar for passing |
| 7 | skill-directive hook: no status lines for mechanical prompts; drop the stale lane list | A Skip-lane prompt produces no hook status lines, and the hook names no lanes |

**Already fixed on 2026-09-11:** issues 1 and 7, and the hook half of 4. `hooks/skill-directive/` was replaced by `skills/best-minds-setup/`. Don't file 1 or 7; narrow 4 to the Review Gate.

**Suggested order:** 6 doesn't depend on anything. Do 3 before 2, 4 and 5, since those three all change the gate.
