---
description: Interactive feature planning that creates a structured implementation plan
allowed-tools: [Bash, Read, Write, Glob, Grep, TodoWrite]
---

# Plan Feature

Interactive feature planning that creates a structured implementation plan and documents it in the specs directory.

## Usage

When prompted, provide a feature description and this command will:

1. Analyze the feature requirements
2. Create a detailed implementation plan
3. Present the plan for your approval
4. Document the approved plan in `{SPEC_DIR}/{PREFIX}-XXX.md`

## Process Flow

### Step 1: Feature Analysis

- Examine current codebase architecture
- Identify integration points and dependencies
- Assess complexity and implementation approach

### Step 2: Implementation Plan Creation

Creates a structured plan including:

- **Overview**: What the feature does and why it's needed
- **Requirements**: Functional and non-functional requirements
- **Architecture**: How it fits into existing codebase
- **Implementation Steps**: Detailed breakdown of work needed
- **Testing Strategy**: How to validate the implementation
- **Dependencies**: Required libraries, APIs, or other features
- **Acceptance Criteria**: Definition of done

### Step 3: Plan Review and Approval

- Present the complete plan for review
- Allow modifications and refinements
- Get explicit approval before documenting

### Step 4: Documentation & Next Steps

- Use Bash tool to call `~/.claude-specflow/bin/specflow-plan.sh "$SPEC_CONTENT"` to create spec file with proper {PREFIX}-XXX.md naming
- The script handles finding next available feature number and creating the file
- **Guide user to next step**: `/specflow-start <number>`

## Example Usage

```
/specflow-plan

> Please describe the feature you want to implement:
"Add Spotify playlist import functionality"

[Claude analyzes and creates implementation plan]

> Here's the implementation plan for your review:
[Detailed plan presentation]

> Do you approve this plan? (yes/no/modify):
yes

✅ Plan documented in specs/feat-009.md

🚀 NEXT STEP: Run `/specflow-start 9` to create the feature worktree
```

## Output Format

The generated spec file follows this structure:

```markdown
# {PREFIX}-XXX: [Feature Title]

## Overview

[Feature description and purpose]

## Requirements

### Functional Requirements

- [List of functional requirements]

### Non-Functional Requirements

- [Performance, security, etc.]

## Architecture

[How it integrates with existing code]

## Implementation Plan

### Phase 1: [Phase name]

- [Detailed steps]

### Phase 2: [Phase name]

- [Detailed steps]

## Testing Strategy

[How to test the feature]

## Dependencies

[Required libraries, APIs, etc.]

## Acceptance Criteria

- [Measurable criteria for completion]
```
