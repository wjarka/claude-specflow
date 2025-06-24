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
# Load toolkit configuration
source "$HOME/.claude-specflow/specflow-config.sh" 2>/dev/null || {
    echo "❌ Toolkit config not found. Please install claude-specflow first."
    echo "Run: curl -fsSL https://raw.githubusercontent.com/wjarka/claude-specflow/main/install.sh | bash"
    exit 1
}
init_config

if [ -z "$1" ]; then
    prefix=$(get_feature_prefix)
    echo "Usage: /specflow-sync <feature-number>"
    echo "Examples:"
    echo "  /specflow-sync ${prefix}-009"
    echo "  /specflow-sync ${prefix}-9"
    echo "  /specflow-sync 009"
    echo "  /specflow-sync 9"
    exit 1
fi

FEATURE_INPUT="$1"
FEATURE_NUMBER=$(normalize_feature_number "$FEATURE_INPUT")
BRANCH_NAME=$(get_branch_name "$FEATURE_NUMBER")
WORKTREE_PATH=$(get_worktree_path "$FEATURE_NUMBER")

# Check if worktree exists
if [ ! -d "$WORKTREE_PATH" ]; then
    echo "❌ Feature worktree not found: $WORKTREE_PATH"
    echo ""
    echo "🚀 NEXT STEP: Run /specflow-start $FEATURE_INPUT to create the worktree"
    exit 1
fi

echo "🔄 Syncing feature: $FEATURE_NUMBER"
echo "📁 Worktree: $WORKTREE_PATH"
echo "🌿 Branch: $BRANCH_NAME"
echo ""

# Switch to feature worktree
cd "$WORKTREE_PATH"

# Get main branch
MAIN_BRANCH=$(detect_default_branch)

echo "📥 Fetching latest changes from origin..."
git fetch origin

echo "🔄 Rebasing onto origin/$MAIN_BRANCH..."
if git rebase "origin/$MAIN_BRANCH"; then
    echo "✅ Sync completed successfully!"
    echo ""
    echo "🚀 NEXT STEPS:"
    echo "1. Run /specflow-implement to start coding"
    echo "2. Or run /specflow-show to review the specification"
else
    echo "❌ Sync failed - conflicts need resolution"
    echo ""
    echo "🚀 NEXT STEPS:"
    echo "1. Resolve conflicts in your editor"
    echo "2. git add ."
    echo "3. git rebase --continue"
    echo "4. Run /specflow-sync $FEATURE_INPUT again to verify"
    exit 1
fi
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