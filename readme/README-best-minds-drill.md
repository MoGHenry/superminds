<div align="center">

# Best Minds Drill — Prompt Habit Trainer

English | [中文](https://github.com/MoGHenry/superminds/blob/main/readme/README-best-minds-drill-CN.md) | [skills.sh](https://skills.sh/moghenry/superminds/best-minds-drill)

</div>

> [!IMPORTANT]
> **Read the starter guide before your first run.**
>
> This skill grades your prompts against three layers — **Spec**, **Verifier** and **Environment** — and assumes you already know what they mean. If you don't, the exercises it writes for you can only be solved by reading the answers.
>
> The guide takes about 15 minutes: each layer explained through a worked example, then 10 exercises that give feedback on the option you pick and tell you whether you're ready. It's in English and Chinese.
>
> After installing, open it in a browser:
>
> ```bash
> open ~/.claude/skills/best-minds-drill/assets/onboarding.html       # macOS
> xdg-open ~/.claude/skills/best-minds-drill/assets/onboarding.html   # Linux
> ```
>
> If you installed the skill into a project, the file is under `.claude/skills/best-minds-drill/assets/` instead. GitHub displays HTML as source code, so open your local copy rather than the file in this repo.

Every guide to prompting tells you the rules. This skill checks whether you follow them — in your own Claude Code sessions.

It reads the prompts you actually typed, finds the turns where you had to correct or re-explain yourself, and names the layer your original prompt was missing. Then it writes a short lesson built from your own quotes, has you write a prompt, and grades it.

## Install

```bash
npx skills add https://github.com/MoGHenry/superminds --skill best-minds-drill
```

Claude Code only: it reads Claude Code transcripts from `~/.claude/projects/`. Requires `bash` and `jq`.

## Use

```
/best-minds-drill <repo name or absolute path>
```

It runs only when you type the command. On your first run it checks for `~/.claude/best-minds-drill/`; if that folder doesn't exist yet, it points you to this README and the starter guide, and asks whether you want to read them before starting.

A run goes like this:

1. **Pick sessions.** It lists that repo's transcripts with turn counts and dates, and you choose which to analyse.
2. **Diagnose.** It finds *correction pairs* — a prompt plus the later turn where you had to fix it — and sweeps every turn for patterns in each layer. You confirm the diagnosis before anything is written.
3. **Lesson.** It writes one self-contained HTML lesson to `docs/learning/NNNN-<name>.html` in your current directory, with at least one drill per layer.
4. **Your answer.** You write the prompt a drill asks for and paste it back. Each layer gets pass, partial or missing; your prompt is compared with the strongest ones you've written before; and you get the single change with the biggest payoff.
5. **Records.** Open problems and metrics are saved to `~/.claude/best-minds-drill/`, so the next run — in any project — can tell you when a habit you'd fixed has come back.

## Privacy

Lessons quote your prompts word for word and are saved into the repo you run the command from. If your sessions contain client data, credentials or anything else sensitive, don't commit `docs/learning/`.

## Why it works this way

The research behind the design — why it drills on your own transcripts instead of invented examples, why exercises mix the layers, and what the evidence does *not* support — is in [`skills/best-minds-drill/references/evidence.md`](../skills/best-minds-drill/references/evidence.md).
