---
name: create-task
description: Create or refine bd(beads) epics and tasks for implementation work. Use when Codex needs to write bead bodies, define capability epics, turn PRD and architecture requirements into executable tasks, or enforce a strict bd task template with dependencies, scenarios, allowed files, verification commands, and scope guards.
---

# Create bd Tasks

Create bd epics and tasks only from repository evidence. Read these first:
- `docs/prd.md`
- `docs/architecture.md`
- `docs/business_analysis.md` when scope, customer pain, or validation criteria matter

## Rules

- Use `bd` as the source of truth.
- Keep one epic per capability.
- Write titles in imperative form.
- Fill every section with concrete content. Do not leave major decisions open.
- Keep scope narrow. Prefer multiple small tasks over one broad task.
- Tie every task to PRD refs, architecture refs, and explicit scenarios.
- State allowed files and forbidden files.
- Include runnable verification commands.
- Add an out-of-scope guard.

## Epic format

Create capability epics with this exact structure:

- Title: `{change-name}: {capability-name}`
- Labels: `ideator`, `change:{change-name}`, `capability:{capability-name}`
- Body must include:
  - Capability purpose
  - PRD refs
  - Architecture refs
  - Scenarios covered by child tasks

## Task format

Write every task body with this template:

```md
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
```

## Output discipline

- If asked for an epic, output the epic only.
- If asked for a task, output the task body only.
- If asked for multiple tasks, keep each task independently executable.
- Do not add generic advice outside the requested bd artifact unless the user asks.
