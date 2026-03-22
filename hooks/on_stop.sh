#!/bin/bash
# Coach Mode — Stop hook
# Fires when Claude completes a response.
# Checks if journal directory exists and ensures daily file is created.
# The actual journal writing is done by Claude in-conversation (it has
# the context about what happened), but this hook ensures the directory
# structure is ready.

set -euo pipefail

DATA_DIR="${CLAUDE_PLUGIN_DATA:-$HOME/.coach-mode}"

# If plugin isn't configured yet, do nothing
if [ ! -f "$DATA_DIR/config.md" ]; then
  exit 0
fi

# Ensure daily directory exists
mkdir -p "$DATA_DIR/daily"

# Ensure today's daily file exists
TODAY=$(date '+%Y-%m-%d')
DAILY_FILE="$DATA_DIR/daily/$TODAY.md"
if [ ! -f "$DAILY_FILE" ]; then
  echo "# Learning Journal — $TODAY" > "$DAILY_FILE"
  echo "" >> "$DAILY_FILE"
fi

exit 0
