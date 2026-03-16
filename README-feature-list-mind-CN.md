<div align="center">

# Feature List Mind

[English](https://github.com/MoGHenry/superminds/blob/main/README-feature-list-mind.md) | 中文 | [skills.sh](https://skills.sh/moghenry/superminds/feature-list-mind)

</div>

在大型项目中跨多个上下文窗口工作的 Agent 会在会话之间丢失记忆。它们要么试图一次性完成所有事情（过度雄心），要么在项目尚未完成时就宣布完成（过早结束）。Feature List Mind 通过建立 JSON 功能列表作为唯一的事实来源、会话初始化协议来恢复状态，以及增量提交纪律来解决这个问题。

基于 Anthropic 关于[长时间运行 Agent 的有效约束](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)的研究中的模式。

## 工作原理

该技能有两种模式：

**初始化模式** — 启动新项目时，它会将你的描述扩展为一个细粒度、可测试的功能列表（`features.json`），按阶段（基础、MVP、核心、打磨）组织。它会创建进度文件，进行初始 git 提交，并在开始任何实现之前展示完整的功能列表供你审查。

**恢复模式** — 返回现有项目时（或 `features.json` 已存在时），它会运行会话初始化序列：读取功能列表、检查 git 历史、报告阶段进度、使用关键路径感知选择下一个最高优先级的功能，并在开始之前宣布意图。

```
会话启动 → 读取 features.json → 报告阶段进度 → 选择下一个功能 → 实现 → 验证 → 提交 → 更新跟踪器 → 再次提交
```

## 使用前后对比

**没有 Feature List Mind：**
```
会话 1：Agent 构建登录页面、导航，并开始做仪表盘
会话 2：Agent 看到一些代码，添加几个功能，宣布"看起来不错！"
会话 3：Agent 重建会话 1 的部分内容，因为它不记得之前做了什么
结果：半成品项目，无法追踪哪些有效哪些无效
```

**有 Feature List Mind：**
```
会话 1：Agent 创建包含 47 个功能、4 个阶段的 features.json，实现 F001（脚手架）
会话 2：Agent 读取 features.json → "阶段 1（MVP）：2/12 通过，总体 42.5%" → 选择 F003 → 验证 → 提交
会话 3：Agent 读取 features.json → "阶段 1（MVP）：5/12 通过" → 选择 F006（阻塞其他 3 个） → 验证 → 提交
结果：稳定、可审计的进展，每个功能都经过验证、提交和阶段跟踪
```

## 功能列表

功能按**阶段**（交付里程碑）组织，并通过双向依赖关系进行跟踪：

```json
{
  "phases": [
    { "id": "phase-0", "name": "Foundation", "status": "complete" },
    { "id": "phase-1", "name": "MVP", "status": "in_progress" }
  ],
  "current_phase": "phase-1",
  "features": [
    {
      "id": "F003",
      "phase": "phase-1",
      "category": "functional",
      "priority": "high",
      "description": "新建聊天按钮创建一个新的对话",
      "depends_on": ["F001"],
      "blocks": ["F007", "F008"],
      "steps": [
        "导航到主界面",
        "点击'新建聊天'按钮",
        "验证新对话已创建，消息区域为空",
        "检查聊天区域显示欢迎状态",
        "验证新对话出现在侧边栏列表中"
      ],
      "status": "not_started"
    }
  ],
  "summary": {
    "total": 47,
    "passing": 5,
    "completion_percentage": 10.6,
    "by_phase": {
      "phase-0": { "total": 4, "passing": 4 },
      "phase-1": { "total": 12, "passing": 1 }
    }
  }
}
```

## 核心原则

- **阶段优先于功能** — 工作按交付里程碑组织（基础 → MVP → 核心 → 打磨）；完成当前阶段后再开始下一个
- **每次会话一个功能** — 完成并验证一个功能后再进入下一个
- **关键路径优先** — 在优先级相同的功能之间选择时，选择能解锁最多下游工作的那个
- **INVEST 就绪性** — 每个功能在进入列表前都需检查独立性（Independence）、可协商性（Negotiability）、价值（Value）、可估算性（Estimability）、小巧性（Smallness）和可测试性（Testability）
- **验证步骤不可变** — 永远不要修改测试来适配有问题的代码；修复代码本身
- **双重提交模式** — 一次提交代码，一次提交跟踪更新
- **信任 JSON，不信记忆** — 在报告进度前始终重新读取 `features.json`
- **永远不删除功能** — 将它们标记为通过、阻塞或已替代

## 安装

### Claude Code

```bash
npx skills add https://github.com/MoGHenry/superminds --skill feature-list-mind
```

或者将 `skills/feature-list-mind/` 目录复制到你的 Agent 技能文件夹中：

| Agent | 项目路径 | 全局路径 |
|-------|---------|---------|
| Claude Code | `.claude/skills/` | `~/.claude/skills/` |
| Cursor | `.agents/skills/` | `~/.cursor/skills/` |
| Codex | `.agents/skills/` | `~/.codex/skills/` |

## 目录结构

```
skills/feature-list-mind/
├── SKILL.md                     — 核心技能：两种模式、循环流程、常见错误
└── references/
    ├── init-protocol.md         — 阶段规划、功能扩展、INVEST 检查、用户审查关卡
    ├── session-resume.md        — 会话初始化序列、阶段感知选择、关键路径、状态恢复
    ├── feature-schema.md        — JSON 模式定义、阶段、INVEST 标准、粒度指南、状态转换
    ├── completion-protocol.md   — 端到端验证、双重提交、会话收尾
    └── failure-guards.md        — 防止过早完成、范围蔓延、测试篡改的保护机制
```
