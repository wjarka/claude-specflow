#!/bin/bash

set -e

echo "🔄 Updating Claude Specflow..."

# Find the toolkit directory
TOOLKIT_DIR="$HOME/.claude-specflow"

if [ ! -d "$TOOLKIT_DIR" ]; then
    echo "❌ Claude Specflow not found. Please run the installer first:"
    echo "   curl -fsSL https://raw.githubusercontent.com/wjarka/claude-specflow/main/install.sh | bash"
    exit 1
fi

# Run the install script from the toolkit directory
cd "$TOOLKIT_DIR"
./install.sh

echo ""
echo "✅ Update complete!"
echo ""
echo "⚠️  You may need to restart Claude Code for changes to take effect."