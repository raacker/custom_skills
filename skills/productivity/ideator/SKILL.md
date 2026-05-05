---
name: ideator
description: 4-stage pipeline that takes a raw startup or product idea through validation, a production-MVP PRD, approved architecture, and create-task-backed task creation. Use whenever the user wants to validate, pressure-test, write a PRD for, or turn into actionable specs/tasks a product, startup, feature, or MVP idea, even if they do not explicitly ask for this skill. Trigger on phrases like "write a PRD", "from idea to PRD", "pressure test idea", "fatal flaw analysis", "painkiller validation", "build PRD from idea", or "create tasks".
---

# ideator

A staged workflow that converts a one-line startup idea into a validated production-MVP definition and a task graph created through the `create-task` skill. Four stages, hard gates between them, traceability from business validation to PRD scenario to implementation task.

## When this fires

- User has a raw idea or product concept and wants it validated, designed, and turned into actionable specs.
- User mentions any of: pressure-testing an idea, finding fatal flaws, validating a problem, mapping competition, writing a PRD, generating implementation tasks, brainstorming architecture for a new product.
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
  Use the brainstorming skill with §5 Handoff as seeded context.
  Output: docs/architecture.md ("how it works")
  Gate: explicit user approval after the brainstorming skill's design review.
     │
     ▼
Stage C — PRD + Task Graph Generation (driver: references/C_bd_task_writer.md)
  Inputs: docs/business_analysis.md + docs/architecture.md.
  Output: docs/prd.md + docs/task_only_for_reference.md + create-task ingestion of every listed epic/task.
  Gate: every Fatal Flaw mitigated, every Pain mapped to a scenario, every production-MVP requirement covered, every out-of-scope honored, every task in docs/task_only_for_reference.md created through create-task.
     │
     ▼
Stage D — Execute
  Execute the generated task graph using the repository's task-execution workflow.
```

## How to drive the pipeline

1. **Locate the user in the pipeline first.**
   - No state files? Start at Stage A. Read `references/0_orchestrator.md` for the master flow, then read `references/A_business_analyzer.md` and follow it.
   - `docs/business_analysis.md` exists with §6 = YES/CONDITIONAL? Resume at Stage B with `references/B_brainstorm_bridge.md`.
   - `docs/architecture.md` also exists and brainstorming approval was given? Resume at Stage C with `references/C_bd_task_writer.md`.
   - Tasks for the change already exist? Stage D — follow the repository's execution workflow.

2. **Honor the gates.** Each stage's gate is in its driver file. Never silently advance past a gate. Surface the verdict explicitly.

3. **Treat state files as the only inter-stage contract.** Stage B reads only §5 Handoff of `docs/business_analysis.md`, not the whole document. Stage C must synthesize the final implementation-facing PRD at `docs/prd.md` from `docs/business_analysis.md` and `docs/architecture.md`, then use `docs/prd.md` as the primary product requirements source for task generation. No implicit context carry.

4. **Naming convention.**
   - `docs/business_analysis.md` — Stage A output, the business validation source.
   - `docs/architecture.md` — Stage B output, the approved "how".
   - `docs/prd.md` — Stage C final implementation-facing PRD synthesized from Stage A and Stage B.
   - `docs/task_only_for_reference.md` — Stage C traceability snapshot and create-task ingestion manifest. It is not a task state source.
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
│   └── C_bd_task_writer.md           (Stage C driver — PRD + architecture → task graph manifest + create-task ingestion)
```

## External dependencies

- **brainstorming skill** — Stage B uses it. If not installed, Stage B becomes a manual design interview using the same required architecture output.
- **create-task skill** — Stage C uses it to create every epic/task listed in `docs/task_only_for_reference.md`. Stage C does not embed task-tracker manuals; dedicated task-execution skills own those instructions.

## Starter prompt

When the skill triggers and no state files exist, ask the user exactly:

> "Ready to begin Stage A (Business Analysis)? I need (1) your one-line idea and (2) the target customer."

Wait for both answers before starting Phase 1 of Stage A.

## Why this exists

A raw idea typically dies for one of three reasons: nobody actually has the problem (vitamin not painkiller), an entrenched current behavior beats the new product, or the founder cannot specifically address the fatal flaws. Stage A surfaces all three before any code is written. Stage B turns the validated pain into a production-MVP architecture with explicit operational boundaries. Stage C synthesizes the implementation-facing PRD, produces the task manifest, and delegates tracker creation to `create-task`. The hard gates exist because skipping ahead is the failure mode: premature implementation is the most common reason early ideas fail.
