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
/plugin marketplace add <owner>/coach-mode
/plugin install coach-mode@<owner>-coach-mode
```

On first use, Coach Mode will ask you to set up your engineer profile (name, seniority, domain expertise). After that, it's fully automatic.

## The Journal

Coach Mode maintains a personal learning journal at `~/.coach-mode/` (configurable):

- **Daily logs** — Detailed entries for each coaching session
- **Aggregate journal** — Bird's-eye view of skill progression by domain
- **Config** — Your engineer profile and domain expertise levels

The journal is designed to be useful for self-reflection, 1:1s with your lead, or onboarding into new domains.

## Overrides

Say "just do it" or "skip" at any time and Coach Mode will comply immediately. It's a guardrail, not a gatekeeper.

## License

MIT
