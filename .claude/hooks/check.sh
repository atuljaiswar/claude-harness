#!/usr/bin/env bash
# PostToolUse check — fire the cheapest verification as early as possible (on edit, not at review).
# Hook Design lesson: earlier firing = cheaper correction. Deterministic, zero-token, non-fatal.
# Auto-detects the stack. Fast checks only — keep it under a couple seconds. Tune per project.
set -uo pipefail

# TypeScript / JS
if [ -f "tsconfig.json" ] && command -v npx >/dev/null 2>&1; then
  npx --no-install tsc --noEmit 2>&1 | tail -20 || true
fi

# Python
if command -v ruff >/dev/null 2>&1 && { [ -f "pyproject.toml" ] || [ -f "ruff.toml" ]; }; then
  ruff check --quiet . 2>&1 | tail -20 || true
fi

# Never block the agent — this hook surfaces signal, it doesn't gate.
exit 0
