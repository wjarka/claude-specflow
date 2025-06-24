#!/bin/bash

# Load toolkit configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/specflow-config.sh" 2>/dev/null || {
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