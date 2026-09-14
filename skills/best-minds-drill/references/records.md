# Records

Two files under `~/.claude/best-minds-drill/`:

- `current.md` — problems seen in the most recent run and still open
- `archive.md` — problems that have been cleared, kept for relapse detection

User scope, not repo scope, on purpose: these are the user's habits, not a project's, and the next relapse will surface in whichever repo they happen to open.

## Entry format

Identical in both files, so moving an entry is a cut and paste:

```markdown
## P-spec-goal-missing
- **Layer**: Spec
- **Problem**: Names the artifact, not the decision it serves.
- **First seen**: 2026-03-02 · example-app
- **Last seen**: 2026-04-18 · example-app
- **Cleared**: 2026-05-30        ← archive.md only
- **Evidence**: `做 #12` → two turns later: `重新算，只看付费用户，按月留存…`
- **Cost**: 2 turns
```

Append a metrics block to `current.md` each run, never overwriting the last, so the series is readable:

```markdown
## Metrics
| Date | Source | task_turns | why_rate | criteria_rate | pairs | turns_burnt | median_chars |
|------|--------|-----------:|---------:|--------------:|------:|------------:|-------------:|
| 2026-04-18 | example-app ×3 | 96 | 18% | 11% | 9 | 21 | 62 |
```

## Each run

1. **Read both files** before diagnosing, and hold the open IDs in mind while reading the transcripts. Reuse an ID whenever the evidence matches it; a problem renamed is a problem that looks new forever.
2. **Still present** — update `Last seen` and add the fresh quote. Say how long it has been open.
3. **Gone** — the pattern is absent from material that would have shown it. Move the entry to `archive.md` with a `Cleared` date, and tell the user which one closed and what the numbers did. Absence from a three-turn session is not evidence; say "not enough material" instead of clearing it.
4. **Relapse** — an ID in `archive.md` matching fresh evidence. Move it back to `current.md`, keep the original `First seen`, and add a `Relapsed` line with both dates. Lead the lesson with it: a mistake the user remembers making is a stronger cue than any rule, and it costs nothing to deliver.
5. **New** — coin an ID per [`diagnosis.md`](diagnosis.md) §4 and add it to `current.md`.

Keep both files small enough to read whole. When `archive.md` passes about thirty entries, fold the oldest cleared ones into a single summary table of ID, layer and dates, keeping the full entries for anything that has ever relapsed.
