#!/bin/bash

# Claude Specflow Configuration and Auto-detection
# Shared functions for all claude-specflow scripts

# Default configuration
DEFAULT_PROJECT_NAME=""
DEFAULT_FEATURE_PREFIX="feat"
DEFAULT_SPEC_DIR="specs"
DEFAULT_BRANCH=""

# Load configuration from .claude-specflow file if it exists
load_config() {
    local config_file=".claude-specflow"

    # Try current directory first, then parent directories up to 3 levels
    for dir in "." ".." "../.." "../../.."; do
        if [ -f "$dir/$config_file" ]; then
            # Source the config file
            source "$dir/$config_file"
            break
        fi
    done
}

# Auto-detect project name from current directory
detect_project_name() {
    if [ -n "$PROJECT_NAME" ]; then
        echo "$PROJECT_NAME"
    else
        basename "$PWD"
    fi
}

# Auto-detect default branch
detect_default_branch() {
    if [ -n "$DEFAULT_BRANCH" ]; then
        echo "$DEFAULT_BRANCH"
        return
    fi

    # Try git's default branch first
    local default_branch
    default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
    if [ -n "$default_branch" ]; then
        echo "$default_branch"
        return
    fi

    # Try worktree list for main/master
    default_branch=$(git worktree list 2>/dev/null | grep -E '\[(main|master)\]$' | head -1 | sed 's/.*\[\(.*\)\]$/\1/')
    if [ -n "$default_branch" ]; then
        echo "$default_branch"
        return
    fi

    # Check if main or master branches exist locally
    if git show-ref --verify --quiet refs/heads/main; then
        echo "main"
        return
    fi

    if git show-ref --verify --quiet refs/heads/master; then
        echo "master"
        return
    fi

    # Fallback to main
    echo "main"
}

# Get feature prefix
get_feature_prefix() {
    if [ -n "$FEATURE_PREFIX" ]; then
        echo "$FEATURE_PREFIX"
    else
        echo "$DEFAULT_FEATURE_PREFIX"
    fi
}

# Get spec directory
get_spec_dir() {
    if [ -n "$SPEC_DIR" ]; then
        echo "$SPEC_DIR"
    else
        echo "$DEFAULT_SPEC_DIR"
    fi
}

# Normalize feature number to standard format (e.g., "9" -> "feat-009")
normalize_feature_number() {
    local input="$1"
    local prefix=$(get_feature_prefix)

    # Remove prefix if present
    input=$(echo "$input" | sed "s/^$prefix-//")

    # Remove leading zeros to avoid octal interpretation, then pad
    input=$(echo "$input" | sed 's/^0*//')
    # Handle edge case where input becomes empty (was "000")
    if [ -z "$input" ]; then
        input="0"
    fi

    # Pad with zeros to 3 digits
    printf "%s-%03d" "$prefix" "$input"
}

# Get worktree path for a feature
get_worktree_path() {
    local feature_number="$1"
    local project_name=$(detect_project_name)
    echo "../$project_name-$feature_number"
}

# Get branch name for a feature
get_branch_name() {
    local feature_number="$1"
    echo "feature/$feature_number"
}

# Get spec file path for a feature
get_spec_file() {
    local feature_number="$1"
    local spec_dir=$(get_spec_dir)
    echo "$spec_dir/$feature_number.md"
}

# Extract feature number from current directory name
extract_feature_from_dir() {
    local current_dir=$(basename "$PWD")
    local project_name=$(detect_project_name)
    local prefix=$(get_feature_prefix)

    # Check if we're in a feature worktree
    if [[ "$current_dir" =~ ^$project_name-$prefix-[0-9]+$ ]]; then
        echo "$current_dir" | sed "s/$project_name-//"
    else
        return 1
    fi
}

# Initialize configuration (call this at the start of each script)
init_config() {
    load_config
}
