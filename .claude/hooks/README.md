# Hooks

Wired in `../settings.json`. Principle (Hook Design): fire the cheapest verification **as early as
possible** and never let a hook gate read-only work or block on false positives.

- **`check.sh`** — PostToolUse on Edit/Write. Runs typecheck/lint for the detected stack, non-fatal,
  fast. Surfaces errors at *write* time instead of at the review gate. Tune the detected commands
  per project.
- **`session-context.sh`** — SessionStart. Loads the memory **index** (decisions + facts bullets)
  into context — pointers, not bodies.

## Notes

- Commands assume a **POSIX shell** (git bash on Windows). If your Claude Code runs hooks via
  PowerShell/cmd, port these to `.ps1` and update `settings.json`.
- Keep hooks fast; they run often. If `check.sh` gets slow, scope it to the edited file's language.
- Add a permission gate to `settings.json` (not a hook) when `/retro` flags a dangerous command.
