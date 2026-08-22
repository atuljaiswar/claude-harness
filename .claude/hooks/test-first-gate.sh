#!/usr/bin/env bash
# PreToolUse gate — blocks Edit/Write/MultiEdit on implementation files until a red receipt exists.
#
# Hook Design (fail-open stance):
#   A hook bug must NEVER brick the agent. If we cannot parse the tool input or something goes
#   wrong internally, we exit 0 (allow). We only block when we POSITIVELY identify an
#   implementation file that has no red receipt in .claude/state/tdd-red.
#
# Receipt mechanism:
#   /tdd writes `.claude/state/tdd-red` after confirming the test fails for the right reason.
#   It clears the file once the suite goes green. This hook checks for that file's presence.
#   .claude/state/ is gitignored — receipts are ephemeral, never committed.
#
# Bypass:
#   Set TDD_BYPASS to any non-empty value to skip the gate for legitimate non-TDD edits
#   (config changes, docs, emergency hotfixes, throwaway spikes).
#
# Exit codes (Claude Code PreToolUse contract):
#   exit 0 — allow the edit to proceed
#   exit 2 — block the edit; reason printed to stderr
set -uo pipefail

# ---------------------------------------------------------------------------
# 1. Extract file_path from the JSON payload on stdin.
#    Claude Code sends: {"tool_name":..., "tool_input":{"file_path":...}}
#    Prefer jq (precise); fall back to grep+sed on raw JSON (portable).
# ---------------------------------------------------------------------------
INPUT="$(cat)"

if command -v jq >/dev/null 2>&1; then
  FILE_PATH="$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null || true)"
else
  # Fallback: pull the first "file_path":"<value>" from the raw JSON string.
  FILE_PATH="$(printf '%s' "$INPUT" | grep -oE '"file_path"\s*:\s*"[^"]*"' | head -1 | sed 's/.*"file_path"\s*:\s*"\([^"]*\)".*/\1/' || true)"
fi

# Fail open: if we could not extract a path, allow and exit.
if [ -z "${FILE_PATH:-}" ]; then
  exit 0
fi

# ---------------------------------------------------------------------------
# 2. TDD_BYPASS: allow immediately if the variable is set to any non-empty value.
# ---------------------------------------------------------------------------
if [ -n "${TDD_BYPASS:-}" ]; then
  exit 0
fi

# ---------------------------------------------------------------------------
# 3. Test-file classifier — allow test files unconditionally.
#    Patterns (POSIX ERE):
#      - path contains a test/spec directory segment
#      - basename ends with .test.ext, _test.ext, .spec.ext, _spec.ext
#      - basename starts with test_
# ---------------------------------------------------------------------------
BASENAME="$(basename "$FILE_PATH")"
DIRPART="$(dirname "$FILE_PATH")"

# Directory-segment match: (^|/)tests?(/|$), __tests__, specs?
if printf '%s' "$DIRPART" | grep -qE '(^|/)(tests?|__tests__|specs?)(/|$)'; then
  exit 0
fi

# Basename match: .test. or _test. or .spec. or _spec. before the final extension
if printf '%s' "$BASENAME" | grep -qE '(\.|_)(test|spec)\.'; then
  exit 0
fi

# Basename starts with test_
if printf '%s' "$BASENAME" | grep -qE '^test_'; then
  exit 0
fi

# ---------------------------------------------------------------------------
# 4. Exempt-path classifier — allow non-implementation assets.
#    - Extensions: md, json, jsonc, yaml, yml, toml, lock, txt, cfg, ini, env
#    - Paths under: .claude/, docs/, prototype/, spike/
#    - Dotfiles (basename starts with .)
# ---------------------------------------------------------------------------
EXT="${BASENAME##*.}"

if printf '%s' "$EXT" | grep -qE '^(md|json|jsonc|ya?ml|toml|lock|txt|cfg|ini|env)$'; then
  exit 0
fi

if printf '%s' "$FILE_PATH" | grep -qE '^(\.claude/|docs/|prototype/|spike/)'; then
  exit 0
fi
# Also catch paths with an absolute prefix or leading slash variants
if printf '%s' "$FILE_PATH" | grep -qE '/(\.claude|docs|prototype|spike)/'; then
  exit 0
fi

# Dotfiles: basename starts with .
if printf '%s' "$BASENAME" | grep -qE '^\.' ; then
  exit 0
fi

# ---------------------------------------------------------------------------
# 5. Implementation file — check for the red receipt.
#    If .claude/state/tdd-red exists, the /tdd skill has confirmed a failing test;
#    allow the edit. Otherwise block with exit 2.
# ---------------------------------------------------------------------------
if [ -f ".claude/state/tdd-red" ]; then
  exit 0
fi

# Block: print reason to stderr, exit 2.
printf 'Test-first gate: no failing test on record for this change. Write a failing test first (run /tdd) — it records the red receipt. Legit non-TDD edit? Re-run with TDD_BYPASS=1.\n' >&2
exit 2
