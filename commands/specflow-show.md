---
description: Show specification for current feature worktree
allowed-tools: [Bash(exec:*)]
---

# Show Feature Specification

Shows the specification for the current feature worktree.

## Usage
```bash
/specflow-show
```

## Requirements
- Must be run from within a feature worktree directory
- Directory format: `{PROJECT}-{PREFIX}-XXX/`

## What it does
- Auto-detects feature number from current directory name
- Displays the complete feature specification
- Shows implementation status and next steps

## Implementation

```bash
# Execute the specflow-show script
exec "$HOME/.claude-specflow/bin/specflow-show.sh"
```

After the bash validation, Claude will:
1. **Read the specification file** using the Read tool
2. **Display the complete specification** in a formatted way
3. **Show current implementation status**
4. **Suggest next steps** based on current state

## Next Steps Guidance
After showing the spec, Claude will suggest:
- If you haven't started: "Run `/specflow-implement` to sync and start coding"
- If implementation is in progress: "Continue implementing the remaining tasks"
- If implementation seems complete: "Run `/specflow-finish <number>` to merge and cleanup"

## Example Usage
```bash
# From within feature worktree
/specflow-show

# Output:
📋 Feature Specification: feat-009
==========================================
📁 Worktree: /path/to/myproject-feat-009
📋 Spec: ../myproject/specs/feat-009.md

# feat-009: Add Spotify Integration

## Overview
This feature adds Spotify playlist import functionality...

[Full specification displayed...]

🚀 NEXT STEP: Run /specflow-implement to start coding this feature
```