## How to work on tasks

By using helpful tools, associates tasks with detailed descriptions and get tasks done in the most efficient way. If it is not efficient enough, always suggest how to improve.

### Grossaries

- bd: beads. Task management system.
- crg: code-review-graph. Better code analyzation tool.
- scripts/verify.sh: verification and lint tool.

### Mandatory Workflow

1. **Check ready work**: Run `bd ready`
2. **Claim available work and read description**: Clame it and get the task description by `bd update <id> --claim --json`
3. **Run quality gates**: Before mark the task done, run `scripts/verify.sh` and fix failures. Do not separately run test, analyze, lint.
4. **Update issue status** - `bd close <id> --reason "Completed"`
5. **Commit** - create a commit.

### Workflow Rules

- Use `bd` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Do not use `--json` argument for `bd` unless you need detailed descriptions.
- Prefer `crg` results before Grep/Glob/Read for repository exploration.
- Keep `crg` queries focused on the current task.
- If `crg` output is empty, verify with local files.
- Use `git diff --stat` before full diffs. Inspect full diffs only for touched files or when the stat suggests unexpected churn.

### Reference Documents if required

- Read `docs/prd.md` for product requirements, MVP scope, acceptance signals, and scenario definitions.
- Read `docs/architecture.md` for technical design, component boundaries, data flow, error handling, and testing strategy before changing implementation structure.
- Read `docs/business_analysis.md` for customer pain, validation criteria, fatal flaws, differentiation, and out-of-scope constraints when product scope is unclear.
- Use `task_only_for_reference.md` only as a traceability snapshot. 

### bd(beads) manual

#### bd(beads) reference

```bash
bd ready                        # Find available work
bd show <id> --json             # View issue details
bd update <id> --claim          # Claim work
bd close <id>                   # Complete work
bd prime --json                 # Detailed command reference and session close protocol
bd remember --json              # For persistent knowledge
```

#### Task Priorities

- `0` Critical: security, data loss, build failure.
- `1` High: major feature or important bug.
- `2` Medium: normal planned work.
- `3` Low: polish or optimization.
- `4` Backlog: future idea.

#### Issue Types

- `bug`: broken behavior.
- `feature`: user-facing or product capability.
- `task`: tests, docs, refactors, research, validation.
- `epic`: parent issue for a capability or milestone.
- `chore`: maintenance, tooling, dependency work.

### code-review-graph manual

#### First Tool by Situation

| Situation | Tool |
| --- | --- |
| Minimal task context | `get_minimal_context` |
| Code search | `semantic_search_nodes`, `query_graph` |
| Change review | `detect_changes`, `get_review_context` |
| Impact analysis | `get_impact_radius`, `get_affected_flows` |
| Call or dependency tracing | `query_graph` |
| Test discovery | `query_graph` with `tests_for` |
| Architecture overview | `get_architecture_overview`, `list_communities` |
| Refactoring checks | `refactor_tool` |

#### Usage rule

1. To start reviewing code, use `get_minimal_context` for the current task.
2. For reviews, run `detect_changes` before reading changed files manually.
3. For impact checks, run `get_impact_radius` and `get_affected_flows`.
4. For tests, use `query_graph` with the `tests_for` pattern before raw search.
5. If graph tools fail or return no useful data, state the fallback briefly and
   use `rg`, file reads, or other local inspection as needed.

