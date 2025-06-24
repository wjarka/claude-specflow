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
    echo "Usage: /specflow-start <feature-number>"
    echo "Examples:"
    echo "  /specflow-start ${prefix}-009"
    echo "  /specflow-start ${prefix}-9"
    echo "  /specflow-start 009"
    echo "  /specflow-start 9"
    exit 1
fi

FEATURE_INPUT="$1"
FEATURE_NUMBER=$(normalize_feature_number "$FEATURE_INPUT")
BRANCH_NAME=$(get_branch_name "$FEATURE_NUMBER")
WORKTREE_PATH=$(get_worktree_path "$FEATURE_NUMBER")
SPEC_FILE=$(get_spec_file "$FEATURE_NUMBER")

echo "🚀 Starting feature development for $FEATURE_NUMBER..."

# Check if worktree and branch already exist
if [ -d "$WORKTREE_PATH" ] && git branch --list "$BRANCH_NAME" | grep -q "$BRANCH_NAME"; then
    echo "✅ Feature already exists!"
    echo "📁 Worktree: $WORKTREE_PATH"
    echo "🌿 Branch: $BRANCH_NAME"
    if [ -f "$SPEC_FILE" ]; then
        echo "📋 Spec: $SPEC_FILE"
    fi
    echo ""
    echo "🚀 NEXT STEPS:"
    echo "1. cd $WORKTREE_PATH"
    echo "2. Start a new Claude Code session there"
    echo "3. Run /specflow-implement to sync and start coding"
    exit 0
fi

# Check if spec file exists
if [ ! -f "$SPEC_FILE" ]; then
    echo "❌ Spec file not found: $SPEC_FILE"
    echo ""
    echo "🚀 NEXT STEP: Run /specflow-plan to create the specification first"
    exit 1
fi

# Create worktree with new branch
echo "🚀 Creating feature worktree for '$FEATURE_NUMBER'..."
git worktree add "$WORKTREE_PATH" -b "$BRANCH_NAME"

echo ""
echo "✅ Feature worktree created successfully!"
echo "📁 Path: $WORKTREE_PATH"
echo "🌿 Branch: $BRANCH_NAME"
echo "📋 Spec: $SPEC_FILE (auto-linked)"
echo ""
echo "🚀 NEXT STEPS:"
echo "1. cd $WORKTREE_PATH"
echo "2. Start a new Claude Code session in that directory"
echo "3. Run /specflow-implement to sync with main and start coding"
echo ""
echo "💡 TIP: Your feature spec is automatically available in the new session"