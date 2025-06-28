#!/bin/bash

# Claude Specflow Installation Script
# Installs claude-specflow globally by copying files

set -e

# Preserve original working directory
ORIGINAL_DIR="$PWD"

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
for cmd in plan start list show implement finish sync update; do
    if [ -f "$CLAUDE_DIR/commands/specflow-$cmd.md" ] && [ ! -f "$CLAUDE_DIR/commands/specflow-$cmd.md.backup" ]; then
        echo "⚠️  Found existing specflow-$cmd.md, backing up to specflow-$cmd.md.backup"
        cp "$CLAUDE_DIR/commands/specflow-$cmd.md" "$CLAUDE_DIR/commands/specflow-$cmd.md.backup"
    fi
    cp "$TOOLKIT_DIR/commands/specflow-$cmd.md" "$CLAUDE_DIR/commands/specflow-$cmd.md"
done

# Copy CLAUDE.specflow.md
if [ -f "$CLAUDE_DIR/CLAUDE.specflow.md" ] && [ ! -f "$CLAUDE_DIR/CLAUDE.specflow.md.backup" ]; then
    echo "⚠️  Found existing CLAUDE.specflow.md, backing up to CLAUDE.specflow.md.backup"
    cp "$CLAUDE_DIR/CLAUDE.specflow.md" "$CLAUDE_DIR/CLAUDE.specflow.md.backup"
fi

cp "$TOOLKIT_DIR/CLAUDE.specflow.md" "$CLAUDE_DIR/CLAUDE.specflow.md"

# Add import to ~/.claude/CLAUDE.md for auto-loading
CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"
IMPORT_LINE="@CLAUDE.specflow.md"

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

# Copy bin directory with all scripts
echo "📋 Copying script files..."
mkdir -p "$TOOLKIT_DIR/bin"

# Copy all scripts from the repository to the installation directory
# (Note: We're in $TOOLKIT_DIR at this point from the cd above)
cp bin/*.sh "$TOOLKIT_DIR/bin/" 2>/dev/null || true

# Make all scripts executable
echo "🔧 Making scripts executable..."
chmod +x "$TOOLKIT_DIR/bin/"*.sh

echo "✅ Claude Specflow installed successfully!"
echo ""
echo "📋 Available commands:"
echo "  /specflow-plan     - Plan a new feature"
echo "  /specflow-start    - Create feature worktree" 
echo "  /specflow-list     - List active features"
echo "  /specflow-show     - Show current feature spec"
echo "  /specflow-implement - Sync and start implementation"
echo "  /specflow-finish   - Complete and merge feature"
echo "  /specflow-sync     - Sync feature with main branch"
echo "  /specflow-update   - Update specflow toolkit"
echo ""
echo "🚀 To get started:"
echo "1. cd to your project directory"
echo "2. Run /specflow-plan to create your first feature"
echo ""
echo "💡 Optional: Copy .claude-specflow.example to your project root as .claude-specflow to customize settings"
echo ""
echo "📚 For more info, see the toolkit documentation or run /specflow-plan to get started!"

# Check if running from the toolkit directory itself
if [[ "$ORIGINAL_DIR" == *"claude-specflow"* ]]; then
    echo ""
    echo "⚠️  Note: You're currently in the toolkit directory. Navigate to your project directory to start using the commands."
fi