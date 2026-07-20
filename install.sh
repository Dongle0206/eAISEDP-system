#!/usr/bin/env bash
# 企业级多智能体协作体系安装脚本（macOS / Linux / Git Bash）
#
# 默认安装 core + layer 能力（核心角色 + L2/L3 角色 + skills）。
# 领域插件（plugin）默认不装，按需 --plugin <name> 单独安装（防膨胀）。
#
# 用法：
#   bash agents-config/install.sh                          # 装 core+layer
#   bash agents-config/install.sh --plugin mlops           # 额外装 mlops 插件
#   bash agents-config/install.sh --plugin mlops --plugin xxx   # 多个插件
#   bash agents-config/install.sh --check                  # 仅检查
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ZCODE_HOME="${HOME}/.zcode"

# 插件映射表：插件名 -> "角色文件:skill目录"
# 新增插件时在此登记（同时要在 capability-registry 注册）
declare -A PLUGIN_MAP=(
  ["mlops"]="team-mle.md:mlops"
)

log()  { printf '[install] %s\n' "$*"; }
warn() { printf '[warn]    %s\n' "$*" >&2; }
err()  { printf '[error]   %s\n' "$*" >&2; }

log "enterprise multi-agent system install"
log "project root : $PROJECT_ROOT"
log "user home    : $ZCODE_HOME"
echo

AGENTS_SRC="$SCRIPT_DIR/agents"
SKILLS_SRC="$SCRIPT_DIR/skills"

if [[ ! -d "$AGENTS_SRC" ]]; then
  err "source dir not found: $AGENTS_SRC (run this script from project root)"
  exit 1
fi

# 解析参数
CHECK_ONLY=0
PLUGINS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --check) CHECK_ONLY=1; shift ;;
    --plugin) PLUGINS+=("$2"); shift 2 ;;
    *) err "unknown arg: $1"; exit 1 ;;
  esac
done

# 构建插件排除清单（默认安装时排除插件角色）
PLUGIN_AGENTS=()
PLUGIN_SKILLS=()
for p in "${!PLUGIN_MAP[@]}"; do
  IFS=':' read -r a s <<< "${PLUGIN_MAP[$p]}"
  PLUGIN_AGENTS+=("$a")
  PLUGIN_SKILLS+=("$s")
done
is_plugin_agent() { local f="$1"; for x in "${PLUGIN_AGENTS[@]}"; do [[ "$f" == "$x" ]] && return 0; done; return 1; }
is_plugin_skill() { local d="$1"; for x in "${PLUGIN_SKILLS[@]}"; do [[ "$d" == "$x" ]] && return 0; done; return 1; }

# 默认安装：core+layer（排除插件）
core_agents=(); for src in "$AGENTS_SRC"/team-*.md; do [[ -f "$src" ]] || continue; is_plugin_agent "$(basename "$src")" || core_agents+=("$src"); done
core_skills=(); for d in "$SKILLS_SRC"/*/; do [[ -f "${d}SKILL.md" ]] || continue; is_plugin_skill "$(basename "$d")" || core_skills+=("$d"); done

log "core+layer: ${#core_agents[@]} subagents, ${#core_skills[@]} skills"
for p in "${PLUGINS[@]:-}"; do
  if [[ -n "$p" ]]; then
    if [[ -n "${PLUGIN_MAP[$p]:-}" ]]; then log "plugin [$p]: +1 agent, +1 skill"
    else warn "unknown plugin: $p (known: ${!PLUGIN_MAP[*]})"; fi
  fi
done
echo

if [[ "$CHECK_ONLY" == "1" ]]; then
  log "check-only mode, nothing installed."
  exit 0
fi

# 安装 core+layer
mkdir -p "$ZCODE_HOME/agents" "$ZCODE_HOME/skills"
installed=0
for src in "${core_agents[@]}"; do cp "$src" "$ZCODE_HOME/agents/"; installed=$((installed+1)); done
log "core+layer subagents installed: $installed"

installed_skills=0
for d in "${core_skills[@]}"; do
  name="$(basename "$d")"; mkdir -p "$ZCODE_HOME/skills/$name"; cp "${d}SKILL.md" "$ZCODE_HOME/skills/$name/"
  find "$d" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | while read -r sub; do
    sn="$(basename "$sub")"; mkdir -p "$ZCODE_HOME/skills/$name/$sn"; cp -R "$sub"/* "$ZCODE_HOME/skills/$name/$sn/" 2>/dev/null || true
  done
  installed_skills=$((installed_skills+1))
done
log "core+layer skills installed: $installed_skills"

# 安装指定插件
plugin_installed=0
for p in "${PLUGINS[@]:-}"; do
  [[ -n "$p" ]] || continue
  [[ -n "${PLUGIN_MAP[$p]:-}" ]] || continue
  IFS=':' read -r a s <<< "${PLUGIN_MAP[$p]}"
  [[ -f "$AGENTS_SRC/$a" ]] && cp "$AGENTS_SRC/$a" "$ZCODE_HOME/agents/"
  [[ -f "$SKILLS_SRC/$s/SKILL.md" ]] && { mkdir -p "$ZCODE_HOME/skills/$s"; cp "$SKILLS_SRC/$s/SKILL.md" "$ZCODE_HOME/skills/$s/"; }
  plugin_installed=$((plugin_installed+1))
  log "plugin installed: $p"
done

echo
echo "=================================================="
echo " install done"
echo "=================================================="
echo "  subagents ($((installed + plugin_installed)))  -> $ZCODE_HOME/agents"
echo "  skills    ($((installed_skills + plugin_installed)))  -> $ZCODE_HOME/skills"
[[ "$plugin_installed" -gt 0 ]] && echo "  plugins   ($plugin_installed)"
echo
warn "next: restart ZCode. /team-dev (L1) /program-collab (L2) /enterprise-arch (L3)"
