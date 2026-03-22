#!/bin/bash
# Coach Mode — Setup Script
# Initializes the Coach Mode journal directory for Claude Code.
#
# Usage:
#   bash setup.sh [journal-directory]
#
# If no journal directory is specified, defaults to ~/.coach-mode/

set -euo pipefail

JOURNAL_DIR="${1:-$HOME/.coach-mode}"

echo "Coach Mode — Setup"
echo "================================"
echo ""
echo "Journal directory: $JOURNAL_DIR"

# Create journal directory structure
mkdir -p "$JOURNAL_DIR/daily"

# Create default config if it doesn't exist
if [ ! -f "$JOURNAL_DIR/config.md" ]; then
  cat > "$JOURNAL_DIR/config.md" << 'EOF'
# Coach Mode Configuration

## Engineer Profile
- **Name**: [Your name]
- **Overall Seniority**: [junior | mid | senior | staff]
- **Mastery Threshold**: 2

## Domain Expertise
Rate your comfort level (beginner / intermediate / expert) in domains relevant to your work:

| Domain | Level | Notes |
|--------|-------|-------|
| Example: Python backend | intermediate | |
| Example: React/TypeScript | beginner | |
| Example: SQL/PostgreSQL | expert | |

_Edit this file to match your actual skills and domains._
EOF
  echo "Created config at $JOURNAL_DIR/config.md"
  echo "   -> Please edit it to set your name, seniority, and domain expertise."
else
  echo "Config already exists at $JOURNAL_DIR/config.md"
fi

# Create empty aggregate journal if it doesn't exist
if [ ! -f "$JOURNAL_DIR/journal.md" ]; then
  cat > "$JOURNAL_DIR/journal.md" << 'EOF'
# Learning Journal

## Summary
- **Total challenges completed**: 0
- **Domains practiced**: 0
- **Last updated**: —
EOF
  echo "Created aggregate journal at $JOURNAL_DIR/journal.md"
else
  echo "Aggregate journal already exists at $JOURNAL_DIR/journal.md"
fi

echo ""
echo "Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Edit $JOURNAL_DIR/config.md to set your profile"
echo "  2. Install this plugin in Claude Code"
echo "  3. Start coding — Coach Mode will activate automatically"
