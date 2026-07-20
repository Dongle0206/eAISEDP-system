---
name: mcp-integration
description: MCP适配层方法论（体系元层，适配未来）。用Model Context Protocol标准对接外部工具/数据源，让体系与Jira/GitLab/CI/知识库的集成走标准协议而非每集成写死。未来任何支持MCP的工具即插即用。适配层规范，依赖框架支持MCP。体系治理类，默认启用。
model: sonnet
---

# MCP 适配层（Model Context Protocol Integration）

## 定位

当前体系与外部工具对接是手工的（编排者读CLAUDE.md、Ops写git）。未来应走 **MCP 标准**——AI 与工具/数据源交互的统一协议。本 skill 定义对接规范，让集成标准化。

## MCP 标准对接的典型场景

| 场景 | 当前(手工) | MCP标准(未来) |
|---|---|---|
| 读项目上下文 | 编排者Read CLAUDE.md | MCP server 暴露项目文档 |
| 查任务状态 | 读 milestones.md | MCP 对接 Jira/Plane |
| 触发CI/CD | Ops写脚本 | MCP 对接 Jenkins/GitLab CI |
| 查代码 | grep/Read | MCP 对接代码库 |
| 查度量 | 读度量文件 | MCP 对接 Grafana/Prometheus |

## 设计原则

1. **方法论层不绑MCP实现**——编排者方法论只说"需要什么信息"，不说"怎么取"
2. **适配层隔离**——MCP 对接在适配层，方法论不感知具体协议
3. **渐进迁移**——当前手工读文件能跑，MCP 成熟后逐步替换，不强制
4. **工具无关**——任何支持 MCP 的工具都能即插即用

## 当前状态

MCP 处于快速演进期（2024-2025）。本 skill 预留对接规范，等框架成熟+企业有需求时落地代码层适配。当前体系用文件+API手工对接，功能完整，MCP 是优化项非必需。
