# Domain Docs

How engineering skills consume this repo's domain docs while exploring codebase.

**Layout: single-context.** One `CONTEXT.md` and one `docs/adr/` at repo root.

## Before exploring, read these

- **`CONTEXT.md`** at repo root, or
- **`CONTEXT-MAP.md`** at repo root, if present. It points at one `CONTEXT.md` per context. Read each one relevant to topic.
- **`docs/adr/`**: read ADRs touching area you work in. In multi-context repos, also check `src/<context>/docs/adr/` for context-scoped decisions.

If any file missing, **proceed silently**. Don't flag absence. Don't suggest creating files upfront. `/domain-modeling` skill (reached via `/grill-with-docs` and `/improve-codebase-architecture`) creates files lazily, when terms or decisions get resolved.

## File structure

```
/
├── CONTEXT.md
├── docs/adr/
│   ├── 0001-<decision-slug>.md
│   └── 0002-<decision-slug>.md
└── skills/
```

## Use glossary vocabulary

When output names domain concept (issue title, refactor proposal, hypothesis, test name), use term as defined in `CONTEXT.md`. Don't drift to synonyms glossary explicitly avoids.

If concept missing from glossary, treat as signal. Either you invent language project doesn't use (reconsider), or real gap exists (note gap for `/domain-modeling`).

## Flag ADR conflicts

If output contradicts existing ADR, surface conflict explicitly. Don't override silently:

> _Contradicts ADR-0007 (event-sourced orders), but worth reopening because…_
