#!/bin/bash

echo "🌿 Active feature worktrees:"
echo ""

# Get all worktrees
WORKTREES=$(git worktree list --porcelain)

# Parse worktrees and find feature branches
FOUND_FEATURES=false

while IFS= read -r line; do
    if [[ $line == worktree* ]]; then
        WORKTREE_PATH=${line#worktree }
        continue
    fi

    if [[ $line == branch* ]]; then
        BRANCH=${line#branch }

        # Check if this is a feature branch
        if [[ $BRANCH == refs/heads/feature/* ]]; then
            FEATURE_BRANCH=${BRANCH#refs/heads/feature/}
            WORKTREE_NAME=$(basename "$WORKTREE_PATH")

            echo "📁 $FEATURE_BRANCH"
            echo "   Path: $WORKTREE_PATH"
            echo "   Branch: feature/$FEATURE_BRANCH"

            # Check if worktree directory exists
            if [ -d "$WORKTREE_PATH" ]; then
                echo "   Status: ✅ Active"
                echo "   Next: cd $WORKTREE_PATH && /specflow-implement"
            else
                echo "   Status: ❌ Directory missing"
                echo "   Next: git worktree remove $WORKTREE_PATH"
            fi

            echo ""
            FOUND_FEATURES=true
        fi
    fi
done <<< "$WORKTREES"

if [ "$FOUND_FEATURES" = false ]; then
    echo "No active feature worktrees found."
    echo ""
    echo "🚀 NEXT STEP: Run /specflow-plan to start planning a new feature"
fi

echo ""
echo "💡 TIP: Use /specflow-start <number> to create a new feature worktree"