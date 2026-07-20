---
name: capability-registry
description: 能力注册表与插件机制（体系元层）。编排者启动时读本表，按 trigger_when 动态激活能力。三类分级 core/layer/plugin + 三问闸门防止体系无限膨胀。新增能力只改本表，不动编排者骨架。本 skill 是编排者方法论的一部分，默认启用。
model: opus
---

# 能力注册表（Capability Registry）— 体系元层

## 定位

本表是编排者/PGM/EA 启动时读取的"能力清单"。它把"何时派谁"从硬编码在方法论里，改为**注册表驱动**——新增能力只在本表登记，不动骨架。

## 三类能力分级（防膨胀第一道闸）

| 类型 | 含义 | 安装 | 可禁用 |
|---|---|---|---|
| **core** | 软件工程刚需的 13 角色核心能力 | 默认装 | ❌ 不可禁用 |
| **layer** | 三层架构的 L2/L3 层级能力 | 默认装 | ✅ 纯 L1 项目可禁 |
| **plugin** | 可选领域插件（MLOps/FinOps 等） | **按需装**（`--plugin <名>`） | ✅ 默认就不装 |

**铁律**：plugin 默认不装、按需装。只有真正需要该领域时才 `install --plugin`，避免体系臃肿。

## 三问闸门（每个能力注册前必须回答，否则拒绝注册）

任何新能力（尤其 plugin）要加入本表，必须通过三问审核：

1. **解决什么缺口？** —— 现有角色/skill 覆盖不了什么？若现有角色能覆盖 → 拒绝注册，复用现有。
2. **与现有角色的边界在哪？** —— 职责如何划分，不串味？边界不清 → 拒绝注册。
3. **什么条件下才激活？** —— `trigger_when` 必须明确，不是每次都派。无明确触发条件 → 拒绝注册。

**审核流程**：三问由方法论标准负责人（team-standards）评估 + 编排者/EA 复核。通过才登记到本表。这是防止体系无限膨胀的硬约束——不是想加就加。

---

## 当前已注册能力清单

### core（核心 13 角色，默认启用，不可禁用）

| 能力 | 激活角色 | trigger_when | 产出 |
|---|---|---|---|
| 产品需求 | team-po | 每个需求 | PRD + 验收标准 |
| 交互设计 | team-ux | 涉界面时 | 线框图 + 界面规格 |
| 任务拆解 | team-ba | 每个需求 | 任务清单 + 接口契约 + 影响评估 |
| 技术方案 | team-se | standard 档/技术复杂时 | 技术方案设计 + 开发质量主导 + 关键问题攻坚 |
| 开发 | team-dev | 每个需求 | 业务代码 |
| 代码评审 | team-reviewer | 阶段3.5 每个需求 | 评审报告（须与 Dev 不同模型）|
| 功能测试 | team-qa | 阶段4 每个需求 | 测试用例 + 报告 |
| 部署归档 | team-ops | 阶段5 每个需求 | 部署文档 + git 归档 |
| 项目跟踪 | team-pm | 全程 | 看板 + 风险 + changelog |

### 体系治理（meta 层，默认启用，商用必需，非 plugin 不膨胀）

这些不是业务能力，是**体系自身可靠运转的治理机制**，默认启用：

| 能力 | skill | 作用 |
|---|---|---|
| 能力注册表 | capability-registry | 编排者读它决定激活哪些能力（防膨胀） |
| 模型路由 | model-registry | 档位→模型映射，模型换代不改角色（防过时） |
| 可靠性治理 | reliability-governance | 人工锁+兜底校验+回滚+置信度（商用门槛） |
| 成本治理 | cost-governance | token预算+模型降级+上下文裁剪（商用可持续） |
| 数据契约 | data-contract | 标准化产出格式，适配企业工具链（落地集成） |
| 体系可观测 | system-observability | 监控体系自身健康（运营） |
| MCP适配 | mcp-integration | 标准协议对接工具，未来即插即用（适配未来） |

### layer（层级能力，默认启用，纯 L1 项目可禁用）

| 能力 | 激活角色 | trigger_when | 产出 |
|---|---|---|---|
| 数据建模 | team-dba (plugin-tier) | 涉数据层/schema/多存储 | 数据设计 + 存储选型 |
| 安全评审 | team-security (plugin-tier) | 涉鉴权/支付/外部接口/敏感数据 | 安全评审报告（须与 Dev 不同模型）|
| 性能压测 | team-performance (plugin-tier) | 涉高并发路径 | 压测方案 + 性能报告 |
| 可靠性设计 | team-sre (plugin-tier) | 临近上线/高可用 SLA | 可靠性设计文档 |
| 产品度量 | team-analyst (plugin-tier) | 大型产品/需数据度量 | 埋点方案 + 分析报告 |

> 注：以上 5 个专项角色虽属于"layer 层级能力"范畴，但设计上与 core 一起默认安装，仅在触发条件命中时激活（详见编排者方法论「专项角色触发规则」）。它们的"layer"属性指其按需激活的特性。

### L2/L3 层级能力（默认启用，纯 L1 项目可禁用）

| 能力 | 激活角色/skill | trigger_when | 命令 |
|---|---|---|---|
| 企业架构 | team-ea + enterprise-architecture | /企业架构 | 战略级架构治理（含业务架构/流程）|
| 战略投资 | team-strategy + tech-radar | /战略投资 | 可行性/ROI/技术雷达 |
| 企业GRC | team-grc + enterprise-grc | 定期/事件/被调用 | 治理审计/风险评估/合规/控制有效性/改进驱动 |
| 项目群协同 | team-pgm + program-management | /项目群协同 | 多项目并行 |
| 工程标准 | team-standards + engineering-standards | L2 流程激活 | CLAUDE.md/门禁/模板 |
| 交付效能 | team-vsm + devops-metrics | L2 流程激活 | DORA + 流动效率 |
| 数据治理 | team-steward + data-governance | L2 流程/被调用 | 标准化/质量/主数据/资产化 |
| 业务流程 | business-process | EA/PgM 调用 | 流程架构/gap分析/流程→项目衍生 |
| 变革管理 | change-management | EA/PgM 调用 | ADKAR/Kotter/沟通/培训 |
| 产品管理 | product-management | PO 调用 | 路线图/优先级/竞品 |
| 需求工程 | requirements-engineering | PO 调用 | 全生命周期/变更控制/追溯 |
| 平台工程 | platform-engineering | Ops 调用 | IDP/黄金路径/CI-CD |
| ITSM | it-service-management | Ops/SRE 调用 | 事件/问题/变更/SLA |
| 供应商管理 | vendor-management | GRC/Standards 调用 | 评估/SLA/验收/风险 |
| 组织知识 | knowledge-management | 各层按需调用 | ADR/复盘/模式库 |
| 依赖影响 | dependency-impact | PgM/BA 按需 | 全局影响分析 |
| 合规审计 | compliance-audit | Security/EA 按需 | 等保/GDPR 审计链 |

### plugin（可选领域插件，默认不装，按需 `install --plugin`）

| 插件 | 激活角色/skill | trigger_when | 安装命令 |
|---|---|---|---|
| **mlops** | team-mle + mlops skill | 涉模型训练/微调、RAG/向量检索、Prompt 工程规模化、LLM Agent 平台 | `bash install.sh --plugin mlops` |

> 截至当前，已注册 plugin 只有 mlops 一个。其他领域（FinOps/平台工程/数据契约等）处于观望，等实际场景出现再按三问闸门流程注册。

---

## 编排者如何使用本表

编排者（及 PgM/EA）启动处理需求时：

1. **读本表**拿到当前已注册的能力清单
2. 对照本次需求特征，逐项判定每个能力的 `trigger_when` 是否命中
3. **只激活命中的能力**，未命中的不派生对应角色
4. 遇到本表未覆盖的新领域 → 不擅自造角色，按三问闸门流程评估是否注册新 plugin

## 注册新插件的标准流程（给方法论标准负责人）

当出现本表未覆盖的新领域诉求：

1. **提三问**：缺口/边界/触发条件，写一份注册提案
2. **评估**：方法论标准负责人 + 编排者/EA 复核，能否被现有能力覆盖
3. **通过**：登记到本表 plugin 段 + 建角色/skill 文件到 `agents/` 和 `skills/`
4. **安装**：用户按需 `install --plugin <名>`

**未通过三问 → 拒绝注册，复用现有能力。** 这是体系不膨胀的根本保障。
