---
name: architecture
description: Phase 2 — Claude + Codex each draft an architecture, compare via trade-off table, record ADRs, and produce a C4 diagram. Use after /brd.
---

# architecture

Decide the architecture as a **dual-agent** exercise. Never let one agent silently override the other.

## Steps

1. **Claude** and **Codex** each *independently* draft an architecture proposal covering backend,
   DB, frontend approach, and integration points. (Invoke Codex via `/codex-check` in propose mode,
   or the `codex-checker` agent's sibling flow.)
2. Compare the two in a **trade-off table**: `Performance | Scalability | Dev Speed | Cost | Maintainability`.
3. **Conflict resolution:** if they disagree, do **not** average. Present the trade-off table to the
   human lead for the final call.
4. Every non-trivial decision (DB choice, framework, service boundary, auth strategy) gets an
   **ADR** at `docs/adr/NNN-title.md` — sections: **Context, Options Considered, Decision, Consequences**.
   In **Consequences**, state the **reversibility cost**: how expensive is this to undo, and what
   boundary keeps it reversible? (There are no final decisions — an irrevocable choice wired through
   every file is the expensive kind; keep vendors/frameworks behind an interface.)
   (Mirror the decision into `.claude/memory/decisions.md` so the session-start hook surfaces it.)
5. Write `docs/02-architecture.md` with a **C4 mermaid diagram** (context + container level).

## Exit criteria

- [ ] Trade-off table exists and is **human-approved**
- [ ] Every major decision has an **ADR**
- [ ] No unresolved architecture disagreement remains

Hand off to `/db-design`.
