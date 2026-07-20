---
name: mlops
description: （领域插件）机器学习工程化方法论。模型训练/微调、评测（Eval）、部署/灰度/回滚、监控（漂移/幻觉/成本）、Prompt/RAG 版本化。通过 capability-registry 的 plugin 段注册，trigger_when 命中后激活 team-mle 角色。默认不安装，按需 `bash install.sh --plugin mlops`。本插件是插件机制的第一个示范。
model: sonnet
---

# MLOps 领域插件方法论

## 注册信息（capability-registry plugin 段）

| 项 | 值 |
|---|---|
| 插件名 | mlops |
| 激活角色 | team-mle（机器学习工程师） |
| trigger_when | 涉模型训练/微调、RAG/向量检索、Prompt 工程规模化、LLM Agent 平台 |
| 阶段接入 | 1.8 模型方案 + 4.2 模型评测 + 5.2 模型部署 + 6 模型监控 |
| 安装 | `bash install.sh --plugin mlops` |

## 三问闸门（已通过）

1. **缺口**：模型生命周期工程化，现有角色覆盖不了。
2. **边界**：见 team-mle 角色定义的边界表。
3. **触发**：涉 AI 能力的产品才激活，不是每次都派。

## 运作模式（被编排者激活时）

```
编排者读 capability-registry，判定 mlops 的 trigger_when 是否命中
   ↓ 命中
编排者在本需求的流水线插入模型相关阶段：
  阶段1.8  → 派 MLE 做模型方案设计（与 DBA 数据建模并行）
  阶段3   → Dev 写业务逻辑，MLE 实现模型管线/推理服务（并行）
  阶段4.2 → 派 MLE 做模型评测（与 QA 功能测试并行）
  阶段5.2 → MLE 给模型部署要求，Ops 执行部署（协同）
  阶段6   → MLE 持续监控模型质量/成本/漂移
   ↓ 未命中
不激活 MLE，按常规软件工程流程走
```

## 核心能力清单

| 能力 | 产出 | 关键约束 |
|---|---|---|
| 训练/微调工程化 | 训练管线、模型版本、实验记录 | 可复现（种子+数据快照+环境锁） |
| 模型评测 | 离线评测报告、回归测试集 | LLM-as-judge + 人工评测双轨 |
| 部署/灰度 | 模型服务、灰度策略、回滚机制 | 版本注册表支持一键回滚 |
| 模型监控 | 漂移/幻觉/安全/成本/延迟监控 | 区别于 SRE 系统监控 |
| Prompt/RAG 版本化 | prompt 模板库、RAG 知识库版本 | prompt 即代码，变更需评审 |

## 与其他能力/角色的协同

- **与 DBA**：DBA 管训练数据的存储与 schema，MLE 管训练管线与模型版本。
- **与 Dev**：Dev 写业务逻辑与 UI，MLE 写模型推理服务与管线。
- **与 QA**：QA 测业务功能，MLE 测模型质量（两套测试并行）。
- **与 Performance**：Performance 压系统性能，MLE 关注推理延迟（模型特性）。
- **与 Ops**：Ops 部署推理服务的基础设施，MLE 提供模型特性要求（GPU/量化/批处理）。
- **与 Analyst**：Analyst 看产品数据，MLE 看模型指标（幻觉率/漂移）。
- **与 SRE**：SRE 监系统可用性，MLE 监模型行为质量。

## 详细方法论

见 team-mle 角色定义。
