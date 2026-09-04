#!/usr/bin/env bash
# cc-editor — wrapper so Claude Code's Ctrl+G editor gets the repo
# as its working directory, for path completion in nvim.

set -euo pipefail

file="$1"

# Prefer Claude Code's own project-root var if it's populated for this
# process; otherwise fall back to wherever this wrapper was launched from.
root="${CLAUDE_PROJECT_DIR:-$PWD}"

# Optional debug: set CC_EDITOR_DEBUG=1 to log what this wrapper sees.
if [[ "${CC_EDITOR_DEBUG:-}" == "1" ]]; then
  {
    echo "---- $(date) ----"
    echo "file: $file"
    echo "CLAUDE_PROJECT_DIR: ${CLAUDE_PROJECT_DIR:-<unset>}"
    echo "PWD before cd: $PWD"
    echo "resolved root: $root"
  } >> "$HOME/cc-editor-debug.log"
fi

cd "$root"

exec nvim "$file"
