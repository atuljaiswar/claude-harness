#!/usr/bin/env bash
# Install the claude-harness into a project. Run from the harness folder:
#   ./install.sh /path/to/your/project
# Or with no argument, it installs into the current directory.
set -euo pipefail

HARNESS_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="${1:-$(pwd)}"

if [ ! -d "$TARGET" ]; then echo "Target '$TARGET' is not a directory"; exit 1; fi
if [ "$TARGET" = "$HARNESS_DIR" ]; then echo "Pick a target project, not the harness folder itself."; exit 1; fi

echo "Installing claude-harness into: $TARGET"

# 1. Copy the .claude folder (skills, agents, hooks, rules, memory, settings)
cp -r "$HARNESS_DIR/.claude" "$TARGET/.claude"

# 2. Copy the CLAUDE.md template only if the project doesn't already have one
if [ -f "$TARGET/CLAUDE.md" ]; then
  cp "$HARNESS_DIR/CLAUDE.md" "$TARGET/CLAUDE.harness.md"
  echo "  (existing CLAUDE.md kept; template saved as CLAUDE.harness.md — merge by hand)"
else
  cp "$HARNESS_DIR/CLAUDE.md" "$TARGET/CLAUDE.md"
fi

# 3. Make hooks executable
chmod +x "$TARGET/.claude/hooks/"*.sh 2>/dev/null || true

echo ""
echo "Done. Next steps:"
echo "  1. Edit $TARGET/CLAUDE.md — fill in the Project section (stack, run/test/typecheck commands)."
echo "  2. Open the project in Claude Code and run: /prime"
echo "  3. Generate stack rules (Context7) per the procedure in .claude/rules/stack/README.md"
echo "  4. Start: /sdlc (full pipeline) or /grill -> /plan -> /implement (lightweight)."
echo "  5. (Optional) Codex maker/checker: run 'codex doctor' to confirm it's ready."
