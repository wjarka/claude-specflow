---
description: Creates an isolated worktree and branch for parallel feature development
allowed-tools: [Bash]
---

# Start Feature

Creates an isolated worktree and branch for parallel feature development.

## Usage

```bash
/specflow-start <feature-number>
```

Supports multiple formats:

- `{PREFIX}-009`, `{PREFIX}-9`, `009`, or `9`

Where `{PREFIX}` is your configured feature prefix (default: `feat`)

## What it does

- Creates a new git worktree at `../{PROJECT}-{PREFIX}-XXX/`
- Creates a new branch `feature/{PREFIX}-XXX`
- Automatically links to corresponding spec file `{SPEC_DIR}/{PREFIX}-XXX.md`
- Sets up isolated development environment
- **Guides you to next steps**

## Implementation

```bash
# Execute the specflow-start script with all arguments
exec "$HOME/.claude-specflow/bin/specflow-start.sh" "$@"
```
