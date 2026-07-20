---
name: it-service-management
description: IT服务管理方法论（ITSM, L1/L2）。ITIL 4 裁剪——服务台、事件管理、问题管理、变更管理（CAB）、服务级别（SLA/OLC）、知识管理。强化 team-ops 和 team-sre 覆盖上线后的服务运营。
model: sonnet
---

# IT 服务管理方法论（ITSM / ITIL 4 裁剪）

## 定位
当前 Ops 偏"部署"，SRE 偏"可靠性设计"。企业级 IT 上线后需要 ITSM——日常服务运营管理。本 skill 补服务运营维度。

## ITIL 4 核心实践（裁剪）

### 1. 服务台（Service Desk）
- 单一联系点（SPOC）
- 工单分类、路由、跟踪
- 自助知识库（用户自助解决）

### 2. 事件管理（Incident）
- 事件分级（P0/P1/P2/P3）
- 响应 SLA（按级别）
- 根因分析（RCA）
- 事后复盘（与 SRE 协同）

### 3. 问题管理（Problem）
- 识别重复事件的根因
- 问题记录与处置
- 已知错误数据库（KEDB）

### 4. 变更管理（Change）
- 变更分级（标准/普通/紧急）
- 变更咨询委员会（CAB）
- 变更评审：影响/风险/回滚
- 与 reliability-governance 的不可逆操作人工锁联动

### 5. 服务级别管理（SLM）
- SLA（对客户的承诺）
- OLA（内部团队间承诺）
- SLA 监控与报告
- SLA 违约处置

### 6. 知识管理
- 运维知识库
- 故障处置手册（Runbook）
- 与 knowledge-management skill 协同

## 与现有角色协同
- Ops 执行 ITSM 流程
- SRE 做可靠性设计（事前），ITSM 管事件（事后）
- GRC 审计 ITSM 流程合规

## 详细方法论
强化 team-ops/sre 调用本 skill。
