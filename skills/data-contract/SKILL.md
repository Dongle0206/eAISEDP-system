---
name: data-contract
description: 数据契约标准化方法论（体系元层，落地集成）。用业界标准格式描述体系所有产出，与具体存储工具解耦——从 git/markdown 起步，将来对接 Jira/Confluence/Apifox/Grafana 时代价最小。让体系适配企业现有工具链，而非要求企业换工具。属于体系治理类，默认启用。
model: opus
---

# 数据契约标准化方法论（Data Contract）— 落地集成

## 定位

当前体系所有产出是 markdown 文件进 git。商用时企业已有 Jira/GitLab/Confluence，不可能要求企业换工具。本 skill 定义标准化的产出格式，让数据"长什么样"与"存在哪"解耦——换工具不换格式，迁移代价最小。

## 七类数据资产的标准化契约

| 类别 | 数据特性 | 标准化契约格式 | 业界依据 |
|---|---|---|---|
| **A 代码配置** | 强版本控制 | Git | 原生标准 |
| **B 战略架构文档** | 文档型 | **Markdown + YAML frontmatter** | 任何 Wiki 可导入 |
| **C 项目群管理** | 结构化+状态流转 | **JSON Schema + REST API** | 所有项目管理工具支持 |
| **D 工程标准** | 文档型 | Markdown + frontmatter | 同 B |
| **E case 交付物** | 半结构化 | Markdown + frontmatter + case 元数据 | 同 B |
| **F 接口契约** | 强结构化 | **OpenAPI 3.0** | Stoplight/Swagger/Apifox 全支持 |
| **G 度量数据** | 时序/指标 | **Prometheus + OpenTelemetry** | Grafana/Datadog 吃这套 |

## Markdown frontmatter 规范（B/D/E 类通用）

所有文档型产出必须有 frontmatter，便于工具导入和检索：

```yaml
---
doc_id: case-20260707-1200-订单服务-prd
case_id: case-20260707-1200-订单服务
type: prd | design | review | test | deploy | migration
layer: L1 | L2 | L3
subproject: 订单服务
author_role: team-po
status: draft | reviewing | approved | delivered
created: 2026-07-07T12:00
updated: 2026-07-07T14:30
tags: [订单, 微服务, 重构]
related: [接口契约id, 评审报告id]
---
```

## 项目群管理数据 JSON Schema（C 类，适配 Jira/Plane/OpenProject）

里程碑/任务的结构化定义，所有项目管理工具都支持这种 schema 导入：

```json
{
  "milestone_id": "M1",
  "title": "订单+支付MVP联调通过",
  "target_date": "2026-10-01",
  "subprojects": [
    {"id": "订单服务", "orchestrator": "A", "status": "in_progress", "stage": "开发", "blocker": null},
    {"id": "支付服务", "orchestrator": "B", "status": "blocked", "stage": "拆任务", "blocker": "依赖订单契约"}
  ],
  "integration_points": ["订单创建契约须先行", "联调环境就绪"]
}
```

## 接口契约 OpenAPI 规范（F 类）

BA 产出的接口契约必须用 OpenAPI 3.0 格式（不只是 markdown 表格），才能被 Swagger/Stoplight/Apifox 校验和渲染：

```yaml
openapi: 3.0.0
info:
  title: 订单服务 API
  version: 1.0.0
  x-case-id: case-20260707-1200-订单服务
paths:
  /orders:
    post:
      summary: 创建订单
      x-dependency: 支付服务依赖此接口
      ...
```

## 分阶段落地路径

| 阶段 | 存储 | 适用 |
|---|---|---|
| **阶段0（当前）** | 全 git markdown，但产出已符合契约格式 | 原型/小团队 |
| **阶段1（开源起步）** | Gitea+Outline+Plane+Stoplight+Grafana，数据契约不变 | 中型企业 |
| **阶段2/3（商业）** | 按需换 Jira/Confluence 等，数据导出导入 | 大企业/合规 |

**核心价值**：只要产出符合契约格式，换工具是"导出→导入"，不是"重写"。从现在就让产出符合契约，将来零迁移。

## 与各角色的关系

- **PO/BA/QA/Ops/EA 等**：产出时遵循 frontmatter/OpenAPI 规范
- **方法论标准负责人**：维护契约规范，校验产出符合契约
- **Ops**：交付时把产物按契约格式归档/导入工具
