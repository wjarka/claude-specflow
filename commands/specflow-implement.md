---
description: Auto-detect feature, sync with main, and start implementation
allowed-tools: [Bash, TodoWrite, Read, Edit, MultiEdit, Write, Grep, Glob]
---

# Implement Feature

Auto-detects current feature from directory name, syncs with main branch, and starts implementation.

## Requirements
- **Must be run from within a feature worktree directory**
- **Feature specification must exist** 
- Directory format: `{PROJECT}-{PREFIX}-XXX/`

## What it does
1. Auto-detects feature number from current directory name
2. **Requires specification file to exist** (fails if missing)
3. Automatically syncs with main branch first
4. Shows specification summary
5. **Starts implementation immediately** using TodoWrite
6. **No additional approval needed** (spec was already reviewed)

## Implementation

The bash logic is handled by an external script: `bin/specflow-implement.sh`

After running the sync and validation, Claude will automatically:

1. **Read the full specification** using the Read tool
2. **Create a todo list** using TodoWrite with implementation tasks
3. **Start coding immediately** without asking for approval (since spec was pre-approved)
4. **Guide you through the implementation** step by step

## Next Steps After Implementation
When your implementation is complete:
- Run `/specflow-finish` to merge back to main and cleanup
- This will automatically commit your changes and remove the worktree

## Example Usage
```bash
# From within feature worktree (e.g., ../myproject-feat-009/)
/specflow-implement

# Output:
🚀 Auto-implementing feature: feat-009
📁 Worktree: /path/to/myproject-feat-009
🌿 Branch: feature/feat-009
📋 Spec: ../myproject/specs/feat-009.md ✅

🔄 Syncing with main branch...
✅ Synced with main successfully!

📋 FEATURE SPECIFICATION:
========================
# feat-009: Add Spotify Integration
## Overview
This feature adds Spotify playlist import...
========================

✅ Ready for implementation!
🚀 Starting implementation now...

[Claude then automatically reads spec and starts implementing]
```