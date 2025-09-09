#!/bin/bash
# 同步当前 VS Code 扩展到 devcontainer.json

set -euo pipefail
export LC_ALL=C

readonly DEVCONTAINER_PATH=".devcontainer/devcontainer.json"
readonly BACKUP_PATH="${DEVCONTAINER_PATH}.bak"

# 日志函数
log() { printf '\e[1;36m➤ %s\e[0m\n' "$*" >&2; }
error() { printf '\e[1;31m❌ %s\e[0m\n' "$*" >&2; exit 1; }
success() { printf '\e[1;32m✅ %s\e[0m\n' "$*" >&2; }
skip() { printf '\e[1;33m⏭️  %s\e[0m\n' "$*" >&2; }

# 检查依赖
check_deps() {
  log "检查依赖..."
  command -v code &> /dev/null || error "'code' 命令未安装，请运行: Install 'code' in PATH (VS Code F1)"
  command -v jq &> /dev/null || error "'jq' 未安装，请运行: brew install jq 或 apt-get install jq"
}

# 验证 JSON 文件
validate_json() {
  local file="$1"
  if ! jq . "$file" &> /dev/null; then
    error "JSON 格式错误: $file\n💡 提示: 删除所有 '//' 注释，确保语法合法"
  fi
}

# 过滤并生成扩展列表（排除非 extension.id 格式的行）
get_extensions() {
  code --list-extensions | grep -E '^[a-zA-Z0-9._-]+\.[a-zA-Z0-9._-]+$' | sort -u
}

# 更新 devcontainer.json
update_devcontainer() {
  local temp_file="/tmp/dc.$$"
  trap 'rm -f "$temp_file"' EXIT

  # 备份
  cp "$DEVCONTAINER_PATH" "$BACKUP_PATH"
  success "已备份: $BACKUP_PATH"

  # 使用管道 + process substitution 避免变量注入问题
  cat "$DEVCONTAINER_PATH" | jq --argjson exts "$(get_extensions | jq -R . | jq -s '.')" '
    .customizations //= {}
    | .customizations.vscode //= {}
    | .customizations.vscode.extensions = $exts
  ' > "$temp_file" && mv "$temp_file" "$DEVCONTAINER_PATH"
}

# 显示结果
show_result() {
  local count=$(jq -r '[.customizations?.vscode?.extensions[][]] | length' "$DEVCONTAINER_PATH")
  success "更新成功！共 $count 个扩展:"
  jq -r '.customizations?.vscode?.extensions[]' "$DEVCONTAINER_PATH" | sed 's/^/   • /'
}

# 主函数
main() {
  log "同步 VS Code 扩展到 Dev Container"

  [[ ! -f "$DEVCONTAINER_PATH" ]] && error "文件不存在: $DEVCONTAINER_PATH"

  check_deps
  validate_json "$DEVCONTAINER_PATH"

  local extensions=()
  mapfile -t extensions < <(get_extensions)

  (( ${#extensions[@]} == 0 )) && error "未找到任何有效扩展"

  log "发现 ${#extensions[@]} 个扩展"
  update_devcontainer
  show_result
}

# 执行
main "$@"