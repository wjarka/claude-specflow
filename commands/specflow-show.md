---
description: Show specification for current feature worktree
allowed-tools: [Bash, Read]
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
    echo "❌ Not in a feature worktree directory"  
    echo "Expected directory name pattern: {PROJECT}-$(get_feature_prefix)-{NUMBER}"
    echo "Current directory: $CURRENT_DIR"
    echo ""
    echo "🚀 NEXT STEP: Use /specflow-start <number> to create a feature worktree"
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

echo "📋 Feature Specification: $FEATURE_NUMBER"
echo "=========================================="

# Check if spec file exists
if [ ! -f "$SPEC_FILE" ]; then
    echo "❌ Spec file not found: $SPEC_FILE"
    echo ""
    echo "🚀 NEXT STEPS:"
    echo "1. cd ../$PROJECT_NAME"
    echo "2. Run /specflow-plan to create the specification"
    exit 1
fi

echo "📁 Worktree: $(pwd)"
echo "📋 Spec: $SPEC_FILE"
echo ""
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