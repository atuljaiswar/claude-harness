# Hooks

Wired in `../settings.json`. Principle (Hook Design): fire the cheapest verification **as early as
possible** and never let a hook gate read-only work or block on false positives.

- **`check.sh`** — PostToolUse on Edit/Write. Runs typecheck/lint for the detected stack, non-fatal,
  fast. Surfaces errors at *write* time instead of at the review gate. Tune the detected commands
  per project.
- **`test-first-gate.sh`** — PreToolUse on Edit/Write/MultiEdit. Blocking gate: if the path is an
  implementation file and no red receipt exists at `.claude/state/tdd-red`, the edit is blocked
  (exit 2). Fail-open: parse errors → exit 0, so a hook bug never bricks the agent. Test files and
  exempt paths (docs, config, dotfiles) are always allowed. Set `TDD_BYPASS=1` for legit non-TDD
  edits (config, docs, emergency, spikes). The `/tdd` skill writes the receipt after confirming a
  failing test and clears it once the suite goes green.
- **`session-context.sh`** — SessionStart. Loads the memory **index** (decisions + facts bullets)
  into context — pointers, not bodies.

## Notes

- Commands assume a **POSIX shell** (git bash on Windows). If your Claude Code runs hooks via
  PowerShell/cmd, port these to `.ps1` and update `settings.json`.
- Keep hooks fast; they run often. If `check.sh` gets slow, scope it to the edited file's language.
- Add a permission gate to `settings.json` (not a hook) when `/retro` flags a dangerous command.
