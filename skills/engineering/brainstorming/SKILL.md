---
name: brainstorming
description: "You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Use it to explore context, interview the user one question at a time, stress-test decisions, and turn approved work into bd tasks via create-task before implementation."
---

# Brainstorm Ideas Into Executable Work

Turn an idea into a clear, validated design through focused dialogue before any implementation starts.

Use the `grill-me` pattern: interview the user relentlessly, walk each branch of the design tree, resolve dependent decisions one by one, and provide your recommended answer with every question. Ask one question at a time.

<HARD-GATE>
Do NOT write code, scaffold files, change behavior, or invoke any implementation workflow until the design is approved and new implementation work is registered in bd.
</HARD-GATE>

## Required Outcome

End with:

- A concise approved design summary.
- New work registered in bd by using the `create-task` skill.
- Clear implementation boundaries, acceptance criteria, and verification commands captured in the bd task body.





## Process

### 1. Explore Context First

Before asking the user questions, inspect the repository enough to avoid asking questions the code or docs can answer.

- Read `docs/prd.md` for requirements, MVP scope, acceptance signals, and scenarios.
- Read `docs/architecture.md` for component boundaries, data flow, error handling, and test strategy.
- Read `docs/business_analysis.md` when customer pain, validation criteria, differentiation, or out-of-scope constraints matter.
- Inspect existing code paths, patterns, recent changes, and related bd issues when they affect the design.
- If a question can be answered by exploring the codebase, explore the codebase instead.
- State briefly what you learned and what remains unknown.

### 2. Check Scope

Decide whether the request is a single coherent change or multiple independent capabilities.

- If it spans multiple subsystems, decompose it before detailed design.
- Identify the first independently valuable slice.
- Keep the current brainstorming session focused on that slice.
- Create separate bd tasks or epics for distinct implementation units.

### 3. Grill The Design

Ask questions one at a time until the major decisions are resolved.

- Ask the highest-leverage unresolved question first.
- Provide your recommended answer and why it is the default.
- Prefer multiple choice when it reduces ambiguity.
- Use open-ended questions only when the decision space is genuinely unclear.
- Cover purpose, users, constraints, non-goals, success criteria, edge cases, data flow, error handling, testing, and rollout.
- Do not move forward while a blocking decision remains unresolved.

### 4. Propose Approaches

Once enough context is known, present 2-3 viable approaches.

- Lead with the recommended approach.
- Explain trade-offs directly: complexity, risk, user impact, testability, migration cost, and reversibility.
- Reject unnecessary scope. Apply YAGNI aggressively.
- If an approach conflicts with `docs/prd.md` or `docs/architecture.md`, call that out and choose the safer path.

### 5. Present The Design For Approval

Present the design in sections scaled to complexity.

- For small changes, use a short summary.
- For nuanced changes, cover architecture, components, data flow, error handling, testing, rollout, and out-of-scope items.
- Ask for approval before moving to task creation.
- If the user requests changes, revise the design and ask again.

## Task Creation

After approval, use the `create-task` skill to create bd work items. Do not transition into a separate implementation planning workflow.

Follow these rules:

- Use bd as the source of truth for all new work.
- Create one epic per capability when the work has multiple tasks.
- Keep each task independently executable.
- Tie each task to relevant PRD refs, architecture refs, and explicit scenarios.
- Include allowed files, forbidden files, acceptance criteria, verification commands, and an out-of-scope guard.
- If required PRD or architecture details are missing, update or reference `docs/prd.md` or `docs/architecture.md`; do not create a separate spec file.

The terminal state of brainstorming is bd task creation through `create-task`. Implementation starts only after the relevant bd task exists.

## Design Quality Rules

- Keep boundaries small and explicit.
- Prefer existing project patterns unless they directly block the goal.
- Improve nearby structure only when it serves the current change.
- Avoid unrelated refactoring.
- Make error states observable and testable.
- Define verification before implementation starts.
- State "I do not know" when evidence is missing; then gather evidence or ask the next question.

## Key Principles

- One question at a time.
- Explore the codebase before asking answerable questions.
- Recommend a default answer for every question.
- Resolve dependent decisions in order.
- Present alternatives before final design.
- Get explicit approval before bd task creation.
- Register all new work in bd.
- Do not create spec files.
- Do not invoke any implementation planning skill before bd tasks exist.
