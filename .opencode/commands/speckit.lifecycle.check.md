---
description: "Check lifecycle phase — blocks execution when spec is locked"
---

# Lifecycle Check

Guard command. Runs as a mandatory before_* hook for core SDD commands.
Reads `.specify/feature.json` → discovers spec → reads `{spec_directory}/.lifecycle.json`.

## Prerequisites

1. **Read `.specify/feature.json`**:
   - If not found → **PASS** (no active spec = no lock)
     ```
     ✅ Lifecycle: active (no active feature)
     ```

2. Extract `feature_directory` (e.g. `specs/013-fix-auth`).
   If empty/missing → **PASS**:
   ```
   ✅ Lifecycle: active (no feature directory)
   ```

3. `LOCK_PATH = "{feature_directory}/.lifecycle.json"`

4. If `LOCK_PATH` does **not** exist → **PASS**:
   ```
   ✅ Lifecycle: active (no lock file for this spec)
   ```

5. Read JSON and extract `phase` field.

## Decision

### phase: "active" → PASS
```
✅ Lifecycle: active
```

### phase: "locked" → BLOCK
```
⛔ SPEC IS LOCKED — [spec_name]
Locked since: [locked_at]
Direct modification of spec/plan/tasks artifacts is blocked.

Use one of these controlled paths:
- /speckit.refine.update → update spec in-place (with audit trail)
- /speckit.bugfix.patch  → surgically patch artifacts (with traceability)

To unlock temporarily:
- /speckit.lifecycle.unlock → re-enable all commands
```

**Do NOT proceed with the parent command. Stop execution here.**

## Rules

- Read-only — never modifies any file
- If JSON is malformed or missing `phase`, treat as `active` (fail-open)
- After outputting BLOCK, do not continue the parent command execution
