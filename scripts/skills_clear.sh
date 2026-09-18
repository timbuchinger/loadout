#!/usr/bin/env bash
set -euo pipefail

TARGET_DIRS=(
  "$HOME/.codex/skills"
  "$HOME/.claude/skills"
  "$HOME/.config/opencode/skill"
)

for dir in "${TARGET_DIRS[@]}"; do
  if [[ -d "$dir" ]]; then
    echo "Clearing contents of: $dir"
    if find "$dir" -mindepth 1 -delete; then
      echo "Finished clearing: $dir"
    else
      echo "Failed clearing: $dir" >&2
      exit 1
    fi
  else
    echo "Directory does not exist, skipping: $dir"
  fi
done
