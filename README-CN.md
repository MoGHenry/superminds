<div align="center">

# Superminds

[English](https://github.com/MoGHenry/superminds/blob/main/README.md) | 中文 | [skills.sh/superminds](https://skills.sh/moghenry/superminds)

</div>

你向 LLM 提的每个问题，得到的都是千篇一律的回答。同样的问题，经过查理·芒格的思维模型重构，或从四个独立视角同时分析，得到的答案截然不同——而且好得多。

Superminds 是一组智能体技能，让你的 AI 智能体在回答之前先*思考*。一个技能通过该领域最顶尖专家的视角重写你的提示词，另一个从四个并行视角——用户中心、产品、文化和教育——分析你的主题，然后综合为统一的分析报告。两者协作，将任何 AI 智能体——无论是编程助手、研究工具还是通用聊天机器人——升级为战略思维伙伴。

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

## 安装

### Claude Code

```bash
npx skills add https://github.com/MoGHenry/superminds --skill best-minds-optimizer
npx skills add https://github.com/MoGHenry/superminds --skill 4d-mind-analyst
```

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

### 协同工作方式

两个技能互为补充：

| 场景 | 触发的技能 | 发生了什么 |
|------|----------|-----------|
| "我的自由职业设计工作应该如何定价？" | Best Minds Optimizer | 选择 Blair Enns，通过定价框架重写，交付专家视角的回答 |
| "分析远程办公的反弹潮" | 4D Mind Analyst | 四个并行智能体分别从用户、产品、文化和教育角度进行分析 |
| "初级开发者岗位消失的深层原因是什么？" | 两者同时 | Optimizer 重构问题；4D Analyst 运行完整的多视角分析 |
| "读取这个文件" / "提交代码" | 都不触发（跳过） | 直接通过——机械性任务零干扰 |

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
