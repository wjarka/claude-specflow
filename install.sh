#!/bin/bash

# Claude Specflow Installation Script
# Installs claude-specflow from git repository, local directory, or specific branch

set -e

# Default values
BRANCH=""
USE_LOCAL=false
ORIGINAL_DIR="$PWD"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --local|-l)
            USE_LOCAL=true
            shift
            ;;
        --branch|-b)
            BRANCH="$2"
            shift 2
            ;;
        --help|-h)
            echo "Claude Specflow Installation"
            echo ""
            echo "Usage: ./install.sh [options]"
            echo ""
            echo "Options:"
            echo "  --local, -l            Install from current local directory (for development)"
            echo "  --branch, -b <branch>  Install from specific git branch (default: main)"
            echo "  --help, -h             Show this help message"
            echo ""
            echo "Examples:"
            echo "  ./install.sh               # Install from main branch"
            echo "  ./install.sh --local       # Install from current directory"
            echo "  ./install.sh -b develop    # Install from develop branch"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

TOOLKIT_DIR="$HOME/.claude-specflow"
CLAUDE_DIR="$HOME/.claude"
REPO_URL="https://github.com/wjarka/claude-specflow.git"

# Determine installation mode
if [ "$USE_LOCAL" = true ]; then
    # Find the script directory (where install.sh is located)
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    SOURCE_DIR="$SCRIPT_DIR"
    echo "🚀 Installing Claude Specflow from local directory: $SOURCE_DIR"
else
    echo "🚀 Installing Claude Specflow from git repository (branch: ${BRANCH:-main})"
fi

# Create .claude directory if it doesn't exist
mkdir -p "$CLAUDE_DIR/commands"

# Handle installation source
if [ "$USE_LOCAL" = true ]; then
    # Local installation - copy files directly
    echo "📋 Copying files from local directory..."
    
    # Create toolkit directory if it doesn't exist
    mkdir -p "$TOOLKIT_DIR"
    
    # Copy all files from local directory to toolkit directory
    # Using rsync if available for better handling, otherwise cp
    if command -v rsync &> /dev/null; then
        rsync -av --exclude='.git' --exclude='*.backup' --exclude='node_modules' "$SOURCE_DIR/" "$TOOLKIT_DIR/"
    else
        # Fallback to cp
        cp -r "$SOURCE_DIR"/* "$TOOLKIT_DIR/" 2>/dev/null || true
        cp "$SOURCE_DIR"/.claude-specflow.example "$TOOLKIT_DIR/" 2>/dev/null || true
    fi
else
    # Git installation
    if [ -d "$TOOLKIT_DIR" ]; then
        echo "📥 Updating existing installation..."
        cd "$TOOLKIT_DIR"
        git fetch
        if [ -n "$BRANCH" ]; then
            git checkout "$BRANCH"
            git pull origin "$BRANCH"
        else
            git checkout main
            git pull origin main
        fi
    else
        echo "📥 Downloading claude-specflow..."
        if [ -n "$BRANCH" ]; then
            git clone -b "$BRANCH" "$REPO_URL" "$TOOLKIT_DIR"
        else
            git clone "$REPO_URL" "$TOOLKIT_DIR"
        fi
    fi
    SOURCE_DIR="$TOOLKIT_DIR"
fi

echo "📋 Copying command files..."

# Copy specflow commands
for cmd in plan start list show implement finish sync update; do
    if [ -f "$CLAUDE_DIR/commands/specflow-$cmd.md" ] && [ ! -f "$CLAUDE_DIR/commands/specflow-$cmd.md.backup" ]; then
        echo "⚠️  Found existing specflow-$cmd.md, backing up to specflow-$cmd.md.backup"
        cp "$CLAUDE_DIR/commands/specflow-$cmd.md" "$CLAUDE_DIR/commands/specflow-$cmd.md.backup"
    fi
    cp "$SOURCE_DIR/commands/specflow-$cmd.md" "$CLAUDE_DIR/commands/specflow-$cmd.md"
done

# Copy CLAUDE.specflow.md
if [ -f "$CLAUDE_DIR/CLAUDE.specflow.md" ] && [ ! -f "$CLAUDE_DIR/CLAUDE.specflow.md.backup" ]; then
    echo "⚠️  Found existing CLAUDE.specflow.md, backing up to CLAUDE.specflow.md.backup"
    cp "$CLAUDE_DIR/CLAUDE.specflow.md" "$CLAUDE_DIR/CLAUDE.specflow.md.backup"
fi

cp "$SOURCE_DIR/CLAUDE.specflow.md" "$CLAUDE_DIR/CLAUDE.specflow.md"

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

# Ensure bin directory exists in toolkit directory
mkdir -p "$TOOLKIT_DIR/bin"

# Make all scripts executable
echo "🔧 Making scripts executable..."
chmod +x "$TOOLKIT_DIR/bin/"*.sh 2>/dev/null || true

echo "✅ Claude Specflow installed successfully!"
echo ""

# Display installation summary
if [ "$USE_LOCAL" = true ]; then
    echo "📦 Installed from: Local directory ($SOURCE_DIR)"
else
    echo "📦 Installed from: Git repository (branch: ${BRANCH:-main})"
fi
echo "📂 Installation directory: $TOOLKIT_DIR"
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
echo "1. Navigate to your project directory"
echo "2. Start a Claude session (claude or claude-code)"
echo "3. Run /specflow-plan to create your first feature"
echo ""
echo "💡 Optional: Copy .claude-specflow.example to your project root as .claude-specflow to customize settings"

if [ "$USE_LOCAL" = true ]; then
    echo ""
    echo "💻 Development tips:"
    echo "  - Run ./install.sh --local after making changes"
    echo "  - Use ./install.sh -b <branch> to test from a git branch"
    echo "  - Your existing files were backed up with .backup extension"
fi

echo ""
echo "📚 For more info, see the toolkit documentation or run /specflow-plan to get started!"

# Return to original directory
cd "$ORIGINAL_DIR"