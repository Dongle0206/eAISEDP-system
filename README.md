# 企业级多智能体协作体系配置（三层架构）

> 一套面向**企业级软件工程智能化交付**的多智能体协作体系，采用**三层架构**：
> - **L3 战略层**——企业架构、技术战略、投资治理
> - **L2 项目群层**——多项目协同、工程标准化、交付效能度量
> - **L1 战术层**——单 case 全生命周期交付（13 个角色流水线）
>
> 从"做不做、投多少"（L3）到"多项目怎么协同"（L2）到"一个需求怎么交付"（L1），端到端覆盖企业级软件工程。
>
> 本配置与具体项目解耦——所有项目专属约定不硬编码，由项目级 `CLAUDE.md` 运行时注入，同一套配置可用于任何规模的项目（小到单 case，大到企业级变革项目）。

## 三层架构总览

```
┌──────────────────────────────────────────────────────────┐
│ L3 战略层   /企业架构  /战略投资                            │
│   EA企业架构师 · 战略投资分析师                              │
│   skills: enterprise-architecture / tech-radar             │
│   职责: 架构蓝图 · 技术战略 · ROI · 投资优先级 · ADR        │
└────────────────────────────┬─────────────────────────────┘
                             │ 下达战略约束 & 架构原则
┌────────────────────────────┴─────────────────────────────┐
│ L2 项目群层  /项目群协同                                    │
│   PgM项目群经理 · 方法论标准负责人 · 价值流分析师            │
│   skills: program-management / engineering-standards / devops-metrics │
│   职责: 项目群拆解 · 多编排者协调 · 工程标准 · 交付效能     │
└────────────────────────────┬─────────────────────────────┘
                             │ 派发子项目 & 下达标准
┌────────────────────────────┴─────────────────────────────┐
│ L1 战术层   /团队开发                                       │
│   编排者 → PO UX BA DBA Dev Reviewer Security QA Perf SRE Analyst Ops PM │
│   skills: team-orchestrator                                │
│   职责: 单 case 全生命周期交付                              │
└──────────────────────────────────────────────────────────┘
                             │ 横向贯穿
┌──────────────────────────────────────────────────────────┐
│ 跨层公共能力  knowledge-management / dependency-impact / compliance-audit │
│   组织知识库 · 全局依赖影响 · 合规审计链                     │
└──────────────────────────────────────────────────────────┘
```

**三层独立命令触发**：用哪层调哪层，互不干扰。`/团队开发`（L1）、`/项目群协同`（L2）、`/企业架构`+`/战略投资`（L3）。

---

## 它解决什么问题

单 Agent 模式下，一个 AI 同时扮演需求、设计、编码、测试、部署所有角色：

| 痛点 | 表现 |
|---|---|
| 角色串味 | 写完代码自己评审，等于没评审 |
| 上下文爆炸 | 一个会话塞 PRD + 代码 + 测试，越往后越糊 |
| 质量无门禁 | 没有强制卡点，AI 自己说"已完成"就算完成 |
| 经验不复用 | 每次都从零开始，踩过的坑反复踩 |
| 协作不可审计 | 改了什么、谁改的、为何改，全凭一张嘴 |

核心思想：**把一个全能 AI 拆成有明确分工的专家子智能体，由编排者统一调度**，配合强制检查点 + 模型隔离 + 经验记忆闭环。

---

## 三个核心概念

| 概念 | 是什么 | 类比 |
|---|---|---|
| 子智能体（Agent） | 有特定角色 Prompt + 模型配置的"专家"，由主 Agent 派生 | 团队里的一个岗位 |
| 技能（Skill） | 可复用的标准操作流程（SKILL.md），主 Agent 加载后执行或注入子智能体 | 岗位的 SOP 手册 |
| 编排者方法论 | 描述"何时派谁、阶段怎么串、检查点在哪"的总纲 | 公司的研发流程 |

---

## 目录结构

```
agents-config/                        ← 团队共享权威源（随仓库走，install 到用户级）
├── README.md                          ← 本文件
├── install.sh                         ← 安装脚本（macOS/Linux/Git Bash）
├── install.ps1                        ← 安装脚本（Windows PowerShell）
│
├── agents/                            ← 18 个角色子智能体定义（源文件，需安装到用户目录）
│   │
│   │ ===== L3 战略层 =====
│   ├── team-ea.md                     企业架构师（opus）
│   ├── team-strategy.md               战略投资分析师（opus）
│   │
│   │ ===== L2 项目群层 =====
│   ├── team-pgm.md                    项目群经理（opus）
│   ├── team-standards.md              方法论标准负责人（sonnet）
│   ├── team-vsm.md                    价值流分析师（sonnet）
│   │
│   │ ===== L1 战术层（核心 8 + 专项 5）=====
│   ├── team-po.md                     产品经理（opus）
│   ├── team-ux.md                     UX 设计师（opus）
│   ├── team-ba.md                     需求分析员（sonnet）
│   ├── team-dba.md                    数据库工程师（sonnet）★ 按需介入
│   ├── team-dev.md                    全栈开发（sonnet）
│   ├── team-reviewer.md               代码评审（opus，须与 Dev 不同模型）
│   ├── team-security.md               安全工程师（opus，须与 Dev 不同模型）★ 按需介入
│   ├── team-qa.md                     测试工程师（sonnet）
│   ├── team-performance.md            性能工程师（sonnet）★ 按需介入
│   ├── team-sre.md                    可靠性工程师（sonnet）★ 上线前介入
│   ├── team-analyst.md                产品分析师（sonnet）★ 双阶段介入
│   ├── team-ops.md                    项目助手/部署/git 归档（haiku）
│   └── team-pm.md                     项目经理（sonnet）
│
│   ★ = 按层级/触发条件介入，详见各层方法论
│
├── commands/                          ← 斜杠命令（安装到 ~/.zcode/commands/）
│   ├── team-dev.md                    /团队开发（L1）
│   ├── program-collab.md              /项目群协同（L2）
│   ├── enterprise-arch.md             /企业架构（L3）
│   └── strategy-invest.md             /战略投资（L3）
│
└── skills/                            ← 技能定义（需安装到用户目录）
    │ ===== L3 战略层 =====
    ├── enterprise-architecture/       企业架构方法论
    │   └── SKILL.md
    ├── tech-radar/                    技术雷达/投资治理
    │   └── SKILL.md
    │ ===== L2 项目群层 =====
    ├── program-management/            项目群治理
    │   └── SKILL.md
    ├── engineering-standards/         工程标准体系
    │   └── SKILL.md
    ├── devops-metrics/                交付效能度量
    │   └── SKILL.md
    │ ===== L1 战术层 =====
    ├── team-orchestrator/             编排者方法论（含经验记忆闭环）
    │   └── SKILL.md
    │ ===== 横向跨层 =====
    ├── knowledge-management/          组织级知识管理
    │   └── SKILL.md
    ├── dependency-impact/             全局依赖影响分析
    │   └── SKILL.md
    └── compliance-audit/              合规审计
        └── SKILL.md
```

> 业务技能（打包/部署/迁移等）是**项目特定的、按需编写**的，不在通用版内。使用方按自己技术栈在 `skills/` 下补充即可（如 `skills/build/`、`skills/deploy/`），install 脚本会自动一并安装。

---

## 快速开始

### 1. 安装子智能体与技能

**macOS / Linux / Git Bash：**
```bash
bash agents-config/install.sh
```

**Windows PowerShell（兼容 5.x 与 7+）：**
```powershell
powershell -ExecutionPolicy Bypass -File .\agents-config\install.ps1
```

仅检查环境不安装：
```bash
bash agents-config/install.sh --check          # bash
powershell -ExecutionPolicy Bypass -File .\agents-config\install.ps1 -Check   # PowerShell
```

### 2. 重启 ZCode

安装后重启 ZCode，让子智能体与技能生效。

### 3. 验证

- **ZCode 设置 → 子智能体**：应看到 8 个 `team-*`
- 主对话输入 `/团队开发 测试一下` 或 `$team-orchestrator`：应触发编排者

### 4. 开始使用

主对话输入：
```
/团队开发 把当前工程的 README 补充部署章节
```
编排者会按 PO → UX → BA → Dev → Reviewer → QA → Ops 全流程派生子智能体协作完成。

---

## 配置的加载机制（重要）

| 配置类型 | 仓库源路径 | 是否需安装 | 加载方式 |
|---|---|---|---|
| **子智能体** | `agents-config/agents/*.md` | ✅ 需 install 到 `~/.zcode/agents/` | 用户级加载 |
| **编排者技能** | `agents-config/skills/team-orchestrator/` | ✅ 需 install 到 `~/.zcode/skills/` | 用户级技能 |
| **业务技能** | `agents-config/skills/*`（除 orchestrator，按需自建） | ✅ 需 install 到 `~/.zcode/skills/` | 用户级技能 |
| **斜杠命令** | `agents-config/commands/*.md` | ✅ 需 install 到 `~/.zcode/commands/` | 用户级命令 |

### ⚠️ 避免同名冲突（重要经验）

ZCode 会**同时加载工程级 `.zcode/` 和用户级 `~/.zcode/`** 的 agents/skills。两处都放同名定义会引发冲突：
- agents 同名 → 解析异常 → 整组不显示
- skills 同名 → 界面显示两份

**预防规则**：
- ✅ agents 和 skills 定义**只放两处**：仓库源 `agents-config/`（团队基线）+ 用户级 `~/.zcode/`（IDE 加载处）。
- ❌ **禁止在工程级 `<工程>/.zcode/` 放 agents 或 skills 定义**。工程级 `.zcode/` 只放 `runtime/`（运行时状态）。
- ✅ 改完 `agents-config/` 后必须跑 install 脚本同步到用户级。
- ✅ install 后必须重启 IDE 才能生效。
- ⚠️ `model` 字段：仓库源用内置别名（`sonnet/haiku/opus`，团队通用）；用户在界面手选模型后，用户级会被回写成 `custom:<uuid>:<name>` 格式——这是正常的，不要手改回内置别名。

依据：[ZCode Skill 文档](https://zcode.z.ai/cn/docs/skill)、[ZCode Subagent 文档](https://zcode.z.ai/cn/docs/subagents)。

---

## 子智能体与技能的关系

```
用户在主对话输入
   /团队开发 <需求>            ← 斜杠命令触发编排者技能（主 Agent 加载）
        │
        ├─ 主 Agent（编排者）按方法论派生子智能体
        │   ├─ PM 子智能体          （sonnet） 全程 看板/风险/变更登记
        │   ├─ PO 子智能体          （opus）   阶段1 PRD
        │   ├─ UX 子智能体          （opus）   阶段1.5 交互设计
        │   ├─ DBA 子智能体 ★       （sonnet） 阶段1.6 数据建模（涉数据层时）
        │   ├─ Analyst 子智能体 ★   （sonnet） 阶段1.7 埋点+度量 ──┐ 双阶段
        │   ├─ BA 子智能体          （sonnet） 阶段2 任务拆解（读 DBA 数据设计）
        │   ├─ Dev 子智能体         （sonnet） 阶段3 开发（按 Analyst 埋点方案实现）
        │   ├─ Reviewer 子智能体    （opus）   阶段3.5 代码规范门禁 ─┐ 并行
        │   ├─ Security 子智能体 ★  （opus）   阶段3.5 安全门禁 ────┘ （涉安全时）
        │   ├─ QA 子智能体          （sonnet） 阶段4 功能正确性 ───┐ 接力
        │   ├─ Performance 子智能体 ★（sonnet） 阶段4 性能基线 ────┘ （高并发时）
        │   ├─ SRE 子智能体 ★       （sonnet） 阶段4.5 可靠性设计（上线前）
        │   ├─ Ops 子智能体         （haiku）  阶段5 部署/文档/git 归档
        │   └─ Analyst 子智能体 ★   （sonnet） 阶段6 数据分析、迭代建议反哺 PO ─┘
        │
        └─ ★ = 专项角色，按触发条件介入，不是每次都派（见编排者方法论「专项角色触发规则」）
```

**核心原则（来自实战）：**
- **技能由主 Agent 调用**（用户 `$技能名` 或编排者内部加载），子智能体不自动调用技能。
- 子智能体要按技能标准干活，由**主 Agent 在派生时把技能内容注入其 prompt**。
- 子智能体之间不互相调用，只由主 Agent 调度（避免调用栈爆炸）。

---

## 关键原则（来自实战教训）

1. **技能由主 Agent 调用**，子智能体不自动调用技能；要让子智能体按技能干活，由主 Agent 在派生时把技能内容注入其 prompt。
2. **子智能体之间不互相调用**，只由主 Agent 调度，避免调用栈爆炸。
3. **Reviewer 与 Dev 必须用不同模型**，避免"自审自"。
4. **编排者不越权执行**：哪怕"自己做得更快"，部署 / git 提交 / 写代码也必须派对应角色。
5. **写代码与提交分离**：Dev 只写不提交，git commit 由 Ops 唯一执行。
6. **防虚报**：Dev 回报告前必须 `git diff --stat` 自证改动落地；Reviewer/QA 必须先做磁盘事实核对，不采信 Dev 报告文字。
7. **经验记忆闭环**：派生前注入角色经验，完成后沉淀新经验，避免重复踩坑。

---

## 模型配置

各子智能体的模型在 `agents-config/agents/team-*.md` 的 front matter 定义（仓库源用内置别名）：

| 子智能体 | 模型 | 职责 | 介入方式 |
|---|---|---|---|
| team-po | `opus` | PRD 产出 | 核心角色，全程 |
| team-ux | `opus` | UX 线框图/界面规格 | 核心角色，涉界面时 |
| team-ba | `sonnet` | 任务拆解 | 核心角色，全程 |
| team-dba ★ | `sonnet` | 数据建模/存储选型/索引/迁移 | 专项，涉数据层时 |
| team-dev | `sonnet` | 写代码 | 核心角色，全程 |
| team-reviewer | `opus` | 代码规范门禁 | 核心角色（**必须与 Dev 不同模型**） |
| team-security ★ | `opus` | 安全门禁（越权/注入/敏感信息/依赖） | 专项，涉安全时（**必须与 Dev 不同模型**） |
| team-qa | `sonnet` | 功能正确性测试 | 核心角色，全程 |
| team-performance ★ | `sonnet` | 性能压测/调优 | 专项，高并发路径时 |
| team-sre ★ | `sonnet` | 可观测性/SLO/弹性/容量 | 专项，上线前/高可用时 |
| team-analyst ★ | `sonnet` | 度量指标/埋点/行为分析/A-B/迭代建议 | 专项，大型产品/需度量时（开发期定埋点 + 交付后分析） |
| team-ops | `haiku` | 部署/文档/git 归档 | 核心角色，全程 |
| team-pm | `sonnet` | 看板/风险 | 核心角色，全程 |

> **模型隔离硬约束**：Reviewer 和 Security 与 Dev 必须不同模型，避免"自审自/自保自"。当前 Dev=sonnet、Reviewer=opus、Security=opus，满足要求。
>
> ★ = 专项角色，按触发条件介入。起步可只配核心 8 角色（PO/UX/BA/Dev/Reviewer/QA/Ops/PM），跑通后按项目特性加专项角色（多存储加 DBA，高并发加 Performance，对外服务加 Security，上线前加 SRE，大型产品加 Analyst）。

---

## 经验记忆闭环（进阶，强烈建议启用）

避免每个 case 都从零踩坑。机制：

```
派生前：编排者读取该角色的经验文件 docs/agent-memory/<role>.md，
        按分层注入策略筛选后注入子智能体 prompt（防重复错误）
   ↓
子智能体执行任务
   ↓
完成后：子智能体在报告末尾追加「## 本次经验沉淀」（1–3 条可复用经验）
   ↓
编排者收齐后：去重、按 severity 归类，追加写入 docs/agent-memory/<role>.md
```

**防上下文撑爆的分层注入策略**：经验 <10 条全量注入；≥10 条只注入 `severity: high` + tags 命中本次需求的关键词条目全文，其余只给标题索引；超 2000 token 预算优先保留 high 条目。

经验目录 `docs/agent-memory/` 随仓库沉淀，团队共享。

> ⚠️ SessionStart hook 通常只作用于主会话，**子智能体的经验注入需编排者手动读取**——这是实战踩过的坑。

---

## 能力插件机制（防膨胀核心设计）

为避免角色/skills 无限膨胀，体系采用**注册表驱动 + 插件机制**。

### 三类能力分级

| 类型 | 含义 | 安装 | 可禁用 |
|---|---|---|---|
| **core** | 软件工程刚需的 13 角色核心能力 | 默认装 | ❌ |
| **layer** | 三层架构的 L2/L3 层级能力 | 默认装 | ✅ 纯 L1 可禁 |
| **plugin** | 可选领域插件（MLOps 等） | **按需装** | ✅ 默认不装 |

### 注册表（capability-registry skill）

编排者启动时读 `capability-registry` skill 的「当前已注册能力清单」，按每个能力的 `trigger_when` 判定本次是否激活。新增能力只改注册表，不动编排者骨架。

### 三问闸门（防膨胀硬约束）

任何新能力（尤其 plugin）注册前必须通过三问：
1. **解决什么缺口？**（现有角色覆盖不了的）
2. **与现有角色的边界在哪？**（不串味）
3. **什么条件下才激活？**（`trigger_when` 明确，不是每次都派）

未通过三问 → 拒绝注册，复用现有能力。这是体系不膨胀的根本保障。

### 当前已注册插件

| 插件 | 角色 | trigger_when | 安装 |
|---|---|---|---|
| **mlops** | team-mle | 涉模型训练/微调、RAG、Prompt 工程规模化、LLM Agent 平台 | `bash install.sh --plugin mlops` |

> 其他领域（FinOps/平台工程/数据契约等）处于观望，等实际场景出现再按三问流程注册。不为"齐全"而预注册。

### 安装命令

```bash
bash agents-config/install.sh                          # 默认装 core+layer
bash agents-config/install.sh --plugin mlops           # 额外装 mlops 插件
# Windows: powershell -ExecutionPolicy Bypass -File .\agents-config\install.ps1 -Plugin mlops
```

---

## 升级与自定义

- **修改子智能体**：编辑 `agents-config/agents/team-*.md`（仓库源）→ 跑 install → 重启 IDE
- **新增业务技能**：在 `agents-config/skills/` 下新建 `<技能名>/SKILL.md` → 跑 install → 重启 IDE
- **新增领域插件**：① 走三问闸门评估 → ② 在 capability-registry 注册 → ③ 在 install 脚本的 PluginMap 登记映射 → ④ 用户 `--plugin` 按需装
- **修改编排者方法论**：编辑 `agents-config/skills/team-orchestrator/SKILL.md` → 跑 install → 重启 IDE
- **适配具体项目**：在项目根放一份 `CLAUDE.md`，编排者运行时注入给各角色
- ⚠️ **严禁把 agents/skills 定义复制到工程级 `.zcode/`** —— 会引发同名冲突

---

## 迁移到其他 IDE

本套方法论与具体 IDE 解耦，迁移时只需替换：

| 机制要素 | ZCode 对应 | 通用映射 |
|---|---|---|
| 子智能体派生 | Agent 工具 + `~/.zcode/agents/` | 任何支持 subagent 派生的 IDE（Claude Code `.claude/agents`、Cursor rules 等） |
| 技能加载 | `~/.zcode/skills/` + 斜杠命令 | rules / prompts / commands 目录 |
| 编排者方法论 | `SKILL.md` | 一段被主 Agent 加载的总纲 Prompt |
| 模型分级 | opus / sonnet / haiku | 任意可按角色指定模型的 IDE |

迁移步骤：
1. 替换配置目录路径（`.zcode/` → 对应 IDE 的目录）
2. 替换 install 脚本里的目标路径（`$ZCODE_HOME` / `$ZCODE_HOME`）
3. 替换派生 API 的调用形式

**编排者方法论、角色 Prompt、阶段流程、检查点规则、经验记忆机制——这些是 IDE 无关的，可直接复用。**

---

## 参考文档

- [ZCode 官方文档首页](https://zcode.z.ai/cn/docs)
- [ZCode Skill 文档](https://zcode.z.ai/cn/docs/skill)
- [ZCode Subagent 文档](https://zcode.z.ai/cn/docs/subagents)
