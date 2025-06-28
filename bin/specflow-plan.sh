#!/bin/bash

# This script provides helper functions for the specflow-plan command
# The actual planning is done by Claude through the command interface

# Load toolkit configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/specflow-config.sh" 2>/dev/null || {
    echo "❌ Toolkit config not found. Please install claude-specflow first."
    echo "Run: curl -fsSL https://raw.githubusercontent.com/wjarka/claude-specflow/main/install.sh | bash"
    exit 1
}
init_config

# Function to find the next available feature number
find_next_feature_number() {
    local prefix=$(get_feature_prefix)
    local spec_dir=$(get_spec_dir)
    local max_num=0
    
    # Create spec directory if it doesn't exist
    mkdir -p "$spec_dir"
    
    # Find highest existing feature number
    for file in "$spec_dir"/$prefix-*.md; do
        if [ -f "$file" ]; then
            # Extract number from filename
            local num=$(basename "$file" .md | sed "s/^$prefix-//")
            # Remove leading zeros to avoid octal interpretation
            num=$(echo "$num" | sed 's/^0*//')
            # Handle edge case where num becomes empty (was "000")
            if [ -z "$num" ]; then
                num=0
            fi
            if [ "$num" -gt "$max_num" ]; then
                max_num=$num
            fi
        fi
    done
    
    # Return next number (padded to 3 digits)
    printf "%s-%03d" "$prefix" $((max_num + 1))
}

# Function to create spec file with given content
create_spec_file() {
    local feature_number="$1"
    local content="$2"
    local spec_dir=$(get_spec_dir)
    local spec_file="$spec_dir/$feature_number.md"
    
    # Create spec directory if it doesn't exist
    mkdir -p "$spec_dir"
    
    # Write content to spec file
    echo "$content" > "$spec_file"
    
    echo "✅ Plan documented in $spec_file"
    echo ""
    echo "🚀 NEXT STEP: Run \`/specflow-start ${feature_number##*-}\` to create the feature worktree"
}

# If called directly, handle based on arguments
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    if [ $# -eq 0 ]; then
        # No arguments: show next available feature number
        NEXT_FEATURE=$(find_next_feature_number)
        echo "Next available feature number: $NEXT_FEATURE"
    elif [ $# -eq 1 ]; then
        # One argument: create spec file with provided content
        CONTENT="$1"
        NEXT_FEATURE=$(find_next_feature_number)
        create_spec_file "$NEXT_FEATURE" "$CONTENT"
    else
        echo "Usage: $0 [content]"
        echo "  No args: Show next available feature number"
        echo "  With content: Create spec file with content"
        exit 1
    fi
fi