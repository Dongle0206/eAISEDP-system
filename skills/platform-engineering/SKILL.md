---
name: platform-engineering
description: 平台工程方法论（L1/L2）。内部开发者平台（IDP）、黄金路径、CI/CD 标准化、环境管理、制品库、发布管理、开发者自助。强化 team-ops 从"部署文档员"升级为"平台工程能力"。对标 Backstage/Spotify 模式。
model: sonnet
---

# 平台工程方法论

## 定位
当前 Ops 偏"部署文档"。企业级需要 Platform Engineering——给开发者提供"黄金路径"和自助平台，让 Dev 不用操心基建。对标 Backstage（Spotify 开源 IDP）。

## 核心能力

### 1. 内部开发者平台（IDP）
- 服务目录（所有微服务/应用的统一目录）
- 服务模板（新服务脚手架，黄金路径）
- 文档门户（聚合所有工程文档）
- 开发者自助（自助建环境、查日志、看监控）

### 2. 黄金路径（Golden Path）
- 官方推荐的端到端开发路径（从新建服务到上线）
- 脚手架+模板+CI/CD+监控一体化
- 走黄金路径 = 合规且高效，偏离需特批
- 黄金路径由 Standards 定标准，Ops 实现

### 3. CI/CD 标准化
- 统一 CI 流水线模板（构建/测试/扫描/发布）
- 统一 CD 部署策略（蓝绿/灰度/金丝雀）
- 制品库管理（Harbor/Nexus，镜像+制品版本化）
- 流水线即代码（Pipeline as Code）

### 4. 环境管理
- 环境矩阵（dev/test/staging/prod）
- 环境隔离与配额
- 环境一键创建/销毁（按需环境）
- 环境数据管理（脱敏数据/种子数据）

### 5. 发布管理
- 发布审批流程（CAB）
- 发布窗口与冻结期
- 回滚预案（与 reliability-governance 联动）
- 发布监控与自动回滚

## 与现有角色协同
- Standards 定平台标准，Ops 实现平台
- Dev 使用平台（走黄金路径）
- GRC 审计平台合规与控制有效性

## 详细方法论
强化 team-ops 调用本 skill。
