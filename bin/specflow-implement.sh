#!/bin/bash

# Load toolkit configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/specflow-config.sh" 2>/dev/null || {
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
    echo "Expected directory name pattern: {PROJECT}-$(get_feature_prefix)-{NUMBER}"
    echo "Current directory: $CURRENT_DIR"
    echo ""
    echo "🚀 NEXT STEP: Use /specflow-start <number> to create a feature worktree first"
    exit 1
fi

# Get project name - if in worktree, extract from directory name
if PROJECT_NAME=$(extract_project_from_worktree_dir); then
    # We're in a worktree, use extracted project name
    true
else
    # Not in worktree, use regular detection
    PROJECT_NAME=$(detect_project_name)
fi
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
    echo "2. Run /specflow-plan to create the specification"
    echo "3. Run /specflow-start $NUMBER to recreate the worktree"
    exit 1
fi

echo "📋 Spec: $SPEC_FILE ✅"

# Auto-sync with main branch first
echo ""
echo "🔄 Syncing with main branch..."

# Get main branch name
MAIN_BRANCH=$(detect_default_branch)

# Fetch and rebase
git fetch origin
if ! git rebase "origin/$MAIN_BRANCH"; then
    echo "❌ Sync failed - please resolve conflicts manually"
    echo ""
    echo "🚀 NEXT STEPS:"
    echo "1. Resolve conflicts in your editor"
    echo "2. git add ."
    echo "3. git rebase --continue"
    echo "4. Run /specflow-implement again"
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
