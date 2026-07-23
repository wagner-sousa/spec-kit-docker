# SDD Lifecycle Manager

Phase-gate lifecycle for Spec Kit. Lock spec artifacts after finalization.
Block destructive commands. Allow only controlled paths (refine/bugfix).

## Commands

| Command | Description |
|---------|-------------|
| `/speckit.lifecycle.check` | Guard hook — blocks execution when spec is locked |
| `/speckit.lifecycle.lock` | Lock the lifecycle — freeze spec artifacts |
| `/speckit.lifecycle.unlock` | Unlock the lifecycle — re-enable all commands |
| `/speckit.lifecycle.status` | Show current phase and command availability |

## State File

`.specify/lifecycle.json`

```json
{ "phase": "active", "locked_at": null, "locked_by": null }
```

## Integration

The extension registers `before_*` hooks on:
- `before_specify`, `before_clarify`, `before_plan`, `before_tasks`
- `before_checklist`, `before_analyze`
- `before_sync_apply`, `before_sync_backfill`

And `after_converge` to suggest locking when converged.

## Behavior

| Commands | active | locked |
|----------|:------:|:------:|
| specify, clarify, plan, tasks, checklist, analyze | ✅ | ⛔ |
| refine.*, bugfix.* | ✅ | ✅ |
| converge, review.*, verify.* | ✅ | ✅ |
| sync.apply, sync.backfill | ✅ | ⛔ |
| lifecycle.* | ✅ | ✅ |
