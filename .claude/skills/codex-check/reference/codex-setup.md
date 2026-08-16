# Codex setup (for the maker/checker workflow)

**Status: ACTIVE — smoke-tested 2026-08-16.** Codex CLI is installed (`codex-cli 0.147.0`),
authenticated, and verified running a blind black-box check headless (model `gpt-5.6-sol`,
read-only sandbox). Verify anytime with `codex --version` or `codex doctor`.

**Two flags that matter:**
- `--sandbox read-only` — Codex can read but not write (enforces blindness for the check).
- `--skip-git-repo-check` — required only when running **outside** a git repo (e.g. a scratch dir).
  In-repo runs don't need it. Close stdin with `</dev/null` for clean non-interactive output.

## Invocation — blind checker (Phase 7)

Claude (maker) hands Codex (checker) **only** the contract docs, then runs Codex to author + execute
black-box tests. Blindness is enforced by instruction + a read-only sandbox:

```bash
# in-repo (normal): no --skip-git-repo-check needed
codex exec --sandbox read-only </dev/null \
"You are a BLIND black-box checker. Read ONLY docs/01-brd.md and docs/04-backend.md. \
Do NOT open src/ or any implementation files. Write black-box tests keyed to each BRD requirement \
ID and run them against the running system/API. Report pass/fail per requirement ID."
```

- For stronger isolation, copy just the contract docs into a scratch dir and run
  `codex exec -C <dir> --skip-git-repo-check --sandbox read-only </dev/null "..."` so the
  implementation isn't even on disk for that run (this is the exact form that passed the smoke test).
- Failing tests go back to Claude (the maker) as black-box failures — the maker fixes the code,
  never the test.

## Invocation — independent code review (Phase 8, optional)

Codex has a built-in reviewer that complements the `code-reviewer` agent:

```bash
codex review            # interactive
codex exec review       # non-interactive, prints findings
```

## Invocation — architecture proposal (Phase 2)

```bash
codex exec --sandbox read-only \
"Read docs/01-brd.md. Draft an independent architecture proposal (backend, DB, frontend, \
integration points). Do not read any existing architecture doc. Output your proposal only."
```

Claude and Codex proposals go side by side in the trade-off table; the human breaks ties.

## Upgrade path (optional): Codex as an MCP server

`codex mcp-server` runs Codex as an MCP stdio server, so Claude Code can call it as native tools
instead of shelling out. Register it in your MCP config if you'd rather invoke Codex as a tool than
via `codex exec`. The `exec` approach above needs no extra wiring.
