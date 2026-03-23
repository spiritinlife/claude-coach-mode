#!/bin/bash
# Coach Mode — UserPromptSubmit hook
# Fires before Claude processes every user message.
# Reads the engineer's learning journal and injects their skill profile
# as additional context so Claude knows what to handicap.

set -euo pipefail

INPUT=$(cat)

# Persistent data directory provided by Claude Code plugin system
DATA_DIR="${CLAUDE_PLUGIN_DATA:-$HOME/.coach-mode}"

CONFIG_FILE="$DATA_DIR/config.md"
JOURNAL_FILE="$DATA_DIR/journal.md"

# Project-level config detection
# Find project root by looking for .git directory
find_project_root() {
  local dir="$PWD"
  while [ "$dir" != "/" ]; do
    if [ -d "$dir/.git" ]; then
      echo "$dir"
      return 0
    fi
    dir=$(dirname "$dir")
  done
  return 1
}

PROJECT_ROOT=$(find_project_root 2>/dev/null || echo "")
PROJECT_CONFIG=""
PROJECT_CONFIG_PATH=""

if [ -n "$PROJECT_ROOT" ] && [ -f "$PROJECT_ROOT/.claude/coaching.md" ]; then
  PROJECT_CONFIG_PATH="$PROJECT_ROOT/.claude/coaching.md"
  # Read first 100 lines to prevent overly large injections
  PROJECT_CONFIG=$(head -100 "$PROJECT_CONFIG_PATH")
fi

# If no config exists yet, inject first-run setup instructions
if [ ! -f "$CONFIG_FILE" ]; then
  cat <<'CONTEXT'
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "[COACH MODE — FIRST RUN]\nThe Coach Mode plugin is active but not yet configured. Before doing anything else, ask the engineer to set up their profile. Ask for:\n1. Their name\n2. Overall seniority level (junior / mid / senior / staff)\n3. Their key domains and comfort level in each (beginner / intermediate / expert)\n4. Where to store the journal (suggest ~/.coach-mode/ as default)\n\nThen create the config.md and journal.md files at the chosen location. After setup, proceed with the original request using the Coach Mode decision framework."
  }
}
CONTEXT
  exit 0
fi

# Extract minimal profile info (seniority + domain expertise table only)
SENIORITY=""
DOMAINS=""
if [ -f "$CONFIG_FILE" ]; then
  # Extract seniority level
  SENIORITY=$(grep -i "seniority" "$CONFIG_FILE" | head -1 | sed 's/.*: *//' || echo "unknown")
  # Extract domain expertise table (compact format)
  DOMAINS=$(awk '/\| Domain/,/^$/' "$CONFIG_FILE" | head -10 || echo "")
fi

# Extract mastered skills count from journal (just the summary line)
MASTERED_COUNT=""
if [ -f "$JOURNAL_FILE" ]; then
  MASTERED_COUNT=$(grep -c "mastered" "$JOURNAL_FILE" 2>/dev/null || echo "0")
fi

# Extract project overrides summary (just the patterns, not full descriptions)
PROJECT_SUMMARY=""
if [ -n "$PROJECT_CONFIG" ]; then
  # Get just the pattern lines for quick reference
  PROJECT_SUMMARY=$(echo "$PROJECT_CONFIG" | grep -E "^\- \*\*Pattern\*\*:" | head -10 || echo "")
fi

# Build MINIMAL context injection (~300 tokens instead of 2-3KB)
CONTEXT_TEXT=$(cat <<EOF
[COACH MODE — ACTIVE]
Seniority: $SENIORITY | Mastered skills: $MASTERED_COUNT | Journal: $DATA_DIR

QUICK RULES:
- "just do it" / "skip" → comply immediately, no argument
- Busywork (boilerplate, config, CRUD, formatting) → just do it
- Architecture, debugging, system design → coach them (Socratic mode)
- Gray area → default to coaching, engineer can override

$( [ -n "$PROJECT_SUMMARY" ] && echo "PROJECT OVERRIDES:
$PROJECT_SUMMARY" )

$( [ -n "$DOMAINS" ] && echo "DOMAINS:
$DOMAINS" )

FOR EDGE CASES: Use /coach-mode-details for full classification rules, coaching modes, and journal format.
FOR CLASSIFICATION HELP: Use the @coach-classifier agent (uses Haiku for fast, cheap decisions).
EOF
)

# Output as JSON with proper escaping
printf '%s' "$CONTEXT_TEXT" | python3 -c "
import sys, json
text = sys.stdin.read()
output = {
    'hookSpecificOutput': {
        'hookEventName': 'UserPromptSubmit',
        'additionalContext': text
    }
}
json.dump(output, sys.stdout)
"

exit 0
