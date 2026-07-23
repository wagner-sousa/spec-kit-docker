---
description: "Show current lifecycle phase and lock metadata"
---

# Lifecycle Status

Display the current lifecycle phase per spec, lock metadata, and which commands are affected.

## Action

1. **Read spec info**: Check `.specify/feature.json`:
   - If found → extract `feature_directory` and derive `spec_name` (e.g. `013-fix-auth` from `specs/013-fix-auth`)
   - If not found → spec = "—"

2. **Build lock path**: If `feature_directory` exists:
   `LOCK_PATH = "{feature_directory}/.lifecycle.json"`
   Read `LOCK_PATH`. If exists → parse JSON → extract `phase`, `locked_at`, `locked_by`
   If not found → phase = "active (no lock file)"

3. **Read lifecycle config**: `.specify/extensions/lifecycle/lifecycle-config.yml` → `blocked_commands` and `allowed_commands` lists. If config missing, use defaults.

4. **Display**:
   ```
   # Lifecycle Status
   
   **Spec**: [spec_name or "—"]
   **Phase**: [phase]
   **Locked at**: [locked_at or "—"]
   **Locked by**: [locked_by or "—"]
   ```

5. **Show command matrix** based on phase:

   If `active`:
   ```
   ## Command Availability
   
   | Category | Status |
   |----------|--------|
   | specify, clarify, plan, tasks, checklist, analyze | ✅ Available |
   | refine.*, bugfix.* | ✅ Available |
   | converge, review.*, verify.* | ✅ Available |
   | sync.apply, sync.backfill | ✅ Available |
   | lifecycle.* | ✅ Available |
   ```

   If `locked`:
   ```
   ## Command Availability
   
   | Category | Status |
   |----------|--------|
   | specify, clarify, plan, tasks, checklist, analyze | ⛔ Blocked |
   | refine.*, bugfix.* | ✅ Allowed |
   | converge, review.*, verify.* | ✅ Allowed |
   | sync.apply, sync.backfill | ⛔ Blocked |
   | sync.analyze, sync.propose, sync.conflicts | ✅ Allowed |
   | lifecycle.* | ✅ Allowed |
   ```

## Rules

- Read-only — never modifies any file
- Always output both phases for comparison
- If JSON is malformed or missing `phase`, treat as `active` (fail-open)
