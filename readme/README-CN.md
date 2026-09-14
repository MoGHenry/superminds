<div align="center">

# Superminds

[English](https://github.com/MoGHenry/superminds/blob/main/README.md) | 中文 | [skills.sh/superminds](https://skills.sh/moghenry/superminds)

</div>

你向 LLM 提的每个问题，得到的都是千篇一律的回答。同样的问题，经过查理·芒格的思维模型重构，或从四个独立视角同时分析，得到的答案截然不同——而且好得多。

Superminds 是一组智能体技能，让你的 AI 智能体在回答之前先*思考*。一个技能通过该领域最顶尖专家的视角重写你的提示词，另一个从四个并行视角——用户中心、产品、文化和教育——分析你的主题，然后综合为统一的分析报告。第三个技能通过功能列表、会话初始化协议和增量提交纪律，管理跨多个上下文窗口的长时间智能体工作。三者协作，将任何 AI 智能体——无论是编程助手、研究工具还是通用聊天机器人——升级为战略思维伙伴。

## 安装

### Claude Code

```bash
npx skills add https://github.com/MoGHenry/superminds --skill best-minds-optimizer
npx skills add https://github.com/MoGHenry/superminds --skill 4d-mind-analyst
npx skills add https://github.com/MoGHenry/superminds --skill feature-list-mind
```

#### 让 Best Minds Optimizer 自动触发

只安装技能还不够——是否加载由 Claude 自行决定。如果希望它在每个实质性提示词上都被调用，需要再安装触发器，即一个 `UserPromptSubmit` 钩子：

```bash
npx skills add https://github.com/MoGHenry/superminds --skill best-minds-setup
```

然后在 Claude Code 中运行 `/best-minds-setup`，并选择作用域：

| 作用域 | 配置文件 | 生效范围 |
|-------|---------|---------|
| `user` | `~/.claude/settings.json` | 你的所有项目 |
| `project` | `<项目>/.claude/settings.local.json` | 仅你，且仅在当前项目 |
| `project-shared` | `<项目>/.claude/settings.json` | 该仓库的所有协作者（会提交到 git） |

触发器只对实质性提示词开口：50 字符以上、10 个词以上、以问号结尾，或包含 "best minds" 之类的显式短语。像"提交代码"这样的简短指令会被直接放行，不产生任何开销。需要预先安装 `jq`。随时可用 `/best-minds-setup uninstall` 移除。

#### 可选：让第一步判断更便宜

`best-minds-triage` 负责判断一个提示词是否值得优化。它在隔离的子智能体中以小模型运行，只返回一个通道（lane），因此会话模型只为真正需要优化的提示词付费：

```bash
npx skills add https://github.com/MoGHenry/superminds --skill best-minds-triage
```

仅适用于 Claude Code，因为它依赖 `context: fork`。不安装也没问题——`best-minds-optimizer` 会自行在会话模型上完成分流，同时保持对 Cursor 和 Codex 的可移植性。

#### 训练你自己的提示词习惯

`best-minds-drill` 会读你在过去的 Claude Code 会话里打过的提示词，找出你不得不回头纠正、重新解释的那些轮次，并指出原来那条提示词缺的是哪一层：Spec、Verifier 还是 Environment。然后用你自己的原话写一份简短的课，让你写一条提示词，再给它打分：

```bash
npx skills add https://github.com/MoGHenry/superminds --skill best-minds-drill
```

第一次运行前，请先读完入门指南，因为这些练习默认你已经懂这三层。指南是随 skill 一起安装的本地 HTML 文件，打开方式见 [best-minds-drill 的 README](README-best-minds-drill-CN.md)。读完再运行 `/best-minds-drill <仓库名或绝对路径>`。

仅适用于 Claude Code，因为它读取的是 Claude Code 的对话记录；需要 `bash` 和 `jq`。课里会逐字引用你的提示词，并保存在你运行命令的那个仓库的 `docs/learning/` 下；如果会话里有敏感内容，不要提交这个文件夹。

或者手动安装，将技能目录复制到你的智能体技能文件夹中：

[Github/superminds](https://github.com/MoGHenry/superminds)

| 智能体 | 项目路径 | 全局路径 |
|-------|---------|---------|
| Claude Code | `.claude/skills/` | `~/.claude/skills/` |
| Cursor | `.agents/skills/` | `~/.cursor/skills/` |
| Codex | `.agents/skills/` | `~/.codex/skills/` |

### 验证安装

启动一个新会话，提一个实质性问题（例如"我的 SaaS 产品应该如何定价？"）。智能体应自动调用 Best Minds Optimizer。要测试 4D 分析，可以问类似"从不同角度分析 AI 编程智能体的崛起"。

## 包含内容

### 技能库

**思维增强**
- **[best-minds-optimizer](README-best-minds-optimizer-CN.md)** — 提示词优化器，为你的问题找到全球最顶尖的领域专家，通过其思维框架重写提示词，以通俗易懂的语言交付答案并附带具体的下一步行动。支持四条通道：跳过、润色、澄清和优化。
- **[4d-mind-analyst](README-4d-mind-analyst-CN.md)** — 多视角分析引擎，调度四个并行智能体——用户中心思维、产品思维、选题思维和课程思维——然后将各自独立的分析综合为统一的分层输出。

**智能体工作流**
- **[feature-list-mind](README-feature-list-mind-CN.md)** — 人机协同（Human-AI Collaborative）的会话连续性协议，用于长时间智能体工作。**这不是完全自动化的流程**——LLM 负责实现和验证，但只有人类用户才有权标记功能为完成。管理 JSON 功能列表、会话初始化序列、增量提交纪律、项目测试套件验证和用户通知关卡。需要在项目 `CLAUDE.md` 中配置 Project State Protocol。基于 Anthropic 的[长时间运行 Agent 的有效约束](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)。

**提示词练习**
- **[best-minds-drill](README-best-minds-drill-CN.md)** — 基于你自己 Claude Code 对话记录的提示词习惯训练。找出*纠正对*——一条提示词，加上后来你不得不回头修正它的那一轮——并指出原来那条缺的是哪一层（Spec、Verifier 或 Environment）。然后用你自己的原话写一份简短的 HTML 课，给你写回来的提示词打分，并跨项目保存记录，在你改掉的习惯又回来时指出来。附带一份中英双语的入门指南，第一次使用前先读。

### 协同工作方式

技能互为补充：

| 场景 | 触发的技能 | 发生了什么 |
|------|----------|-----------|
| "我的自由职业设计工作应该如何定价？" | Best Minds Optimizer | 选择 Blair Enns，通过定价框架重写，交付专家视角的回答 |
| "分析远程办公的反弹潮" | 4D Mind Analyst | 四个并行智能体分别从用户、产品、文化和教育角度进行分析 |
| "初级开发者岗位消失的深层原因是什么？" | 两者同时 | Optimizer 重构问题；4D Analyst 运行完整的多视角分析 |
| "帮我构建一个全栈聊天应用" | Feature List Mind | 扩展为 50+ 细粒度功能，跨会话跟踪进度 |
| "继续上次的工作" | Feature List Mind | 读取 features.json，选择下一个优先功能，宣布意图 |
| "读取这个文件" / "提交代码" | 都不触发（跳过） | 直接通过——机械性任务零干扰 |

## 工作原理

当你提出实质性问题的那一刻，Superminds 就开始工作。技能会根据你的输入自动触发——你不需要做任何额外操作。

### **Best Minds Optimizer（最强大脑优化器）**  | [skills.sh/superminds/best-minds-optmizer](https://skills.sh/moghenry/superminds/best-minds-optimizer)

拦截每个提示词，执行四通道分流：

```
输入 → 分流（跳过 | 润色 | 澄清 | 优化）→ 专家视角回答
```

- **跳过** — 机械性任务直接通过，零干扰。
- **润色** — 用户撰写的文本获得快速措辞优化，保留原有风格。
- **澄清** — 模糊问题先通过针对性的选择题收集上下文。
- **优化** — 实质性问题走完整流程：逻辑映射 → 专家选择 → 提示词重写 → 通俗易懂的回答。

### **4D Mind Analyst（4D 思维分析师）** | [skills.sh/superminds/4d-mind-analyst](https://skills.sh/moghenry/superminds/4d-mind-analyst)

在你需要多维度分析时激活：

```
输入 → 视角选单 → 并行智能体 → 综合分析 → 分层输出
```

四个独立智能体同时进行分析，然后由综合智能体整合洞察——发现共识、张力和盲区，这些是任何单一视角都无法独自看到的。

### **Feature List Mind（功能列表思维）** | [skills.sh/superminds/feature-list-mind](https://skills.sh/moghenry/superminds/feature-list-mind)

通过人机协同验证管理长时间智能体工作：

```
恢复 → 选择功能 → 实现 → 验证（步骤 + 测试套件）→ 提交 → 通知用户 → 更新（用户授权后）→ 再次提交
```

- **人机协同** — LLM 负责实现和运行验证，但只有人类用户才能授权标记功能为完成
- **LLM 对 `features.json` 仅有读取权限** — 智能体读取跟踪器获取状态，但不能独立编辑状态字段
- **验证先于通知** — 功能特定步骤和项目测试套件都必须通过后，才能通知用户

#### 必要的 CLAUDE.md 配置

Feature List Mind 需要在项目根目录的 `CLAUDE.md` 中添加配置，以强制执行人机协同协议：

```markdown
## Project State Protocol

### 1. Mandatory Initialization
Before executing any planning, implementation, or debugging request, you MUST read
features.json and PROGRESS.md to establish the current project state.

### 2. Single Source of Truth
features.json is the definitive record of features, phases, and dependencies.
Do not rely on memory or implicit context. LLM only have the READ privilege
to features.json, no EDIT privilege.

### 3. Human-in-the-Loop Verification
You are prohibited from marking any feature as passes or updating completion
metrics independently. Only the human user holds the authority to verify a
feature and authorize a status change.

### 4. Dependency Enforcement
Prior to starting work on any feature, you must verify in features.json that
all of its listed depends_on features are marked as passes. If dependencies
are incomplete, halt and notify the user.
```

此配置确保 LLM 不能静默推进项目状态。每次状态转换都需要明确的人类授权。

### **Best Minds Drill（提示词习惯训练）** | [skills.sh/superminds/best-minds-drill](https://skills.sh/moghenry/superminds/best-minds-drill)

只有你输入 `/best-minds-drill <仓库名或绝对路径>` 时才会运行，练的是你自己过去的会话：

```
选会话 → 诊断 → 写课 → 你写提示词 → 打分（Spec | Verifier | Environment）→ 记录
```

- **用你自己的原话当证据** — 报告的每个问题都是你打过的一条提示词，附带日期，旁边是你后来不得不回头修正它的那一轮
- **只给一处修改** — 每一层给出 pass、partial 或 missing，最后只给你收益最大的那一处修改
- **复发检测** — 记录保存在 `~/.claude/best-minds-drill/`，改掉的习惯又回来时，不管在哪个项目都会被指出

## 核心模式

| 模式 | 应用方式 |
|------|---------|
| 专家选择 | 两个技能都识别具体的、有名有姓的现实世界专家——绝不使用"某领域专家" |
| 并行智能体 | 4D Analyst 同时运行所有视角，提升分析速度 |
| 渐进式加载 | 每次调用只加载分流逻辑——详细指令按需加载 |
| 双语执行 | 内部推理使用高密度专业术语；面向用户的输出清晰易读 |
| 分层输出 | 为快速浏览者提供执行摘要，为深入研究者提供完整分析 |
| 自动分流 | 技能知道何时不该介入——机械性任务零干扰 |

## 设计理念

- **专家视角优于泛泛而谈** — 通过查理·芒格框架提出的问题，与模糊提示得到的答案截然不同
- **具体优于抽象** — 有名有姓的专家、具体的框架、可执行的下一步
- **先独立，后综合** — 各视角先独立运作；矛盾与碰撞中揭示出单一视角无法看到的洞察
- **该沉默时就沉默** — 最好的技能，是在不需要时完全不添加任何干扰

## 参与贡献

技能直接存放在本仓库中。参与贡献：

1. Fork 本仓库
2. 为你的技能或改进创建一个分支
3. 遵循现有的技能结构（`SKILL.md` + `references/` 模式）
4. 提交 PR

## 许可证

GPL-3.0 License — 详见 LICENSE 文件。

## 支持

- **问题反馈**: https://github.com/MoGHenry/superminds/issues
- **技能目录**: [skills.sh/superminds](https://skills.sh/moghenry/superminds)
