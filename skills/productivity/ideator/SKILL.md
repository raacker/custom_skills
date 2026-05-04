---
name: ideator
description: 4-stage pipeline that takes a raw startup or product idea and walks it through validation → PRD → architecture → bd-executable task graph, with hard gates between stages. Use this skill whenever the user wants to validate, pressure-test, write a PRD for, or turn into actionable specs/tasks a new product, startup, feature, or MVP idea — even if they don't explicitly ask for a "pipeline" or "skill". "write a PRD","from idea to PRD", "pressure test idea", "fatal flaw analysis", "painkiller validation", "build PRD from idea", "create bd tasks". Trigger aggressively whenever a new product concept appears that needs validation, a PRD, architecture, or task generation
---

# ideator

A staged workflow that converts a one-line startup idea into a bd-executable task graph. Four stages, hard gates between them, traceability from PRD to scenario to bd task.

## When this fires

- User has a raw idea or product concept and wants it validated, designed, and turned into actionable specs.
- User mentions any of: pressure-testing an idea, finding fatal flaws, validating a problem, mapping competition, writing a PRD, generating bd tasks, brainstorming architecture for a new product.
- User has already produced `docs/business_analysis.md` or `docs/architecture.md` and wants to continue mid-pipeline.

If the user is asking about visual/UI/brand design rules (root `DESIGN.md` territory), this skill does not apply.

## The four stages

```
[idea + customer]
     │
     ▼
Stage A — Business Analysis        (driver: references/A_business_analyzer.md)
  Combines PG-style pressure test + customer discovery + competition map.
  Output: docs/business_analysis.md
  Gate: §6 Decision must be YES or CONDITIONAL. KILL halts the pipeline.
     │
     ▼
Stage B — Brainstorming Handoff    (driver: references/B_brainstorm_bridge.md)
  Loads §5 Handoff into obra/superpowers brainstorming skill as seeded context.
  Output: docs/architecture.md ("how it works")
  Gate: explicit user approval after the brainstorming skill's spec self-review.
     │
     ▼
Stage C — bd Task Graph Generation (driver: references/C_bd_task_writer.md)
  Inputs: docs/business_analysis.md + docs/architecture.md.
  Preflight: verify `bd` is installed and initialized; verify code-review-graph if the project expects graph-first exploration.
  Output: docs/prd.md + bd epics/tasks/dependencies with full worker-ready bodies + task_only_for_reference.md traceability snapshot + project-local bd/crg/bd-work skills + final AGENTS.md overwrite.
  Gate: every Fatal Flaw mitigated, every Pain mapped to a scenario, every out-of-scope honored, every executable task is bd-ready and worker-ready.
     │
     ▼
Stage D — Execute (bd-native)
  `bd ready --json` selects executable tasks. Agents execute one bd task at a time and close with `bd close`.
```

## How to drive the pipeline

1. **Locate the user in the pipeline first.**
   - No state files? Start at Stage A. Read `references/0_orchestrator.md` for the master flow, then read `references/A_business_analyzer.md` and follow it.
   - `docs/business_analysis.md` exists with §6 = YES/CONDITIONAL? Resume at Stage B with `references/B_brainstorm_bridge.md`.
   - `docs/architecture.md` also exists and brainstorming approval was given? Resume at Stage C with `references/C_bd_task_writer.md`.
   - bd tasks for the change already exist? Stage D — point the user to `bd ready --json`.

2. **Honor the gates.** Each stage's gate is in its driver file. Never silently advance past a gate. Surface the verdict explicitly.

3. **Treat state files as the only inter-stage contract.** Stage B reads only §5 Handoff of `docs/business_analysis.md`, not the whole document. Stage C must synthesize the final implementation-facing PRD at `docs/prd.md` from `docs/business_analysis.md` and `docs/architecture.md`, then use `docs/prd.md` as the primary product requirements source for bd task generation. No implicit context carry.

4. **Naming convention.**
   - `docs/business_analysis.md` — Stage A output, the business validation source.
   - `docs/architecture.md` — Stage B output, the approved "how".
   - `docs/prd.md` — Stage C final implementation-facing PRD synthesized from Stage A and Stage B.
   - `task_only_for_reference.md` — Stage C traceability snapshot only. It is not a task state source.
   - Root `DESIGN.md` (all caps) — RESERVED for visual/UI/brand rules. The pipeline never reads or writes here.

5. **Subsumed prompts.** The original standalone files `1_pressure_test_idea.md`, `2_validate_the_real_problem.md`, `3_map_your_real_competition.md` are now threaded inside Stage A. Do not invoke them separately when this skill is active. Files `4_find_your_first_10_customers.md` and `5_build_your_mvp_in_2_weeks.md` remain as standalone GTM aids that run alongside or after Stage D.

## What lives where

```
ideator/
├── SKILL.md                          (this file — entry point)
├── references/
│   ├── 0_orchestrator.md             (master pipeline rules + gate logic)
│   ├── A_business_analyzer.md        (Stage A driver — PG triple-threat evaluator)
│   ├── B_brainstorm_bridge.md        (Stage B driver — context handoff to brainstorming)
│   └── C_bd_task_writer.md           (Stage C driver — PRD + architecture → bd task graph)
```

## External dependencies

- **obra/superpowers brainstorming skill** — Stage B invokes it. If not installed, Stage B becomes a manual interview using the same 9-step flow.
- **bd (Beads)** — Stage C creates bd epics/tasks/dependencies directly. If bd is unavailable or uninitialized, halt and emit exact setup commands.
- **code-review-graph** — Stage C creates project-local crg usage guidance. If the project expects code-review-graph and it is unavailable, run a known local setup command before the final AGENTS.md overwrite; if the setup command is unknown, halt instead of guessing.

## Embedded bd Workflow

Stage C carries the bd and code-review-graph operating rules instead of
depending on global skills being present. Setup commands such as `bd init` or
code-review-graph installation may add their own AGENTS.md content; Stage C
must overwrite root `AGENTS.md` with the configured project guidance only after
all setup, bd graph creation, local skill creation, and traceability work is
complete.

- Track all executable work in bd.
- Use JSON output for bd commands.
- Start execution with `bd ready --json`.
- Claim work with `bd update <id> --claim --json`.
- Create discovered work with `bd create ... --json` and link it to the parent
  with `--deps discovered-from:<parent-id>` when supported.
- Close completed work with `bd close <id> --reason "Completed" --json`.
- Keep task state only in bd. Reference documents are not execution checklists.
- Use priorities consistently:
  - `0` Critical: security, data loss, build failure.
  - `1` High: major feature or important bug.
  - `2` Medium: normal planned work.
  - `3` Low: polish or optimization.
  - `4` Backlog: future idea.
- Use issue types consistently: `bug`, `feature`, `task`, `epic`, `chore`.
- At the end of a task-generation or execution session, run the sync workflow:
  `git pull --rebase`, `bd dolt push`, `git push`, then `git status`.

Stage C must also create `.agents/skills/crg-manual/SKILL.md` so future agents
prefer code-review-graph MCP tools before raw search when exploring code,
reviewing changes, tracing dependencies, checking impact, or finding tests.

Stage C must also create `.agents/skills/bd-work/SKILL.md` so future agents can
continuously select ready bd work, execute one task at a time, verify, close,
commit, and synchronize without depending on a globally installed skill.

## Starter prompt

When the skill triggers and no state files exist, ask the user exactly:

> "Ready to begin Stage A (Business Analysis)? I need (1) your one-line idea and (2) the target customer."

Wait for both answers before starting Phase 1 of Stage A.

## Why this exists

A raw idea typically dies for one of three reasons: nobody actually has the problem (vitamin not painkiller), an entrenched current behavior beats the new product, or the founder cannot specifically address the fatal flaws. Stage A surfaces all three before any code is written. Stage B then constrains the technical design to only address the validated pain, and Stage C makes that design executable through bd's traceable issue graph. The hard gates exist because skipping ahead is the failure mode — premature implementation is the most common reason early ideas fail.
