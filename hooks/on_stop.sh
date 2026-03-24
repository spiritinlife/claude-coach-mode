#!/bin/bash
# Coach Mode — Stop hook
# Fires when Claude completes a response.
# 1. Ensures journal directory structure exists
# 2. Sets a marker so the next prompt triggers a journal check

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

# Set marker for journal check on next prompt
# Include timestamp so we can show the correct time in journal entries
date '+%H:%M' > "$DATA_DIR/.journal-pending"

exit 0
