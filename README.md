# Coach Mode

An intelligent guardrail for engineer growth in AI-assisted development.

Coach Mode intercepts every coding task in Claude Code and decides whether the engineer should do the work themselves (for learning) or whether the agent should handle it (for efficiency). It maintains a personal learning journal that tracks skill progression over time.

## How it works

Coach Mode classifies every task into one of three buckets:

- **Always coach** — Architectural decisions, debugging, system design, evaluating tradeoffs. The engineer does these by hand because the struggle builds judgment.
- **Coach N times, then delegate** — Tests for new frameworks, schema design for new domains, complex queries in unfamiliar languages. The journal tracks completions and stops coaching once the pattern is internalized.
- **Just do it** — Boilerplate, config files, CRUD, migrations, formatting. No learning value; the agent handles these immediately.

When coaching, it adapts its style based on task type:

- **Socratic mode** for architectural decisions — guiding questions, not answers
- **Guided investigation** for debugging — making the engineer read the stack trace and form hypotheses
- **Explain-then-pause** for learnable patterns — explaining concepts, then letting the engineer write the code

## Installation

Add the marketplace and install:

```
/plugin marketplace add spiritinlife/claude-coach-mode
/plugin install claude-coach-mode@spiritinlife-claude-coach-mode
```

On first use, Coach Mode will ask you to set up your engineer profile (name, seniority, domain expertise). After that, it's fully automatic.

## The Journal

Coach Mode maintains a personal learning journal at `~/.coach-mode/` (configurable):

- **Daily logs** — Detailed entries for each coaching session
- **Aggregate journal** — Bird's-eye view of skill progression by domain
- **Config** — Your engineer profile and domain expertise levels

The journal is designed to be useful for self-reflection, 1:1s with your lead, or onboarding into new domains.

## Project-Level Configuration

For teams, senior engineers can create a `.claude/coaching.md` file in the repository to define project-wide coaching rules that apply to all team members.

### Quick Start

Create `.claude/coaching.md` in your project root:

```markdown
# Project Coaching Rules

## Project Info
- **Project**: My Project
- **Maintained by**: @senior-dev

## Category Overrides

### Always Coach
- **Pattern**: Changes to authentication or permissions
  - **Reason**: Security-critical code requires understanding

### Just Do It
- **Pattern**: CRUD endpoints using our standard templates
  - **Reason**: Fully standardized, see /templates/

### Custom Thresholds
| Task Type | Threshold | Reason |
|-----------|-----------|--------|
| GraphQL resolvers | 3 | Non-standard patterns |

## Domain-Specific Rules

### Billing System
- **Coaching level**: always
- **Key concepts**: Payment flows, refund logic, compliance
```

### Rule Hierarchy

1. **Project rules** (`.claude/coaching.md`) — Team-wide, mandatory
2. **Personal rules** (`~/.coach-mode/config.md`) — Individual additions
3. **Default rules** (built-in) — Fallback behavior

Personal config can add stricter coaching (more practice) but cannot bypass project safety rules.

### For Maintainers

See [SKILL.md](skills/claude-coach-mode/SKILL.md) for the full project config format, detailed examples, and the complete decision framework.

A copyable template is available at [templates/project-coaching-template.md](templates/project-coaching-template.md).

## Overrides

Say "just do it" or "skip" at any time and Coach Mode will comply immediately. It's a guardrail, not a gatekeeper.

## Token Optimization

Coach Mode uses a **minimal injection architecture** to reduce token costs by ~90%:

- **Minimal hook** (~300 tokens) — Only essential context injected on every message
- **On-demand skill** (`/coach-mode-details`) — Full framework loaded only when needed
- **Haiku classifier** (`@coach-classifier`) — Cheap, fast classification for edge cases

For most tasks, the minimal injection is enough. Edge cases can invoke the full framework or classifier as needed.

## License

MIT
