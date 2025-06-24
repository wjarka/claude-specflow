---
description: Syncs feature branch with latest default branch and prepares for implementation
allowed-tools: [Bash]
---

# Sync Feature

Syncs feature branch with latest default branch and prepares for implementation.

## Usage

```bash
/specflow-sync <feature-number>
```

Supports multiple formats:

- `{PREFIX}-009`, `{PREFIX}-9`, `009`, or `9`

Where `{PREFIX}` is your configured feature prefix (default: `feat`)

## What it does

- Fetches latest changes from origin
- Rebases feature branch onto latest default branch (main/master)
- Shows sync status and any conflicts
- Validates feature is ready for implementation
- **Guides you to next steps**

## When to use

- Before starting implementation of a planned feature
- When default branch has been updated since feature creation
- To validate your spec against current codebase state
- **Note**: `/specflow-implement` calls this automatically

## Implementation

```bash
# Execute the specflow-sync script with all arguments
exec "$HOME/.claude-specflow/bin/specflow-sync.sh" "$@"
```

## Important

- Run this from the **main repository directory**, not from within the feature worktree
- Or simply use `/specflow-implement` which calls sync automatically

## Example Usage

```bash
/specflow-sync feat-009
# or simply:
/specflow-sync 9

# Output:
🔄 Syncing feature: feat-009
📁 Worktree: ../myproject-feat-009
🌿 Branch: feature/feat-009

📥 Fetching latest changes from origin...
🔄 Rebasing onto origin/main...
✅ Sync completed successfully!

🚀 NEXT STEPS:
1. Run /specflow-implement to start coding
2. Or run /specflow-show to review the specification
```

## Conflict Resolution

If conflicts occur during sync:

1. **Resolve conflicts** in your editor
2. **Stage changes**: `git add .`
3. **Continue rebase**: `git rebase --continue`
4. **Re-run sync** to verify: `/specflow-sync <number>`
