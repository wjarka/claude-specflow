---
description: Completes feature development by merging back to main and cleaning up the worktree
allowed-tools: [Bash(exec:*)]
---

# Finish Feature

Completes feature development by merging back to main and cleaning up the worktree.

## Usage

```bash
/specflow-finish [feature-number]
```

- **From feature worktree**: Auto-detects feature number from directory name
- **From main directory**: Requires feature number

Supports multiple formats:

- `{PREFIX}-009`, `{PREFIX}-9`, `009`, or `9`

Where `{PREFIX}` is your configured feature prefix (default: `feat`)

## What it does

1. Commits any uncommitted changes with a meaningful commit message
2. Automatically finds the main worktree (handles multiple worktrees)
3. Switches to main worktree for merge operations
4. Fetches latest changes
5. Merges feature branch into main
6. Deletes feature branch
7. Removes feature worktree
8. **Guides you on what to do next**

## Prerequisites

- Feature implementation is complete
- All tests pass (run them first!)
- Code is ready for main branch

## Implementation

```bash
# Execute the specflow-finish script with all arguments
exec "$HOME/.claude-specflow/bin/specflow-finish.sh" "$@"
```

## Claude Workflow Integration

When this command is invoked, Claude will:

1. **Check for uncommitted changes** in the feature worktree
2. **Generate a meaningful commit message** based on the feature specification
3. **Commit the changes** if any exist
4. **Run the completion script** to merge and cleanup
5. **Inform user about next steps**

## Example Usage

```bash
/specflow-finish feat-009
# or simply:
/specflow-finish 9
```

## After Completion

- **Exit Claude Code** - the worktree directory no longer exists
- Run tests to verify integration
- Start planning your next feature with `/specflow-plan`
