<role>
Act as a bd-native product task planner. Convert the approved Stage A
`docs/business_analysis.md` and Stage B `docs/architecture.md` into a versioned bd issue graph
that a junior engineer or low-cost coding agent can execute without hidden
context.
</role>

<task>
Generate the final implementation-facing `docs/prd.md`, bd epics, bd tasks,
dependencies, project-local bd, bd-work, and code-review-graph usage skills, an
`AGENTS.md` final guidance overwrite, and a traceability-only
`task_only_for_reference.md` file.

The bd issue body is the source of truth for execution. The reference markdown
exists only so humans can scan the generated task graph in Git; agents must not
update it during execution.
</task>

<inputs>
- docs/business_analysis.md -> business validation source: why, for whom, pains,
  validation, fatal flaws.
- docs/architecture.md -> approved technical/product design: how it works.
</inputs>

<preflight>
Before writing artifacts or creating tasks:
1. Verify bd availability:
   - Run `bd status --json` or `bd where --json`.
   - If bd is missing or no database exists, halt and emit exact setup commands
     such as `bd init --non-interactive --prefix <project>`.
2. Verify code-review-graph availability if the project expects graph-first
   exploration:
   - Prefer the available code-review-graph MCP tools.
   - If code-review-graph is missing and a known project install command exists,
     run that setup before the final AGENTS.md overwrite.
   - If the install command is not known from local context, halt and state that
     the command is unknown instead of guessing.
3. Read `docs/business_analysis.md` and `docs/architecture.md`. If either is
   missing, halt.
</preflight>

<steps>
1. Derive a change name in kebab-case from the idea or architecture title.
2. Create or update `docs/prd.md` from the final Stage A + Stage B results:
   `docs/business_analysis.md` and `docs/architecture.md`. This is the concise
   implementation-facing PRD that downstream bd tasks must reference as their
   primary product source; do not merely mention the path, and do not delete the
   source business analysis.
3. Identify capabilities. A capability is a cohesive execution area from the
   architecture. Typical MVPs need 2-5 capabilities.
4. Derive observable scenarios directly from `docs/prd.md` and
   `docs/architecture.md`:
   - Map every Validation Criterion from `docs/business_analysis.md` §3 to at least
     one scenario.
   - Map every Differentiation claim from §4 to at least one scenario.
   - Keep scenarios in GIVEN/WHEN/THEN/AND form inside each bd task body.
   - Negative scope belongs in out-of-scope guards, not positive feature tasks.
5. Create one bd epic per capability.
6. Create one bd task per executable unit of work:
   - Each task is <= 1 day.
   - Each task has a stable T-### id in its body and title.
   - Each task body uses the template below.
   - Each implementation task references at least one full scenario.
   - Research tasks are allowed only for unresolved discovery questions.
   - Mitigation tasks are required for fatal flaws not fully handled by the
     architecture.
7. Link dependencies in bd. Dependencies must be explicit; do not rely on task
   numbering alone.
8. Create or update `.agents/skills/bd-manual/SKILL.md` in the project folder
   using the template below. This makes the generated project self-contained
   for future agents that only see the repository.
9. Create or update `.agents/skills/crg-manual/SKILL.md` in the project folder
   using the template below. This makes graph-first code exploration
   self-contained for future agents that only see the repository.
10. Create or update `.agents/skills/bd-work/SKILL.md` in the project folder
   using the template below. This makes continuous bd task execution
   self-contained for future agents that only see the repository.
11. Create `task_only_for_reference.md` as a read-only traceability snapshot:
   - Include capability groups, T-###, bd IDs, scenario names, dependencies,
     and acceptance summaries.
   - State clearly at the top: "Reference only. bd is the source of truth for
     task status and execution instructions."
   - Keep the document as a traceability table, not an execution checklist.
12. As the final artifact write, overwrite root `AGENTS.md` with the exact
   AGENTS.md instructions block below:
   - Create `AGENTS.md` if it does not exist.
   - Do not append to existing content and do not merge with content inserted
     by `bd init`, code-review-graph setup, or other tooling.
   - This step must run after all setup commands, bd graph creation,
     project-local skill creation, and `task_only_for_reference.md` generation,
     because those tools may write their own AGENTS.md data.
   - The block must explain when to reference `docs/prd.md`,
     `docs/architecture.md`, and `docs/business_analysis.md`.
   - The block must include the exact bd-manual, bd-work, and crg-manual skill
     directives shown in the template.
13. Run a verification pass:
   - `docs/prd.md`, `docs/architecture.md`, and `docs/business_analysis.md`
     exist.
   - Every fatal flaw has a mitigation in `docs/architecture.md` or a bd task.
   - Every specific pain and validation criterion maps to a scenario.
   - Every scenario maps to at least one bd task.
   - Every out-of-scope item is excluded by task guards.
   - Every bd task has allowed files, do-not-touch paths, acceptance criteria,
     verification commands, and out-of-scope guard.
   - `.agents/skills/bd-manual/SKILL.md` exists and points future agents to bd
     as the execution source of truth.
   - `.agents/skills/crg-manual/SKILL.md` exists and points future agents to
     code-review-graph before raw search/read operations.
   - `.agents/skills/bd-work/SKILL.md` exists and points future agents to
     bd-native ready-task execution, verification, closing, committing, and
     synchronization.
   - `AGENTS.md` matches the exact final guidance template and contains
     references to `docs/prd.md`, `docs/architecture.md`,
     `docs/business_analysis.md`, bd-manual, crg-manual, and bd-work.
   - If any check fails, halt and surface the gap.
14. Emit bd ingestion summary and next command: `bd ready --json`.
</steps>

<prd_doc_template>
# PRD: {product_or_change_name}

## Source Documents
- Business analysis: docs/business_analysis.md
- Architecture: docs/architecture.md

## Problem
- Target customer: {specific customer}
- Specific pain: {specific pain from business analysis}
- Current behavior to displace: {real enemy/current behavior}

## MVP Goal
- {single measurable product outcome}

## Requirements
| ID | Requirement | Source | Acceptance Signal |
| --- | --- | --- | --- |
| PRD-001 | ... | Business §3 / Architecture §... | ... |

## Scenarios
- Scenario: {title}
  - GIVEN {precondition}
  - WHEN {trigger}
  - THEN {observable outcome}

## Out of Scope
- {anti-scope from business analysis and architecture}

## Risks and Mitigations
| Risk | Source Fatal Flaw | Mitigation |
| --- | --- | --- |
| ... | ... | ... |
</prd_doc_template>

<bd_epic_rules>
- One epic per capability.
- Epic title: `{change-name}: {capability-name}`.
- Labels: `ideator`, `change:{change-name}`, `capability:{capability-name}`.
- Epic body includes:
  - Capability purpose.
  - PRD refs.
  - Architecture refs.
  - Scenarios covered by child tasks.
</bd_epic_rules>

<bd_task_body_template>
# T-### {imperative task title}

Beads:
- ID: pending
- Type: feature|task|bug|chore
- Priority: 0|1|2|3|4
- Estimate: {minutes}
- Labels: ideator, change:{change-name}, capability:{capability-name}

Depends on:
- none|T-### ({reason})

Goal:
- {one sentence outcome}

Context:
- PRD refs:
  - {docs/prd.md requirement id}
  - {docs/business_analysis.md section or stable quote label, when relevant}
- Architecture refs:
  - {docs/architecture.md section or stable quote label}
- Decisions already made:
  - {specific decisions; do not leave major choices open}

Scenarios:
- Scenario: {exact scenario title}
  - GIVEN {precondition}
  - WHEN {observable trigger}
  - THEN {observable outcome}
  - AND {additional assertion, if needed}

Read first:
- {local files the worker needs}

Allowed files:
- {paths this worker may edit}

Do not touch:
- {paths this worker must not edit}

Implementation notes:
- {specific implementation guidance}

Acceptance:
- {observable completion criterion}
- Scenario "{exact scenario title}" passes.

Verification commands:
- {command}
- {command}

Out-of-scope guard:
- {specific excluded behavior}
</bd_task_body_template>

<reference_doc_template>
# Task Graph Reference: {change-name}

Reference only. bd is the source of truth for task status and execution
instructions. Do not update this file during task execution.

## Traceability Matrix

| PRD Ref | Architecture Ref | Scenario | T-ID | bd ID | Capability |
| --- | --- | --- | --- | --- | --- |
| §3 Pain "X" | §4 Component "Y" | Scenario A | T-004 | project-12 | capability |

## Capability: {capability-name}

| T-ID | bd ID | Title | Depends on | Acceptance summary |
| --- | --- | --- | --- | --- |
| T-001 | project-1 | ... | none | ... |
</reference_doc_template>

<agents_md_final_template>
## Ideator Project Context

- Reference `docs/prd.md` for product requirements, MVP scope, acceptance
  signals, and scenario definitions before implementing feature work.
- Reference `docs/architecture.md` for approved technical design, component
  boundaries, data flow, error handling, and testing strategy before changing
  implementation structure.
- Reference `docs/business_analysis.md` for customer pain, validation criteria,
  fatal flaws, differentiation, and out-of-scope constraints when product scope
  is unclear.
- Use `task_only_for_reference.md` only as a traceability snapshot. bd is the
  source of truth for task status and execution instructions.
* Use the `bd-manual` skill for bd issue tracking and session completion workflow.
* Use the `bd-work` skill when you want an agent to continuously select ready bd work, claim it, implement it, verify it, close it, commit it, and synchronize.
* Use the `crg-manual` skill for code-review-graph MCP usage. Always try code-review-graph before Grep/Glob/Read when exploring code, reviewing changes, tracing dependencies, checking impact, or finding tests.
</agents_md_final_template>

<project_bd_manual_skill_template>
---
name: bd-manual
description: Use bd(Beads) for project-local task tracking and execution. Trigger this skill whenever work is selected, claimed, updated, split, blocked, completed, or synchronized.
---

# bd Project Task Manual

bd is the source of truth for executable work in this repository.

## Required Workflow

1. Check ready work:
   - `bd ready --json`

2. Inspect and claim a task:
   - `bd show <id> --json`
   - `bd update <id> --claim --json`

3. Track discovered work in bd:
   - `bd create "<title>" --type bug|feature|task|chore --priority 0-4 --json`
   - If the work was discovered while doing another task, link it with
     `--deps discovered-from:<parent-id>` when supported.

4. Complete work:
   - `bd close <id> --reason "Completed" --json`

5. Synchronize at session end:
   - `git pull --rebase`
   - `bd dolt push`
   - `git push`
   - `git status`

## Rules

- Use `--json` for bd commands.
- Keep task status only in bd.
- Do not use external issue trackers for project execution.
- Do not maintain separate task checklists as execution state.
- Keep bd commands sequential; embedded bd/Dolt can lock on concurrent writers.
- Do not end a session with completed work only stored locally.

## Priorities

- `0` Critical: security, data loss, build failure.
- `1` High: major feature or important bug.
- `2` Medium: normal planned work.
- `3` Low: polish or optimization.
- `4` Backlog: future idea.

## Issue Types

- `bug`: broken behavior.
- `feature`: user-facing or product capability.
- `task`: tests, docs, refactors, research, validation.
- `epic`: parent issue for a capability or milestone.
- `chore`: maintenance, tooling, dependency work.
</project_bd_manual_skill_template>

<project_bd_work_skill_template>
---
name: bd-work
description: Automatically work through project-local bd ready tasks by dependency order. Use when an agent should continuously select, claim, implement, verify, close, commit, and synchronize bd tasks without manual task selection.
---

# bd Project Work Runner

Work through executable bd tasks one at a time. bd is the source of truth.

## Required Skills

Load these project-local skills first when available:

1. `bd-manual` for bd commands, priorities, dependencies, and synchronization.
2. `crg-manual` for graph-first repository exploration.

If a skill is missing, use the equivalent instructions in root `AGENTS.md`.

## Workflow

1. Check ready work:
   - `bd ready --json`

2. Select the highest-priority ready task:
   - Priority order is `0`, `1`, `2`, `3`, `4`.
   - Skip tasks with open blocking dependencies.

3. Inspect and claim:
   - `bd show <id> --json`
   - `bd update <id> --claim --json`

4. Explore before editing:
   - Use code-review-graph MCP tools first when available.
   - Read the task's `Read first`, `Allowed files`, `Do not touch`,
     scenarios, acceptance criteria, and verification commands.

5. Implement only the claimed task:
   - Stay inside allowed files unless the task body explicitly permits more.
   - Create discovered work in bd instead of expanding scope silently.
   - Link discovered work with `--deps discovered-from:<parent-id>` when
     supported.

6. Verify:
   - Run the task's verification commands.
   - Run `scripts/verify.sh` if it exists.

7. Close and commit only after verification passes:
   - `bd close <id> --reason "Completed" --json`
   - Commit code and bd state with a message explaining the problem, approach,
     and completed task ID.

8. Synchronize at session end:
   - `git pull --rebase`
   - `bd dolt push`
   - `git push`
   - `git status`

## Rules

- Keep bd/Dolt write commands sequential.
- Do not edit `task_only_for_reference.md` during execution.
- Do not maintain markdown task state outside bd.
- Do not close tasks without verification evidence.
- Do not revert unrelated user changes.
</project_bd_work_skill_template>

<project_crg_manual_skill_template>
---
name: crg-manual
description: Use this skill whenever working in a repository that provides code-review-graph MCP tools, especially before exploring code, reviewing changes, tracing dependencies, checking impact radius, or looking for tests. Prefer code-review-graph before Grep/Glob/Read when the project asks for graph-first code exploration.
---

# code-review-graph Project Manual

Use code-review-graph MCP tools first for code exploration, change review,
impact analysis, dependency tracing, and test discovery. Fall back to `rg` and
manual file reads only when the graph is unavailable, empty, stale, or missing
the needed detail.

## First Tool by Situation

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

## Required Workflow

1. Start with `get_minimal_context` for the current task.
2. For reviews, run `detect_changes` before reading changed files manually.
3. For impact checks, run `get_impact_radius` and `get_affected_flows`.
4. For tests, use `query_graph` with the `tests_for` pattern before raw search.
5. If graph tools fail or return no useful data, state the fallback briefly and
   use `rg`, file reads, or other local inspection as needed.

## Rules

- Prefer graph results before Grep/Glob/Read for repository exploration.
- Keep graph queries focused on the current task.
- Do not treat graph output as authoritative when it is empty or stale; verify
  with local files when needed.
</project_crg_manual_skill_template>

<rules>
- bd is the only execution source of truth.
- Never tell execution agents to edit `task_only_for_reference.md`.
- Never store task status outside bd.
- Use `bd ready --json`, `bd show <id> --json`,
  `bd update <id> --claim --json`, and
  `bd close <id> --reason "Completed" --json` for execution workflow.
- Create `.agents/skills/bd-manual/SKILL.md` during Stage C so the project
  carries its own bd workflow instructions.
- Create `.agents/skills/crg-manual/SKILL.md` during Stage C so the project
  carries its own code-review-graph workflow instructions.
- Create `.agents/skills/bd-work/SKILL.md` during Stage C so the project
  carries its own continuous bd execution workflow instructions.
- Create or update `docs/prd.md` during Stage C. Keep `docs/business_analysis.md`
  and `docs/architecture.md` in `docs/`.
- Overwrite root `AGENTS.md` as the final Stage C artifact so future agents know
  when to reference PRD, architecture, business analysis, bd-manual,
  crg-manual, and bd-work, and so setup-tool AGENTS.md additions are removed.
- Keep bd commands sequential. Embedded bd/Dolt can lock on parallel writers.
- Use `bd dolt commit` and `bd dolt push` after mutating task graph state.
- Root-level DESIGN.md is reserved for visual/UI/brand rules. Never read or
  write it.
</rules>

<output>
Report:
- Change name.
- `docs/prd.md` path.
- bd epics created.
- bd tasks created.
- Dependencies linked.
- `.agents/skills/bd-manual/SKILL.md` path.
- `.agents/skills/crg-manual/SKILL.md` path.
- `.agents/skills/bd-work/SKILL.md` path.
- `AGENTS.md` overwrite status.
- `task_only_for_reference.md` path.
- Verification gaps, if any.

Final line: "Stage C complete. Run `bd ready --json` to begin execution."
</output>
