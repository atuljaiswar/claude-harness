# Codex setup (for the maker/checker workflow)

**Status: ACTIVE.** Codex CLI is installed on this machine (`codex-cli 0.147.0`) and authenticated.
`codex-check` can invoke it directly. Verify anytime with `codex --version` or `codex doctor`.

## Invocation — blind checker (Phase 7)

Claude (maker) hands Codex (checker) **only** the contract docs, then runs Codex to author + execute
black-box tests. Blindness is enforced by instruction + a read-only sandbox:

```bash
codex exec --sandbox read-only \
"You are a BLIND black-box checker. Read ONLY docs/01-brd.md and docs/04-backend.md. \
Do NOT open src/ or any implementation files. Write black-box tests keyed to each BRD requirement \
ID and run them against the running system/API. Report pass/fail per requirement ID."
```

- For stronger isolation, copy just the contract docs into a scratch dir and run `codex exec -C <dir>`
  so the implementation isn't even on disk for that run.
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
