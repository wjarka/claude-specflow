---
description: Shows all active feature worktrees and their status
allowed-tools: [Bash(exec:*)]
---

# List Features

Shows all active feature worktrees and their status.

## Usage

```bash
/specflow-list
```

## What it shows

- Feature name and number
- Worktree path
- Branch name
- Current status
- Suggested next steps for each feature

## Implementation

```bash
# Execute the specflow-list script
exec "$HOME/.claude-specflow/bin/specflow-list.sh"
```

## Example Output

```
🌿 Active feature worktrees:

📁 feat-001
   Path: ../my-project-feat-001
   Branch: feature/feat-001
   Status: ✅ Active
   Next: cd ../my-project-feat-001 && /specflow-implement

📁 feat-002
   Path: ../my-project-feat-002
   Branch: feature/feat-002
   Status: ✅ Active
   Next: cd ../my-project-feat-002 && /specflow-implement

💡 TIP: Use /specflow-start <number> to create a new feature worktree
```

## Next Steps Guidance

For each feature, the command shows:

- ✅ **Active**: Ready for development - cd to worktree and run `/specflow-implement`
- ❌ **Directory missing**: Worktree reference is stale - needs cleanup
- 🚧 **In progress**: Implementation has started - cd to worktree to continue

## When No Features Exist

If no feature worktrees are found:

- Suggests running `/specflow-plan` to start planning a new feature
- Shows how to create the first feature worktree
