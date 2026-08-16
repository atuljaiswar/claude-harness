#!/usr/bin/env bash
# SessionStart — assemble a small slice of durable memory into the window.
# Context Assembly lesson: the model only acts on what reaches the context window; load the
# memory *index* (pointers), not bodies. Keep this output short — it's paid on every session start.
set -uo pipefail

echo "=== Project memory (index — read the file for detail) ==="
[ -f ".claude/memory/decisions.md" ] && { echo "## Settled decisions"; grep -E "^- " .claude/memory/decisions.md 2>/dev/null | head -20; }
[ -f ".claude/memory/facts.md" ] && { echo "## Standing facts"; grep -E "^- " .claude/memory/facts.md 2>/dev/null | head -20; }
echo "(Semantic memory: .claude/memory/facts.md + decisions.md · Episodic: .claude/memory/sessions/)"
exit 0
