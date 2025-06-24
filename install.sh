#!/bin/bash

# Claude Specflow Installation Script
# Installs claude-specflow globally using symlinks for easy updates

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

echo "🔗 Creating symlinks..."

# Create symlink for feat commands
if [ -L "$CLAUDE_DIR/commands/feat" ]; then
    rm "$CLAUDE_DIR/commands/feat"
elif [ -d "$CLAUDE_DIR/commands/feat" ]; then
    echo "⚠️  Found existing feat directory, backing up to feat.backup"
    mv "$CLAUDE_DIR/commands/feat" "$CLAUDE_DIR/commands/feat.backup"
fi

ln -s "$TOOLKIT_DIR/commands/feat" "$CLAUDE_DIR/commands/feat"

# Create symlink for CLAUDE.feat.md
if [ -L "$CLAUDE_DIR/CLAUDE.feat.md" ]; then
    rm "$CLAUDE_DIR/CLAUDE.feat.md"
elif [ -f "$CLAUDE_DIR/CLAUDE.feat.md" ]; then
    echo "⚠️  Found existing CLAUDE.feat.md, backing up to CLAUDE.feat.md.backup"
    mv "$CLAUDE_DIR/CLAUDE.feat.md" "$CLAUDE_DIR/CLAUDE.feat.md.backup"
fi

ln -s "$TOOLKIT_DIR/CLAUDE.feat.md" "$CLAUDE_DIR/CLAUDE.feat.md"

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
echo "  /feat/plan     - Plan a new feature"
echo "  /feat/start    - Create feature worktree" 
echo "  /feat/list     - List active features"
echo "  /feat/show     - Show current feature spec"
echo "  /feat/implement - Sync and start implementation"
echo "  /feat/finish   - Complete and merge feature"
echo ""
echo "🚀 To get started:"
echo "1. cd to your project directory"
echo "2. Run /feat/plan to create your first feature"
echo ""
echo "💡 Optional: Copy .claude-specflow.example to your project root as .claude-specflow to customize settings"
echo ""
echo "📚 For more info, see the toolkit documentation or run /feat/plan to get started!"

# Check if running from the toolkit directory itself
if [[ "$PWD" == *"claude-specflow"* ]]; then
    echo ""
    echo "⚠️  Note: You're currently in the toolkit directory. Navigate to your project directory to start using the commands."
fi