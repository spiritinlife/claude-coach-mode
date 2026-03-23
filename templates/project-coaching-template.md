# Project Coaching Rules

<!--
  This file defines project-wide coaching rules for the Coach Mode plugin.
  Place it at: .claude/coaching.md in your project root.

  Maintained by senior engineers. Reviewed in PRs like any other code.
  See: https://github.com/spiritinlife/claude-coach-mode for documentation.
-->

## Project Info
- **Project**: [Your project name]
- **Maintained by**: [GitHub handles of maintainers]
- **Last updated**: [Date]

## Category Overrides

### Always Coach (even if normally "just do it")
<!--
  Add patterns here for tasks that LOOK like busywork but have
  project-specific learning value. Be specific about the pattern,
  why it matters, and give a concrete example.
-->

<!-- Example:
- **Pattern**: Any modifications to the `/auth/` directory
  - **Reason**: Our auth system has subtle security invariants
  - **Example**: Adding a new OAuth provider, modifying token validation
-->

### Just Do It (even if normally coached)
<!--
  Add patterns here for tasks that LOOK complex but are actually
  standardized in your project. Link to templates/docs where relevant.
-->

<!-- Example:
- **Pattern**: Adding REST endpoints following our OpenAPI spec
  - **Reason**: Fully automated with our code generator
  - **Example**: `make generate-endpoint name=widgets`
-->

### Custom Thresholds
<!--
  Override the default "practice 2 times" threshold for specific task types.
  Use higher numbers for complex domains, lower for well-documented patterns.
-->

| Task Type | Threshold | Reason |
|-----------|-----------|--------|
<!-- | GraphQL resolvers | 3 | Our patterns are non-standard | -->

## Domain-Specific Rules

<!--
  Define coaching behavior for specific areas of your codebase.
  Each domain should specify:
  - coaching level: always | standard | minimal
  - what to coach on (if level is always/standard)
  - what's safe to delegate
  - links to relevant documentation
-->

<!-- Example:

### Payments & Billing
- **Coaching level**: always
- **Key concepts to coach**:
  - Payment state machine transitions
  - Refund authorization flow
  - PCI compliance requirements
- **Safe to delegate**:
  - Adding new payment method icons
  - Updating error message copy
- **Resources**:
  - /docs/payments-architecture.md
  - /docs/pci-checklist.md

### Admin CRUD
- **Coaching level**: minimal
- **Reason**: Fully templated, internal tool, low risk
- **Templates location**: /templates/admin/

-->
