---
description: "Lock the active spec lifecycle — freeze spec/plan/tasks from further direct modification"
---

# Lock Lifecycle

Finalize the feature's specification artifacts. After locking:
- Commands in the lifecycle config's `blocked_commands` list will be **blocked**
- Commands in the lifecycle config's `allowed_commands` list remain open

## Action

1. **Read `.specify/feature.json`** → extract `feature_directory` (e.g. `specs/013-fix-auth`).
   If `feature.json` does not exist:
   ```
   ⛔ No active feature found. Run /speckit.specify first.
   ```
   **Stop.**

2. `LOCK_PATH = "{feature_directory}/.lifecycle.json"`

3. **Read lifecycle config** at `.specify/extensions/lifecycle/lifecycle-config.yml` (create default if not found).

4. **Confirm with user**: Ask explicitly before locking.
   ```
   Lock spec [feature_name]? This will block destructive commands.
   Blocked: specify, clarify, plan, tasks, checklist, analyze, sync.apply, sync.backfill
   Allowed: refine.*, bugfix.*
   Proceed? (yes/no)
   ```

5. **If confirmed**, create/update `LOCK_PATH`:
   ```json
   {
     "phase": "locked",
     "locked_at": "[ISO_DATE]",
     "locked_by": "user"
   }
   ```

6. **Output confirmation**:
   ```
   🔒 Spec [feature_name] locked.
   
   Blocked:  specify, clarify, plan, tasks, checklist, analyze, sync.apply, sync.backfill
   Allowed:  refine.*, bugfix.*, converge, review.*, verify.*, sync.analyze, sync.propose, doctor, git.*
   
   Use /speckit.lifecycle.status to verify.
   To unlock: /speckit.lifecycle.unlock
   ```

7. **Optional**: Run `/speckit.git.commit` to commit the lock state.

## Rules

- Requires explicit user confirmation — never lock silently
- Write the lifecycle.json file with valid JSON
- The lock applies per-feature, at `specs/NNN-feature/.lifecycle.json`
- `lock` never accepts `--spec-dir` — only locks the active spec
