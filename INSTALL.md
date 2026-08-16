# Install & Setup

A 5-minute setup. Works with **Claude Code** (primary) and optionally **Codex** (for the
maker/checker step). No build step — it's just markdown + a JSON settings file.

## Prerequisites

| Tool | Needed for | Check |
|---|---|---|
| **Claude Code** | Everything | `claude --version` |
| **git** + a POSIX shell (git bash on Windows) | Hooks, install script | `git --version` |
| **node** or **python** | The typecheck/lint hook (auto-detects your stack) | `node -v` / `python --version` |
| **gh** (GitHub CLI) | `/pr-gate` raising PRs | `gh --version` |
| **Codex CLI** *(optional)* | `/codex-check` blind maker/checker | `codex doctor` |

Only Claude Code + git are strictly required. The rest light up features as they're present.

## Install into a project

### Option A — the script (recommended)
```bash
# from the claude-harness folder
./install.sh /path/to/your/project
```
It copies `.claude/` + `CLAUDE.md`, makes hooks executable, and prints next steps. If the project
already has a `CLAUDE.md`, yours is kept and the template is saved as `CLAUDE.harness.md` to merge.

### Option B — manual copy
```bash
cp -r claude-harness/.claude  /path/to/project/.claude
cp    claude-harness/CLAUDE.md /path/to/project/CLAUDE.md
```

### Option C — Windows PowerShell
```powershell
Copy-Item -Recurse "claude-harness\.claude" "C:\path\to\project\.claude"
Copy-Item "claude-harness\CLAUDE.md" "C:\path\to\project\CLAUDE.md"
```

### Option D — just ask your agent
Open the project in Claude Code (or Codex) and say:
> "Install the .claude harness from `C:\Users\AtulJ\Desktop\ATUL\claude-harness` into this repo,
> then generate stack rules for my stack."

## First-run checklist (in the project)

1. **Edit `CLAUDE.md`** → fill the **Project** section: what it is, the stack, and the exact
   run / test / typecheck commands (the hooks use these).
2. In Claude Code, run **`/prime`** to load the codebase.
3. **Generate stack rules** (current best practices per technology) — follow
   `.claude/rules/stack/README.md` (uses Context7). One file per tech, timestamped.
4. Start working: **`/sdlc`** for the full gated pipeline, or the lightweight modular flow
   (`/grill` → `/plan` → `/implement`).

## Verify it's wired

- Skills show up: run `/` and you should see `grill`, `plan`, `implement`, `sdlc`, etc.
- Hook fires: edit a `.ts`/`.py` file — the typecheck/lint hook runs (see `.claude/hooks/check.sh`).
- Codex ready (optional): `codex doctor` reports healthy; then `/codex-check` can run the blind tests.

## Updating the harness later

Re-run `install.sh` (it overwrites `.claude/`, keeps your `CLAUDE.md`). Your per-project files
(`docs/`, `.claude/rules/stack/*.md`, `.claude/memory/*`) are yours — the harness template doesn't
ship them, so they won't be clobbered.
