#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

TARGET="$TMPDIR/project"
mkdir -p "$TARGET"
cd "$TARGET"

printf '\n' | "$REPO/scripts/install-skills.sh" >"$TMPDIR/install-skills-test.out"

grep -q "copied AGENTS_WORKFLOW.md -> $TARGET/AGENTS.md" "$TMPDIR/install-skills-test.out"
test -d "$TARGET/.agents"
test -d "$TARGET/.agents/skills"
test -L "$TARGET/.agents/skills/tdd"
test "$(readlink "$TARGET/.agents/skills/tdd")" = "$REPO/skills/engineering/tdd"
test -f "$TARGET/AGENTS.md"
cmp -s "$REPO/AGENTS_WORKFLOW.md" "$TARGET/AGENTS.md"

printf '\n' | "$REPO/scripts/install-skills.sh" >"$TMPDIR/install-skills-test-rerun.out"

first_size="$(wc -c < "$TARGET/AGENTS.md" | tr -d ' ')"
workflow_size="$(wc -c < "$REPO/AGENTS_WORKFLOW.md" | tr -d ' ')"
test "$first_size" = "$workflow_size"

EXISTING="$TMPDIR/existing-project"
mkdir -p "$EXISTING"
printf 'Existing instructions\n' >"$EXISTING/AGENTS.md"

cd "$TMPDIR"
printf '%s\n' "$EXISTING" | "$REPO/scripts/install-skills.sh" >"$TMPDIR/install-skills-existing.out"

grep -q "appended AGENTS_WORKFLOW.md -> $EXISTING/AGENTS.md" "$TMPDIR/install-skills-existing.out"
test -d "$EXISTING/.agents"
test -d "$EXISTING/.agents/skills"
test -L "$EXISTING/.agents/skills/tdd"
grep -q "Existing instructions" "$EXISTING/AGENTS.md"
tail -c "$workflow_size" "$EXISTING/AGENTS.md" | cmp -s "$REPO/AGENTS_WORKFLOW.md" -

FORCE="$TMPDIR/force-project"
mkdir -p "$FORCE/.agents/skills/stale-dir"
printf 'Stale instructions\n' >"$FORCE/AGENTS.md"
printf 'stale skill\n' >"$FORCE/.agents/skills/stale-file"

cd "$TMPDIR"
printf '%s\n' "$FORCE" | "$REPO/scripts/install-skills.sh" --force >"$TMPDIR/install-skills-force.out"

grep -q "removed $FORCE/.agents/skills" "$TMPDIR/install-skills-force.out"
grep -q "overwrote AGENTS_WORKFLOW.md -> $FORCE/AGENTS.md" "$TMPDIR/install-skills-force.out"
test -d "$FORCE/.agents"
test -d "$FORCE/.agents/skills"
test ! -e "$FORCE/.agents/skills/stale-dir"
test ! -e "$FORCE/.agents/skills/stale-file"
test -L "$FORCE/.agents/skills/tdd"
cmp -s "$REPO/AGENTS_WORKFLOW.md" "$FORCE/AGENTS.md"

echo "install-skills test passed"
