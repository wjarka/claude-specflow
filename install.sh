#!/bin/bash

# Claude Specflow Installation Script
# Installs claude-specflow globally by copying files

set -e

TOOLKIT_DIR="$HOME/.claude-specflow"
CLAUDE_DIR="$HOME/.claude"
REPO_URL="https://github.com/wjarka/claude-specflow.git"

echo "🚀 Installing Claude Specflow..."

# Create .claude directory if it doesn't exist
mkdir -p "$CLAUDE_DIR/commands"

# Clone or update toolkit repository
if [ -d "$TOOLKIT_DIR" ]; then
    echo "📥 Updating existing installation..."
    cd "$TOOLKIT_DIR"
    git pull
else
    echo "📥 Downloading claude-specflow..."
    git clone "$REPO_URL" "$TOOLKIT_DIR"
fi

echo "📋 Copying command files..."

# Copy specflow commands
for cmd in plan start list show implement finish sync; do
    if [ -f "$CLAUDE_DIR/commands/specflow-$cmd" ] && [ ! -f "$CLAUDE_DIR/commands/specflow-$cmd.backup" ]; then
        echo "⚠️  Found existing specflow-$cmd, backing up to specflow-$cmd.backup"
        cp "$CLAUDE_DIR/commands/specflow-$cmd" "$CLAUDE_DIR/commands/specflow-$cmd.backup"
    fi
    cp "$TOOLKIT_DIR/commands/specflow-$cmd.md" "$CLAUDE_DIR/commands/specflow-$cmd"
done

# Copy CLAUDE.feat.md
if [ -f "$CLAUDE_DIR/CLAUDE.feat.md" ] && [ ! -f "$CLAUDE_DIR/CLAUDE.feat.md.backup" ]; then
    echo "⚠️  Found existing CLAUDE.feat.md, backing up to CLAUDE.feat.md.backup"
    cp "$CLAUDE_DIR/CLAUDE.feat.md" "$CLAUDE_DIR/CLAUDE.feat.md.backup"
fi

cp "$TOOLKIT_DIR/CLAUDE.feat.md" "$CLAUDE_DIR/CLAUDE.feat.md"

# Add import to ~/.claude/CLAUDE.md for auto-loading
CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"
IMPORT_LINE="@CLAUDE.feat.md"

if [ -f "$CLAUDE_MD" ]; then
    # Check if import already exists
    if ! grep -Fxq "$IMPORT_LINE" "$CLAUDE_MD"; then
        echo "" >> "$CLAUDE_MD"
        echo "# Claude Specflow - Feature Development" >> "$CLAUDE_MD"
        echo "$IMPORT_LINE" >> "$CLAUDE_MD"
        echo "✅ Added Claude Specflow import to CLAUDE.md"
    else
        echo "✅ Claude Specflow import already exists in CLAUDE.md"
    fi
else
    # Create CLAUDE.md with import
    echo "# Claude Configuration" > "$CLAUDE_MD"
    echo "" >> "$CLAUDE_MD"
    echo "# Claude Specflow - Feature Development" >> "$CLAUDE_MD"
    echo "$IMPORT_LINE" >> "$CLAUDE_MD"
    echo "✅ Created CLAUDE.md with Claude Specflow import"
fi

# Make toolkit scripts executable (update path since .claude/scripts was removed)
chmod +x "$TOOLKIT_DIR/specflow-config.sh"

echo "✅ Claude Specflow installed successfully!"
echo ""
echo "📋 Available commands:"
echo "  /specflow-plan     - Plan a new feature"
echo "  /specflow-start    - Create feature worktree" 
echo "  /specflow-list     - List active features"
echo "  /specflow-show     - Show current feature spec"
echo "  /specflow-implement - Sync and start implementation"
echo "  /specflow-finish   - Complete and merge feature"
echo ""
echo "🚀 To get started:"
echo "1. cd to your project directory"
echo "2. Run /specflow-plan to create your first feature"
echo ""
echo "💡 Optional: Copy .claude-specflow.example to your project root as .claude-specflow to customize settings"
echo ""
echo "📚 For more info, see the toolkit documentation or run /specflow-plan to get started!"

# Check if running from the toolkit directory itself
if [[ "$PWD" == *"claude-specflow"* ]]; then
    echo ""
    echo "⚠️  Note: You're currently in the toolkit directory. Navigate to your project directory to start using the commands."
fi