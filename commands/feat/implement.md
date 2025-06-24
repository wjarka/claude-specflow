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

```bash
# Load toolkit configuration
source "$HOME/.claude-specflow/specflow-config.sh" 2>/dev/null || {
    echo "❌ Toolkit config not found. Please install claude-specflow first."
    echo "Run: curl -fsSL https://raw.githubusercontent.com/wjarka/claude-specflow/main/install.sh | bash"
    exit 1
}
init_config

# Auto-detect feature from directory name
CURRENT_DIR=$(basename "$PWD")
FEATURE_NUMBER=$(extract_feature_from_dir)

if [ $? -ne 0 ]; then
    echo "❌ Not in a feature worktree directory!"
    echo "Expected directory name pattern: {PROJECT}-$(get_feature_prefix)-XXX"
    echo "Current directory: $CURRENT_DIR"
    echo ""
    echo "🚀 NEXT STEP: Use /feat/start <number> to create a feature worktree first"
    exit 1
fi

PROJECT_NAME=$(detect_project_name)
SPEC_FILE="../$PROJECT_NAME/$(get_spec_file "$FEATURE_NUMBER")"
BRANCH_NAME=$(get_branch_name "$FEATURE_NUMBER")

echo "🚀 Auto-implementing feature: $FEATURE_NUMBER"
echo "📁 Worktree: $(pwd)"
echo "🌿 Branch: $BRANCH_NAME"

# REQUIRE specification file to exist
if [ ! -f "$SPEC_FILE" ]; then
    echo "❌ Spec file not found: $SPEC_FILE"
    echo ""
    echo "🚀 NEXT STEPS:"
    echo "1. cd ../$PROJECT_NAME"
    echo "2. Run /feat/plan to create the specification"
    echo "3. Run /feat/start $NUMBER to recreate the worktree"
    exit 1
fi

echo "📋 Spec: $SPEC_FILE ✅"

# Auto-sync with main branch first
echo ""
echo "🔄 Syncing with main branch..."

# Get main branch name
MAIN_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")

# Fetch and rebase
git fetch origin
if ! git rebase "origin/$MAIN_BRANCH"; then
    echo "❌ Sync failed - please resolve conflicts manually"
    echo ""
    echo "🚀 NEXT STEPS:"
    echo "1. Resolve conflicts in your editor"
    echo "2. git add ."
    echo "3. git rebase --continue"
    echo "4. Run /feat/implement again"
    exit 1
fi

echo "✅ Synced with $MAIN_BRANCH successfully!"
echo ""

# Show spec summary
echo "📋 FEATURE SPECIFICATION:"
echo "========================"
head -20 "$SPEC_FILE" | sed 's/^/   /'
echo "========================"
echo ""

echo "✅ Ready for implementation!"
echo "🚀 Starting implementation now..."
echo ""
```

After running the sync and validation, Claude will automatically:

1. **Read the full specification** using the Read tool
2. **Create a todo list** using TodoWrite with implementation tasks
3. **Start coding immediately** without asking for approval (since spec was pre-approved)
4. **Guide you through the implementation** step by step

## Next Steps After Implementation
When your implementation is complete:
- Run `/feat/finish` to merge back to main and cleanup
- This will automatically commit your changes and remove the worktree

## Example Usage
```bash
# From within feature worktree (e.g., ../myproject-feat-009/)
/feat/implement

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