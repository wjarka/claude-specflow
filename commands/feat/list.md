# List Features

Shows all active feature worktrees and their status.

## Usage
```bash
/feat/list
```

## What it shows
- Feature name and number
- Worktree path
- Branch name  
- Current status
- Suggested next steps for each feature

## Implementation
```bash
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
                echo "   Next: cd $WORKTREE_PATH && /feat/implement"
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
    echo "🚀 NEXT STEP: Run /feat/plan to start planning a new feature"
fi

echo ""
echo "💡 TIP: Use /feat/start <number> to create a new feature worktree"
```

## Example Output
```
🌿 Active feature worktrees:

📁 feat-001
   Path: ../my-project-feat-001
   Branch: feature/feat-001
   Status: ✅ Active
   Next: cd ../my-project-feat-001 && /feat/implement

📁 feat-002  
   Path: ../my-project-feat-002
   Branch: feature/feat-002
   Status: ✅ Active
   Next: cd ../my-project-feat-002 && /feat/implement

💡 TIP: Use /feat/start <number> to create a new feature worktree
```

## Next Steps Guidance
For each feature, the command shows:
- ✅ **Active**: Ready for development - cd to worktree and run `/feat/implement`
- ❌ **Directory missing**: Worktree reference is stale - needs cleanup
- 🚧 **In progress**: Implementation has started - cd to worktree to continue

## When No Features Exist
If no feature worktrees are found:
- Suggests running `/feat/plan` to start planning a new feature
- Shows how to create the first feature worktree