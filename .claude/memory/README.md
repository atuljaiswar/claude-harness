# Memory layout

Durable state that survives a session. The model only acts on what reaches the context window, so
the session-start hook loads the **index** of this folder, not the bodies — pull detail on demand.
Four memory types (from the Agent Memory research):

- **Semantic** (standing facts/rules) → `facts.md` and `decisions.md` (ADR-style). What's *true*.
- **Episodic** (what happened, with a when) → `sessions/YYYY-MM-DD-*.md`. Time-stamped notes.
- **Procedural** (how work is done) → the `.claude/skills/` folder. Named reusable procedures.
- **Working** (now) → the live context window. Not stored here.

## Forgetting is hygiene, not loss

Old memory may stay, but must not **outrank what's true**. On a conflict, update the current state
and keep the old as history — don't store two contradictory facts as equals. Periodically:
compress old sessions → summaries → facts; retire stale decisions (mark superseded, don't delete).

## Files

- `facts.md` — repo layout, conventions, ID/role mappings, current state. One fact per bullet.
- `decisions.md` — architectural decisions: Context / Options / Decision / Consequences. Append-only;
  mark superseded ones, don't rewrite history.
- `sessions/` — per-session episodic notes (what was tried, what failed, what to resume).
