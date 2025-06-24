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
# Load toolkit configuration
source "$HOME/.claude-specflow/specflow-config.sh" 2>/dev/null || {
    echo "❌ Toolkit config not found. Please install claude-specflow first."
    echo "Run: curl -fsSL https://raw.githubusercontent.com/wjarka/claude-specflow/main/install.sh | bash"
    exit 1
}
init_config

# Try to auto-detect feature from current directory
CURRENT_DIR=$(basename "$PWD")
if [[ "$CURRENT_DIR" =~ ^.*-([a-z]+)-([0-9]+)$ ]]; then
    # We're in a feature worktree - auto-detect
    PREFIX="${BASH_REMATCH[1]}"
    NUMBER="${BASH_REMATCH[2]}"
    FEATURE_INPUT="$PREFIX-$(printf "%03d" $NUMBER)"
    echo "🔍 Auto-detected feature: $FEATURE_INPUT (from directory: $CURRENT_DIR)"
elif [ -n "$1" ]; then
    # Feature number provided as argument
    FEATURE_INPUT="$1"
else
    # No feature number and not in worktree
    prefix=$(get_feature_prefix)
    echo "Usage: /specflow-finish [feature-number]"
    echo ""
    echo "Examples:"
    echo "  /specflow-finish ${prefix}-009    # From main directory"
    echo "  /specflow-finish ${prefix}-9      # From main directory" 
    echo "  /specflow-finish 009              # From main directory"
    echo "  /specflow-finish 9                # From main directory"
    echo "  /specflow-finish                  # From feature worktree (auto-detects)"
    echo ""
    echo "💡 TIP: Run from feature worktree to auto-detect feature number"
    exit 1
fi

FEATURE_NUMBER=$(normalize_feature_number "$FEATURE_INPUT")
BRANCH_NAME=$(get_branch_name "$FEATURE_NUMBER")
WORKTREE_PATH=$(get_worktree_path "$FEATURE_NUMBER")

# Check if worktree exists
if [ ! -d "$WORKTREE_PATH" ]; then
    echo "❌ Feature worktree not found: $WORKTREE_PATH"
    echo ""
    echo "🚀 NEXT STEP: Use /specflow-list to see active features"
    exit 1
fi

echo "🏁 Finishing feature: $FEATURE_NUMBER"
echo "📁 Worktree: $WORKTREE_PATH"
echo "🌿 Branch: $BRANCH_NAME"
echo ""

# Switch to feature worktree to check for uncommitted changes
cd "$WORKTREE_PATH"

# Check for uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
    echo "📝 Uncommitted changes found. Committing..."
    
    # Generate commit message based on feature
    SPEC_FILE="../$(detect_project_name)/$(get_spec_file "$FEATURE_NUMBER")"
    if [ -f "$SPEC_FILE" ]; then
        FEATURE_TITLE=$(head -1 "$SPEC_FILE" | sed 's/^# [^:]*: //')
        COMMIT_MSG="Implement $FEATURE_NUMBER: $FEATURE_TITLE"
    else
        COMMIT_MSG="Implement $FEATURE_NUMBER"
    fi
    
    git add .
    git commit -m "$COMMIT_MSG"
    echo "✅ Changes committed"
fi

# Get main branch
MAIN_BRANCH=$(detect_default_branch)

# Find main worktree
MAIN_WORKTREE=$(git worktree list | grep "\\[$MAIN_BRANCH\\]" | awk '{print $1}')
if [ -z "$MAIN_WORKTREE" ]; then
    echo "❌ Could not find main worktree"
    exit 1
fi

echo "🔄 Switching to main worktree: $MAIN_WORKTREE"
cd "$MAIN_WORKTREE"

# Fetch and merge
echo "📥 Fetching latest changes..."
git fetch origin

echo "🔀 Merging $BRANCH_NAME into $MAIN_BRANCH..."
git merge "$BRANCH_NAME" --no-ff -m "Merge $BRANCH_NAME

Completed feature implementation."

# Clean up
echo "🧹 Cleaning up..."
git branch -d "$BRANCH_NAME"
git worktree remove "$WORKTREE_PATH"

echo ""
echo "🎉 Feature $FEATURE_NUMBER completed successfully!"
echo "✅ Merged into $MAIN_BRANCH"
echo "✅ Branch deleted"
echo "✅ Worktree removed"
echo ""
echo "🚀 NEXT STEPS:"
echo "1. Exit Claude Code (the worktree directory no longer exists)"
echo "2. Run tests to verify integration: [your-test-command]"
echo "3. Consider running /specflow-plan for your next feature"
echo ""
echo "💡 TIP: You're now back in the main worktree and ready for the next feature!"
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