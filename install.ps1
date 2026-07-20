<#
.SYNOPSIS
  企业级多智能体协作体系安装脚本（Windows PowerShell）
.DESCRIPTION
  默认安装 core + layer 能力（13 核心角色 + L2/L3 角色 + 对应 skills）。
  领域插件（plugin）默认不装，按需 --plugin <name> 单独安装（防膨胀）。
.PARAMETER Check
  仅检查环境，不执行安装。
.PARAMETER Plugin
  安装指定领域插件（如 mlops）。可多次指定。
.EXAMPLE
  powershell -ExecutionPolicy Bypass -File .\agents-config\install.ps1
  powershell -ExecutionPolicy Bypass -File .\agents-config\install.ps1 -Plugin mlops
  powershell -ExecutionPolicy Bypass -File .\agents-config\install.ps1 -Check
.NOTES
  兼容 Windows PowerShell 5.x（输出纯 ASCII，文件 UTF-8 BOM）。
#>
[CmdletBinding()]
param(
  [switch]$Check,
  [string[]]$Plugin
)

$ErrorActionPreference = 'Stop'

$ScriptDir   = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir
$ZcodeHome   = Join-Path $env:USERPROFILE '.zcode'
$AgentsSrc   = Join-Path $ScriptDir 'agents'
$AgentsDst   = Join-Path $ZcodeHome 'agents'
$SkillsSrc   = Join-Path $ScriptDir 'skills'
$SkillsDst   = Join-Path $ZcodeHome 'skills'

# 插件映射表：插件名 -> (角色文件, skill目录)
# 新增插件时在此登记（同时要在 capability-registry 注册）
$PluginMap = @{
  'mlops' = @{ agent = 'team-mle.md'; skill = 'mlops' }
}

function Log  { param($m) Write-Host "[install] $m" -ForegroundColor Green }
function Warn { param($m) Write-Host "[warn]    $m" -ForegroundColor Yellow }
function Err  { param($m) Write-Host "[error]   $m" -ForegroundColor Red }

Log "enterprise multi-agent system install"
Log "project root : $ProjectRoot"
Log "user home    : $ZcodeHome"
Write-Host

if (-not (Test-Path $AgentsSrc)) {
  Err "source dir not found: $AgentsSrc (run this script from project root)"
  exit 1
}

# 插件角色文件名集合（用于默认安装时排除）
$PluginAgentFiles = $PluginMap.Values | ForEach-Object { $_.agent }
$PluginSkillDirs  = $PluginMap.Values | ForEach-Object { $_.skill }

# 默认安装：core + layer（排除插件角色）
$agents = Get-ChildItem -Path $AgentsSrc -Filter 'team-*.md' -File | Where-Object { $PluginAgentFiles -notcontains $_.Name }
$skillDirs = Get-ChildItem -Path $SkillsSrc -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') } | Where-Object { $PluginSkillDirs -notcontains $_.Name }

Log ("core+layer: {0} subagents, {1} skills" -f $agents.Count, $skillDirs.Count)
if ($Plugin) {
  foreach ($p in $Plugin) {
    if ($PluginMap.ContainsKey($p)) {
      Log ("plugin [{0}]: +1 agent, +1 skill" -f $p)
    } else {
      Warn ("unknown plugin: {0} (known: {1})" -f $p, ($PluginMap.Keys -join ', '))
    }
  }
}
Write-Host

if ($Check) {
  Log "check-only mode (-Check), nothing installed."
  exit 0
}

# ---------- 安装 core+layer 子智能体 ----------
New-Item -ItemType Directory -Force -Path $AgentsDst | Out-Null
$installed = 0
foreach ($a in $agents) {
  Copy-Item -Path $a.FullName -Destination (Join-Path $AgentsDst $a.Name) -Force
  $installed++
}
Log ("core+layer subagents installed: {0}" -f $installed)

# ---------- 安装 core+layer 技能 ----------
New-Item -ItemType Directory -Force -Path $SkillsDst | Out-Null
$installedSkills = 0
foreach ($sd in $skillDirs) {
  $dst = Join-Path $SkillsDst $sd.Name
  New-Item -ItemType Directory -Force -Path $dst | Out-Null
  Copy-Item -Path (Join-Path $sd.FullName 'SKILL.md') -Destination (Join-Path $dst 'SKILL.md') -Force
  Get-ChildItem -Path $sd.FullName -Directory | ForEach-Object {
    $subDst = Join-Path $dst $_.Name
    New-Item -ItemType Directory -Force -Path $subDst | Out-Null
    Copy-Item -Path (Join-Path $_.FullName '*') -Destination $subDst -Force -Recurse -ErrorAction SilentlyContinue
  }
  $installedSkills++
}
Log ("core+layer skills installed: {0}" -f $installedSkills)

# ---------- 安装指定插件 ----------
$pluginInstalled = 0
if ($Plugin) {
  Write-Host
  foreach ($p in $Plugin) {
    if (-not $PluginMap.ContainsKey($p)) { continue }
    $map = $PluginMap[$p]
    # 装 agent
    $agentSrc = Join-Path $AgentsSrc $map.agent
    if (Test-Path $agentSrc) {
      Copy-Item -Path $agentSrc -Destination (Join-Path $AgentsDst $map.agent) -Force
    }
    # 装 skill
    $skillSrc = Join-Path $SkillsSrc $map.skill
    if (Test-Path (Join-Path $skillSrc 'SKILL.md')) {
      $skillDst = Join-Path $SkillsDst $map.skill
      New-Item -ItemType Directory -Force -Path $skillDst | Out-Null
      Copy-Item -Path (Join-Path $skillSrc 'SKILL.md') -Destination (Join-Path $skillDst 'SKILL.md') -Force
    }
    $pluginInstalled++
    Log ("plugin installed: {0}" -f $p)
  }
}

Write-Host
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host " install done" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ("  subagents ({0})  -> {1}" -f ($installed + $pluginInstalled), $AgentsDst)
Write-Host ("  skills    ({0})  -> {1}" -f ($installedSkills + $pluginInstalled), $SkillsDst)
if ($pluginInstalled -gt 0) {
  Write-Host ("  plugins   ({0})" -f $pluginInstalled) -ForegroundColor Magenta
}
Write-Host
Warn "next: restart ZCode. /team-dev (L1) /program-collab (L2) /enterprise-arch (L3)"
