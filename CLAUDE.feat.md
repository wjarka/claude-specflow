# Claude Specflow - Feature Development

## Auto-detection & Configuration

**Auto-detection**: If working in a feature worktree (directory pattern `{PROJECT}-{PREFIX}-XXX`), this session automatically links to the corresponding specification file.

Configuration is loaded from `.claude-specflow` file (see @.claude-specflow.example):
- `FEATURE_PREFIX` (default: feat)
- `SPEC_DIR` (default: specs)  
- `PROJECT_NAME` (default: auto-detected from directory)
- `DEFAULT_BRANCH` (default: auto-detected main/master)

## Workflow Overview

This toolkit enables parallel feature development using isolated git worktrees and specification-driven development:

1. **Plan** → `/specflow-plan` - Create detailed specification
2. **Start** → `/specflow-start <number>` - Create isolated worktree
3. **Implement** → `/specflow-implement` - Sync and start coding
4. **Finish** → `/specflow-finish <number>` - Merge back and cleanup

## Implementation Guidelines

**IMPORTANT**: When working in a feature worktree:
- **Always show the specification first** using `/specflow-show` when asked "What are we working on?"
- **Present an implementation plan** and **wait for user approval** before starting any coding
- **Exception**: If user asks "What are we working on?" → you show spec → user says "implement this", you can start immediately without re-approval
- **Never start implementing immediately** on initial requests - always confirm the approach first
- Use TodoWrite to plan tasks and get explicit approval before proceeding

## Available Commands

- `/specflow-plan` - Interactive feature planning and specification creation
- `/specflow-start <number>` - Create isolated feature worktree
- `/specflow-list` - Show all active features with next steps
- `/specflow-sync <number>` - Sync feature with main branch
- `/specflow-show` - Show current feature specification (auto-detected)
- `/specflow-implement` - Auto-detect, sync, and start implementation
- `/specflow-finish <number>` - Merge back and cleanup

## Git Workflow

- Clear, descriptive commit messages explaining the "why"
- No Claude Code attribution in commits
- Each feature gets its own branch: `feature/{PREFIX}-XXX`
- Automatic cleanup after merge

## Installation

Install once globally:
```bash
curl -fsSL https://raw.githubusercontent.com/wjarka/claude-specflow/main/install.sh | bash
```

Per project setup (optional):
```bash
# Create configuration file to override defaults
cp .claude-specflow.example .claude-specflow
# Edit as needed
```

## Directory Structure

```
your-project/
├── .claude-specflow          # Optional configuration overrides
├── specs/                   # Feature specifications  
│   ├── feat-001.md
│   └── feat-002.md
└── src/                     # Your project files

# Feature worktrees created as siblings
../your-project-feat-001/    # Feature 1 worktree
../your-project-feat-002/    # Feature 2 worktree
```

## Key Benefits

- **Parallel Development**: Work on multiple features simultaneously
- **Specification-driven**: Features start with detailed planning
- **Isolated Environment**: Each feature has its own workspace and branch
- **Automatic Cleanup**: Branches and worktrees cleaned up automatically
- **Global Installation**: Install once, use in any project
- **Flexible Configuration**: Adapts to your project conventions