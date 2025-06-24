# Claude Specflow - Feature Development

A toolkit for implementing multiple features simultaneously using isolated git worktrees and specification-driven development with Claude Code.

## ✨ Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/wjarka/claude-specflow/main/install.sh | bash
```

That's it! The toolkit is now available globally across all your projects.

## 🚀 Quick Start

```bash
# 1. Navigate to your project
cd my-project

# 2. Start Claude Code session and plan your first feature  
claude
/feat/plan

# 3. Start development (still in Claude session)
/feat/start 1

# 4. Switch to feature directory and start new Claude session
cd ../my-project-feat-001
claude

# 5. In the new Claude session, implement the feature
/feat/implement

# 6. When done, finish the feature (from main project directory)
cd ../my-project
claude
/feat/finish 1
```

## 📋 Available Commands

| Command | Description | Usage |
|---------|-------------|-------|
| `/feat/plan` | Interactive feature planning | Creates detailed specs |
| `/feat/start <n>` | Create feature worktree | `/feat/start 1` |
| `/feat/list` | Show active features | Lists all feature worktrees |
| `/feat/show` | Show current feature spec | Auto-detects from directory |
| `/feat/implement` | Sync and start coding | Must be in feature worktree |
| `/feat/finish <n>` | Complete and merge | `/feat/finish 1` |
| `/feat/sync <n>` | Sync with main branch | Usually not needed |

## 🔄 Development Workflow

### 1. **Planning Phase** (in main directory)
```bash
claude  # Start Claude Code session
/feat/plan
# → Creates specs/feat-001.md with detailed implementation plan
```

### 2. **Start Development** (still in Claude session)
```bash
/feat/start 1
# → Creates ../my-project-feat-001/ worktree
# → Creates feature/feat-001 branch
# → Links to specs/feat-001.md
```

### 3. **Implementation Phase** (in feature worktree)
```bash
cd ../my-project-feat-001
claude  # Start new Claude Code session
/feat/implement
# → Auto-syncs with main
# → Shows spec summary  
# → Starts implementation immediately (no re-approval needed)
```

### 4. **Completion Phase** (back in main directory)
```bash
cd ../my-project
claude  # Start Claude Code session
/feat/finish 1
# → Commits changes
# → Merges to main
# → Cleans up worktree and branch
# → Exit Claude (worktree directory deleted)
```

## ⚙️ Configuration

**Optional**: Create `.claude-specflow` in your project root to customize:

```bash
# Copy example configuration
cp ~/.claude-specflow/.claude-specflow.example .claude-specflow

# Edit as needed
FEATURE_PREFIX=story        # Default: feat
SPEC_DIR=requirements      # Default: specs  
DEFAULT_BRANCH=develop     # Default: main/master (auto-detected)
```

## 📁 Directory Structure

```
your-project/
├── .claude-specflow          # Optional config overrides
├── specs/                   # Feature specifications
│   ├── feat-001.md
│   └── feat-002.md
└── src/                     # Your project files

# Feature worktrees (created automatically)
../your-project-feat-001/    # Feature 1 isolated workspace
../your-project-feat-002/    # Feature 2 isolated workspace
```

## 🎯 Key Features

- **🔄 Parallel Development**: Work on multiple features simultaneously
- **📋 Specification-driven**: Every feature starts with detailed planning
- **🏝️ Isolated Workspaces**: Each feature has its own directory and branch
- **🤖 Smart Automation**: Auto-sync, auto-commit, auto-cleanup
- **🌍 Global Installation**: Install once, use everywhere
- **⚙️ Flexible Configuration**: Adapts to your project conventions
- **📱 Next-step Guidance**: Always know what to do next

## 🔧 Advanced Usage

### Multiple Features Simultaneously
```bash
claude  # Start Claude Code session
# Plan and start multiple features
/feat/plan    # Creates feat-001
/feat/plan    # Creates feat-002
/feat/start 1 # Work on feature 1
/feat/start 2 # Work on feature 2

# Work on them in parallel with separate Claude sessions
```

### Custom Configuration Example
```bash
# .claude-specflow
FEATURE_PREFIX=story
SPEC_DIR=requirements
DEFAULT_BRANCH=develop

# Results in:
# ../webapp-story-001/
# requirements/story-001.md
# feature/story-001 branch
```

### Checking Status
```bash
claude  # Start Claude Code session
/feat/list    # See all active features with next steps
/feat/show    # View current feature spec (from feature worktree)
```

## 🛠️ Installation Details

The install script:
1. Clones toolkit to `~/.claude-specflow`
2. Creates symlinks in `~/.claude/commands/feat/`
3. Links `~/.claude/CLAUDE.feat.md` for global instructions

### Manual Installation
```bash
git clone https://github.com/wjarka/claude-specflow ~/.claude-specflow
~/.claude-specflow/install.sh
```

### Upgrading
```bash
cd ~/.claude-specflow && git pull
# Symlinks automatically use the updated version
```

## 🏗️ Integration with Existing Projects

The toolkit adapts to your existing:
- **Git workflow**: Uses your main/master branch automatically
- **Directory structure**: Auto-detects project name
- **Conventions**: Configurable prefixes and directories
- **Tooling**: Works with any test runner, build system, etc.

## 📚 Examples

### Basic Feature
```bash
claude  # Start Claude Code session
/feat/plan
# Describe: "Add user authentication"
/feat/start 1
cd ../my-app-feat-001
claude  # Start new Claude session in feature worktree
/feat/implement
# [Claude implements the feature]
cd ../my-app
claude  # Start Claude session in main directory
/feat/finish 1
```

### Custom Prefix
```bash
echo "FEATURE_PREFIX=ticket" > .claude-specflow
/feat/start 42
# Creates: ../my-app-ticket-042/
# Branch: feature/ticket-042
# Spec: specs/ticket-042.md
```

## 🤝 Contributing

This toolkit is designed to be forked and customized for your organization's needs.

## 📄 License

This toolkit is designed to be copied and modified for your projects. Use freely.

---

**Ready to streamline your feature development?** Install now and start building features in isolated, specification-driven environments!