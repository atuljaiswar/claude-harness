---
name: sdlc
description: Run the full-stack multi-agent SDLC pipeline (Phase 0-9) in order with maker-checker gates. Use to drive a project end-to-end as senior tech lead alongside Codex.
---

# sdlc

You are the senior technical lead orchestrating a full SDLC pipeline alongside **Codex** (a separate
agent) in a dual-agent **maker/checker** workflow. Run the phases **in order**. Do not skip a
phase's exit criteria to move faster.

## Phases (each is its own skill — run them in sequence)

| Phase | Skill | Output |
|---|---|---|
| 0 Setup | `/tooling-survey` + generate stack rules | `.claude/rules/stack/*.md`, `docs/00-tooling-survey.md` |
| 1 BRD | `/brd` | `docs/01-brd.md` + user-journey mermaid |
| 2 Architecture | `/architecture` | `docs/02-architecture.md`, `docs/adr/*.md`, C4 |
| 3 Database | `/db-design` | `docs/03-database.md`, `docs/db-design-checklist.md`, erDiagram |
| 4 Backend | `/backend-design` | `docs/04-backend.md` + sequence diagrams |
| 5 Prototype | `/prototype` | `prototype/index.html` (throwaway) |
| 6 NFR | `/nfr` | `docs/non-functional-requirements.md` |
| 7 Build | `/plan` → `/implement` + `/codex-check` + `/benchmark` + security/researcher agents | code + tests + perf baseline |
| 8 PR gate | `/pr-gate` | PR, reviewed, human-approved |
| 9 Deploy | `/deploy` | `status: planned` (inactive) |

Phase 5 prototype starts **right after Phase 1** and runs in parallel with 2-4 (visible progress).

## Cross-cutting rules (enforce on every phase)

1. **Maker ≠ checker.** The agent that did a phase's work may **not** mark its own exit criteria
   complete. A phase is done only when its checklist is satisfied *and logged* in
   `docs/progress-log.md` (by a different agent or the human).
2. **Version + timestamp** every phase output — `docs/` is the living SDLC record.
3. **Disagreements** between Claude and Codex escalate via the Phase 2 **trade-off table** to the
   human — never silently pick a side.
4. **Diagrams** are stored as **mermaid source** in their docs file (flowchart, C4, ER, sequence).

Before starting, confirm the stack and that `docs/`, `docs/adr/`, `prototype/` exist. Keep
`docs/progress-log.md` current: one dated line per completed, checker-verified phase.

> This is the heavyweight pipeline. For small changes, use the modular skills directly
> (`/grill` → `/to-spec` → `/to-tickets` → `/plan` → `/implement`) without the full gate ceremony.
