<div align="center">

# Best Minds Drill — 提示词习惯训练

[English](https://github.com/MoGHenry/superminds/blob/main/readme/README-best-minds-drill.md) | 中文 | [skills.sh](https://skills.sh/moghenry/superminds/best-minds-drill)

</div>

> [!IMPORTANT]
> **第一次使用前，请先读完入门指南。**
>
> 这个 skill 按 **Spec**、**Verifier**、**Environment** 三层给你的提示词打分，并且默认你已经懂这三层。如果不懂，它为你出的练习题，你只能看答案才能做。
>
> 指南大约 15 分钟：每一层用一个完整的例子讲清楚，最后 10 道练习会根据你选的选项给出分析，并告诉你是否准备好了。支持中文和英文。
>
> 安装之后，用浏览器打开：
>
> ```bash
> open ~/.claude/skills/best-minds-drill/assets/onboarding.html       # macOS
> xdg-open ~/.claude/skills/best-minds-drill/assets/onboarding.html   # Linux
> ```
>
> 如果你把 skill 装在了项目里，文件在 `.claude/skills/best-minds-drill/assets/` 下。GitHub 会把 HTML 显示成源代码，请打开你本地的那一份，而不是这个仓库里的文件。

所有提示词指南都在告诉你规则。这个 skill 检查的是你有没有照做——在你自己的 Claude Code 会话里。

它读你真正打过的提示词，找出你不得不回头纠正、重新解释的那些轮次，指出原来那条提示词缺的是哪一层。然后用你自己的原话写一份简短的课，让你写一条提示词，再给它打分。

## 安装

```bash
npx skills add https://github.com/MoGHenry/superminds --skill best-minds-drill
```

仅支持 Claude Code：它读取 `~/.claude/projects/` 下的 Claude Code 对话记录。需要 `bash` 和 `jq`。

## 使用

```
/best-minds-drill <仓库名或绝对路径>
```

只有你输入这条命令时它才会运行。第一次运行时，它会先检查 `~/.claude/best-minds-drill/` 是否存在；如果还不存在，它会把你引到这份 README 和入门指南，并问你要不要先读完再开始。

一次完整的流程是：

1. **选会话。**列出这个仓库的对话记录，附带轮数和日期，由你决定分析哪几份。
2. **诊断。**找出*纠正对*——一条提示词，加上后来你不得不回头修正它的那一轮——再逐轮扫一遍每一层的常见问题。诊断要你确认之后，才会开始写课。
3. **写课。**在当前目录的 `docs/learning/NNNN-<名称>.html` 写一份自包含的 HTML 课，每一层至少一道练习。
4. **你来答。**按练习要求写一条提示词，贴回会话。每一层给出 pass、partial 或 missing；你的提示词会和你以前写过的最好的几条放在一起比；最后给你收益最大的那一处修改。
5. **记录。**未解决的问题和各项指标保存在 `~/.claude/best-minds-drill/`，所以下一次运行——不管在哪个项目——都能告诉你某个改掉的习惯是不是又回来了。

## 隐私

课里会逐字引用你的提示词，并保存在你运行命令的那个仓库里。如果你的会话里有客户数据、凭证或其他敏感内容，不要提交 `docs/learning/`。

## 为什么这样设计

设计背后的研究依据——为什么用你自己的对话记录练，而不是用编出来的例子；为什么练习要把三层打乱；以及哪些说法*没有*证据支持——见 [`skills/best-minds-drill/references/evidence.md`](../skills/best-minds-drill/references/evidence.md)。
