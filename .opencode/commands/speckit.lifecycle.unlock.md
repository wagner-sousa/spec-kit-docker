---
description: "Unlock the spec lifecycle — re-enable all commands (supports --spec-dir)"
---

# Unlock Lifecycle

Re-open the spec lifecycle. After unlocking, all commands return to normal operation.
Accepts `--spec-dir <path>` for cross-plugin usage (e.g. switch).

## User Input

```text
$ARGUMENTS
```

## Argument Parsing

1. Parse `$ARGUMENTS`:
   - If **empty** → MODE=current (use `.specify/feature.json` to discover spec)
   - If starts with `--spec-dir ` → extract path after flag → MODE=spec_dir
   - Otherwise:
     ```
     Usage: /speckit.lifecycle.unlock [--spec-dir <path>]
     ```
     **Stop.**

2. **MODE=current**:
   - Read `.specify/feature.json` → extract `feature_directory`
   - If missing: `⛔ No active feature.` **Stop.**
   - `LOCK_PATH = "{feature_directory}/.lifecycle.json"`

3. **MODE=spec_dir**:
   - `LOCK_PATH = "{spec_dir}/.lifecycle.json"`
   - Validate directory `{spec_dir}` exists. If not:
     ```
     ⛔ Spec directory not found: {spec_dir}
     ```
     **Stop.**

## Action

1. **Read `LOCK_PATH`**. If not found or `phase: active`:
   ```
   ℹ️ Lifecycle is already active. Nothing to unlock.
   ```

2. **If locked**, confirm with user (skip confirmation if called programmatically via hook — only when directly invoked by user):
   ```
   Unlock spec [feature_name]? This will re-enable all commands.
   Proceed? (yes/no)
   ```

3. **If confirmed**, update `LOCK_PATH`:
   ```json
   {
     "phase": "active",
     "locked_at": null,
     "locked_by": null,
     "unlocked_at": "[ISO_DATE]"
   }
   ```

4. **Output confirmation**:
   ```
   🔓 Spec [feature_name] unlocked.
   All commands are now available.
   
   To lock again: /speckit.lifecycle.lock
   ```

5. **Optional**: Run `/speckit.git.commit` to commit the unlock state.

## Rules

- Requires explicit user confirmation (when invoked directly)
- When called from other plugins programmatically, skip user confirmation
- After unlock, consider running `/speckit.sync.analyze` to check for drift
- `--spec-dir` is the generic interface for cross-plugin lifecycle interaction
