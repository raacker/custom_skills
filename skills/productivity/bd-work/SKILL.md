---
name: bd-work
description: Automatically work through bd (Beads/Dolt) ready tasks by dependency order. Use when you want to continuously work on available bd tasks without manual task selection: check dependencies, claim work, execute one task at a time, verify, close, commit, and synchronize.
---

# bd-Work: Continuous Task Execution Skill

This skill works through available bd tasks from selection to verification.

## Required Skills

Load these skills first when available:

1. `bd-manual` - bd commands, priorities, dependencies, and synchronization.
2. `crg-manual` - graph-first repository exploration.

If either skill is missing, continue only if the repository has equivalent
project-local instructions. State the fallback briefly.

## Workflow

### Phase 1: Check Ready Tasks

1. Run `bd ready --json`.
2. Parse open tasks and dependency state.
3. Treat a task as ready only when it has no open blocking dependencies.

### Phase 2: Select and Claim Task

1. Sort ready tasks by priority: `0` highest, `4` lowest.
2. Pick the highest-priority ready task.
3. Inspect it with `bd show <id> --json`.
4. Claim it with `bd update <id> --claim --json`.

### Phase 3: Analyze Missing Dependencies

If the selected task depends on prerequisite work that does not exist in bd:

1. Create a prerequisite task with `bd create ... --json`.
2. Link it to the parent task with `--deps blocks:<parent-id>` or the project
   dependency convention.
3. Stop working on the parent and select ready work again.

### Phase 4: Explore and Execute

Before editing code:

1. Use code-review-graph MCP tools if the repository provides them.
2. Find existing implementation patterns, tests, dependencies, and impact.
3. Fall back to `rg` and direct file reads only when graph tooling is
   unavailable, empty, or stale.

Then implement the claimed task according to its bd body:

- Follow allowed files and do-not-touch paths.
- Keep work scoped to the acceptance criteria.
- Create discovered work in bd instead of expanding scope silently.

### Phase 5: Verify, Close, and Commit

1. Run the task's verification commands.
2. If the repository has `scripts/verify.sh`, run it before closing the task.
3. If verification passes:
   - Close the task with `bd close <id> --reason "Completed" --json`.
   - Commit code and bd state with a meaningful message.
4. If verification fails:
   - Leave the task open.
   - Report the failing command and the root cause if known.

### Phase 6: Synchronize

At session end, run the project synchronization workflow from `bd-manual`.
Default:

```bash
git pull --rebase
bd dolt push
git push
git status
```

## Rules

- bd is the source of truth for executable work.
- Use `--json` for bd commands.
- Do not maintain markdown task state outside bd.
- Do not close work without verification evidence.
- Keep bd/Dolt writes sequential; embedded databases can lock on concurrent
  writers.
- Respect user changes in the worktree. Do not revert unrelated edits.
