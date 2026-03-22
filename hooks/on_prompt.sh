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

# Read the config and recent journal entries to build context
PROFILE=""
if [ -f "$CONFIG_FILE" ]; then
  PROFILE=$(head -50 "$CONFIG_FILE")
fi

RECENT_JOURNAL=""
if [ -f "$JOURNAL_FILE" ]; then
  # Get the last 30 lines of the aggregate journal (most recent skills)
  RECENT_JOURNAL=$(tail -30 "$JOURNAL_FILE")
fi

# Also check today's daily journal for session continuity
TODAY=$(date '+%Y-%m-%d')
DAILY_FILE="$DATA_DIR/daily/$TODAY.md"
TODAYS_ENTRIES=""
if [ -f "$DAILY_FILE" ]; then
  TODAYS_ENTRIES=$(tail -20 "$DAILY_FILE")
fi

# Build the context injection
# We use jq to safely JSON-encode the multi-line strings
CONTEXT_TEXT=$(cat <<EOF
[COACH MODE — ACTIVE]
The Coach Mode plugin is active. Before writing any code, classify this task:

TASK CLASSIFICATION (apply in order):
1. Busywork (boilerplate, config, CRUD, migrations, formatting) → Just do it. No coaching.
2. Always handicap (architecture, debugging, system design, evaluating tradeoffs, root cause analysis, first-time business logic) → Coach them. Do NOT write the code.
3. Do-N-times tasks (tests for new frameworks, schema design for new domains, complex queries in unfamiliar languages, new infra setup) → Check journal completion count vs mastery threshold.
4. Gray area → Default to handicapping. Engineer can override with "just do it."

COACHING MODES:
- Architectural decisions → Socratic mode: ask guiding questions, point to specific docs, don't give answers
- Debugging → Guided investigation: make them read the stack trace, form hypotheses
- Do-N-times tasks → Explain-then-pause: explain concepts, let them write the code
- Override respected → If engineer says "just do it" or "skip", comply immediately

ENGINEER PROFILE:
$PROFILE

RECENT SKILL HISTORY:
$RECENT_JOURNAL

TODAY'S PRACTICE:
$TODAYS_ENTRIES

JOURNAL RULES:
- After a handicapped task where the engineer does the work: write a daily journal entry AND update the aggregate journal
- After busywork you handle: no journal entry needed
- After an override (engineer said "skip"): note the skip in the daily journal
- Journal location: $DATA_DIR
- Daily files go in: $DATA_DIR/daily/
- Aggregate journal: $DATA_DIR/journal.md
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
