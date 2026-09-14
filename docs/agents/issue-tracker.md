# Issue tracker: GitHub

Issues and specs live as GitHub issues. Use `gh` CLI for all operations.

## Conventions

- **Create issue**: `gh issue create --title "..." --body "..."`. Use heredoc for multi-line body.
- **Read issue**: `gh issue view <number> --comments`. Filter comments with `jq`. Fetch labels too.
- **List issues**: `gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'`. Add `--label` and `--state` filters as needed.
- **Comment on issue**: `gh issue comment <number> --body "..."`
- **Apply / remove labels**: `gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **Close**: `gh issue close <number> --comment "..."`

Infer repo from `git remote -v`. `gh` does this automatically inside clone.

## Pull requests as a triage surface

**PRs as a request surface: no.** _(Set `yes` if repo treats external PRs as feature requests. `/triage` reads this flag.)_

When `yes`, PRs use same labels and states as issues, via `gh pr` equivalents:

- **Read PR**: `gh pr view <number> --comments`. Diff: `gh pr diff <number>`.
- **List external PRs for triage**: `gh pr list --state open --json number,title,body,labels,author,authorAssociation,comments`. Keep only `authorAssociation` of `CONTRIBUTOR`, `FIRST_TIME_CONTRIBUTOR`, or `NONE`. Drop `OWNER`/`MEMBER`/`COLLABORATOR`.
- **Comment / label / close**: `gh pr comment`, `gh pr edit --add-label`/`--remove-label`, `gh pr close`.

Issues and PRs share one number space. Bare `#42` may be either. Try `gh pr view 42`, fall back to `gh issue view 42`.

## When a skill says "publish to the issue tracker"

Create GitHub issue.

## When a skill says "fetch the relevant ticket"

Run `gh issue view <number> --comments`.

## Wayfinding operations

Used by `/wayfinder`. **Map**: one issue. Tickets: **child** issues.

- **Map**: single issue labelled `wayfinder:map`. Body holds Notes / Decisions-so-far / Fog. Create with `gh issue create --label wayfinder:map`.
- **Child ticket**: issue linked to map as GitHub sub-issue (`gh api` on sub-issues endpoint). If sub-issues not enabled, add child to task list in map body and put `Part of #<map>` at top of child body. Labels: `wayfinder:<type>` (`research`/`prototype`/`grilling`/`task`). Claimed ticket gets assigned to driving dev.
- **Blocking**: GitHub **native issue dependencies**, canonical UI-visible representation. Add edge with `gh api --method POST repos/<owner>/<repo>/issues/<child>/dependencies/blocked_by -F issue_id=<blocker-db-id>`. `<blocker-db-id>` is blocker's numeric **database id** (`gh api repos/<owner>/<repo>/issues/<n> --jq .id`), _not_ `#number` or `node_id`. `issue_dependencies_summary.blocked_by` counts open blockers only; that count is live gate. If dependencies not available, fall back to `Blocked by: #<n>, #<n>` line at top of child body. Ticket unblocked when every blocker closed.
- **Frontier query**: list map's open children (`gh issue list --state open`, scoped to map's sub-issues / task list). Drop children with open blocker (`issue_dependencies_summary.blocked_by > 0`, or open issue in `Blocked by` line). Drop children with assignee. First in map order wins.
- **Claim**: `gh issue edit <n> --add-assignee @me`. Must be session's first write.
- **Resolve**: `gh issue comment <n> --body "<answer>"`, then `gh issue close <n>`, then append context pointer (gist + link) to map's Decisions-so-far.
