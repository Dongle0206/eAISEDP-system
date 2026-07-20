---
name: model-registry
description: 模型路由表与档位映射（体系元层，防过时根基）。把"角色需要什么能力"与"用哪个具体模型"解耦——角色定义写能力档位(reasoning/structured/mechanical)，路由表映射到具体模型。模型换代只改路由表，不动 18 个角色定义。编排者派生前读本表解析档位→模型。属于体系治理类能力，默认启用。
model: opus
---

# 模型路由表（Model Registry）— 防过时根基

## 定位

当前角色定义里硬绑 `model: opus/sonnet/haiku`。模型迭代极快——半年后可能有更强模型，某角色更适合别的模型。绑死意味着每次模型换代要改 18 个角色定义，且无法动态降级省成本。

本表把**"角色需要什么能力"**与**"用哪个具体模型"**解耦。角色定义只声明能力档位，具体用哪个模型由本表路由。

## 三个能力档位

按认知负荷而非名气分档：

| 档位 | 能力要求 | 典型任务 | 映射模型（当前） |
|---|---|---|---|
| **reasoning** | 深度推理、创造、判断 | PRD 设计、架构决策、安全评审、代码评审 | `opus`（GLM 系高端） |
| **structured** | 结构化产出、遵循规范、多步骤 | 任务拆解、写代码、测试、看板 | `sonnet`（GLM 系中端） |
| **mechanical** | 机械执行、流程性、低复杂度 | 部署文档、git 归档、变更登记 | `haiku`（GLM 系低端） |

**关键约束**：档位是任务特性决定的，不是角色决定的。同一个角色不同任务可能不同档位——比如 Dev 写复杂算法是 reasoning、写 CRUD 是 structured。但为简化起步，先按角色默认档位映射。

## 当前路由表（角色 → 档位 → 模型）

| 角色 | 默认档位 | 映射模型 | 理由 |
|---|---|---|---|
| team-po | reasoning | opus | 需求深度判断、创造性 |
| team-ux | reasoning | opus | 交互设计创造 |
| team-ba | structured | sonnet | 结构化拆解 |
| team-dba | structured | sonnet | 结构化数据建模 |
| team-dev | structured | sonnet | 主力代码产出 |
| team-reviewer | **reasoning（隔离约束）** | **opus** | 门禁角色，必须与 dev 不同模型 |
| team-security | **reasoning（隔离约束）** | **opus** | 门禁角色，必须与 dev 不同模型 |
| team-qa | structured | sonnet | 结构化测试 |
| team-performance | structured | sonnet | 结构化压测分析 |
| team-sre | structured | sonnet | 结构化可靠性设计 |
| team-analyst | structured | sonnet | 结构化度量分析 |
| team-mle | structured | sonnet | 结构化模型工程 |
| team-ops | mechanical | haiku | 流程性、机械 |
| team-pm | structured | sonnet | 结构化跟踪 |
| team-pgm | reasoning | opus | 项目群复杂决策 |
| team-ea | reasoning | opus | 架构深度判断 |
| team-strategy | reasoning | opus | 战略深度判断 |
| team-standards | structured | sonnet | 结构化标准翻译 |
| team-vsm | structured | sonnet | 结构化度量 |

## 隔离约束（硬规则，不可破坏）

派生 Reviewer 和 Security 时，必须校验其映射模型与 Dev 不同。当前 Dev=sonnet、Reviewer=opus、Security=opus，满足。**换模型时这条约束优先于路由表**——若为省成本把 Dev 升到 opus，必须同步把 Reviewer/Security 换到别的 opus 级模型，或保持 Dev 在 sonnet。

## 模型换代流程（这是防过时的核心）

当出现新模型（更强的下一代、或某垂直模型崛起）：

1. 评估：新模型是否更适合某档位？（成本/能力/延迟权衡）
2. 只改本表的"映射模型"列
3. **不动 18 个角色定义**（它们写的是档位，不是模型）
4. 重启生效

**举例**：半年后出现 model-X，推理能力超 opus 且成本更低 → 本表 reasoning 档位映射从 opus 改 model-X → 所有 reasoning 角色（PO/UX/Reviewer/Security/EA/PgM/Strategy）自动升级，零改角色文件。

## 成本动态降级（与成本治理联动）

高负载时（token 预算吃紧），本表支持**临时降级**：
- structured 任务先降到 mechanical（如 BA 的简单拆解可降 haiku）
- reasoning 不降（降了质量崩，门禁失效）
- 降级是临时策略，标注有效期，预算恢复后回调

## 与 capability-registry 的关系

- capability-registry 管"何时激活哪个能力/角色"
- model-registry 管"激活后用什么模型"
- 编排者派生前：先查 capability-registry 确定派谁，再查 model-registry 确定用什么模型

## 向后兼容

当前角色定义仍保留 `model: opus/sonnet/haiku` 字段（IDE 需要它识别）。本表是**编排者派生时的权威路由**，与角色文件的 model 字段保持一致即可。未来若 IDE 支持"档位"字段，可迁移到角色定义直接写档位。
