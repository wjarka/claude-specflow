# /specflow-update

Update Claude Specflow to the latest version.

## Usage
```
/specflow-update
```

## Description
This command updates Claude Specflow by:
1. Pulling the latest changes from the repository
2. Reinstalling all command files and scripts
3. Backing up any existing customizations

## Notes
- You may need to restart Claude Code after updating
- Existing customizations are automatically backed up
- The update process preserves your project-specific configurations
- If any step fails, the update will stop and report the error

## Example
```bash
/specflow-update
```

## Implementation
When this command is run, execute the specflow-update script:

```bash
~/.claude-specflow/bin/specflow-update.sh
```