#!/usr/bin/env bash
set -euo pipefail

# Links all skills in this repository into a local repository's .agents/skills
# directory, then appends AGENTS_WORKFLOW.md to that repository's AGENTS.md.
# With --force, recreates .agents/skills and overwrites AGENTS.md.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
WORKFLOW="$REPO/AGENTS_WORKFLOW.md"
DEFAULT_TARGET="$PWD"
FORCE=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --force)
      FORCE=1
      ;;
    -h|--help)
      echo "usage: $0 [--force]" >&2
      exit 0
      ;;
    *)
      echo "error: unknown option: $1" >&2
      echo "usage: $0 [--force]" >&2
      exit 1
      ;;
  esac
  shift
done

printf "Install skills into which repository? [%s] " "$DEFAULT_TARGET"
IFS= read -r TARGET_ROOT || TARGET_ROOT=""

if [ -z "$TARGET_ROOT" ]; then
  TARGET_ROOT="$DEFAULT_TARGET"
fi

case "$TARGET_ROOT" in
  "~")
    TARGET_ROOT="$HOME"
    ;;
  "~/"*)
    TARGET_ROOT="$HOME/${TARGET_ROOT#~/}"
    ;;
esac

if [ ! -d "$TARGET_ROOT" ]; then
  echo "error: target directory does not exist: $TARGET_ROOT" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$TARGET_ROOT" && pwd)"
AGENTS_DIR="$TARGET_ROOT/.agents"
DEST="$AGENTS_DIR/skills"
AGENTS="$TARGET_ROOT/AGENTS.md"

if [ ! -f "$WORKFLOW" ]; then
  echo "error: missing workflow file: $WORKFLOW" >&2
  exit 1
fi

if [ "$FORCE" -eq 1 ] && [ -e "$DEST" ]; then
  rm -rf "$DEST"
  echo "removed $DEST"
fi

# If .agents/skills is a symlink that resolves into this repo, we'd end up
# writing the per-skill symlinks back into this repo's own skills/ tree.
if [ -L "$DEST" ] && [ -d "$DEST" ]; then
  resolved="$(cd "$DEST" && pwd -P)"
  case "$resolved" in
    "$REPO"|"$REPO"/*)
      echo "error: $DEST is a symlink into this repo ($resolved)." >&2
      echo "Remove it and re-run; the script will recreate it as a real dir." >&2
      exit 1
      ;;
  esac
fi

mkdir -p "$AGENTS_DIR" "$DEST"

find "$REPO/skills" -name SKILL.md -not -path '*/node_modules/*' -print0 |
while IFS= read -r -d '' skill_md; do
  src="$(dirname "$skill_md")"
  name="$(basename "$src")"
  target="$DEST/$name"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    rm -rf "$target"
  fi

  ln -sfn "$src" "$target"
  echo "linked $name -> $src"
done

workflow_size="$(wc -c < "$WORKFLOW" | tr -d ' ')"

if [ "$FORCE" -eq 1 ]; then
  cp "$WORKFLOW" "$AGENTS"
  echo "overwrote AGENTS_WORKFLOW.md -> $AGENTS"
elif [ ! -f "$AGENTS" ]; then
  cp "$WORKFLOW" "$AGENTS"
  echo "copied AGENTS_WORKFLOW.md -> $AGENTS"
elif
  [ "$(wc -c < "$AGENTS" | tr -d ' ')" -ge "$workflow_size" ] &&
  tail -c "$workflow_size" "$AGENTS" | cmp -s "$WORKFLOW" -; then
  echo "AGENTS.md already ends with AGENTS_WORKFLOW.md"
else
  if [ -s "$AGENTS" ]; then
    if [ "$(tail -c 1 "$AGENTS" | wc -l | tr -d ' ')" -eq 0 ]; then
      printf '\n' >>"$AGENTS"
    fi
    printf '\n' >>"$AGENTS"
  fi

  cat "$WORKFLOW" >>"$AGENTS"
  echo "appended AGENTS_WORKFLOW.md -> $AGENTS"
fi
