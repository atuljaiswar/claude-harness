---
name: brd
description: Phase 1 — gather requirements into a BRD with unique testable IDs and a user-journey diagram. Use after tooling-survey; wraps /grill.
---

# brd

Grill-down every requirement into a Business Requirements Document.

## Steps

1. Run the `/grill` procedure (relentless, one branch, one question at a time, recommend one, do not
   act, facts-vs-decisions). Use the `requirements-analyst` agent to sweep edge cases. For any
   **high-risk model** the sweep surfaces (contested role/access model, non-trivial state machine,
   concurrency), validate it with a `/prototype` LOGIC demo the user drives — don't confirm it in a
   text list alone. Fold the verdict back into this BRD against its requirement ID.
2. Extract **every** requirement from the source material (transcripts, docs, client notes).
3. Break requirements into: **functional, non-functional, edge cases, out-of-scope** (explicit).
4. Write `docs/01-brd.md`. Add a **mermaid flowchart** of the user journey / core process.

## Exit criteria (all must hold before Phase 2)

- [ ] Every requirement has a **unique ID** (e.g. `FR-01`, `NFR-03`, `EC-02`)
- [ ] Every requirement is **testable** (has a pass/fail condition)
- [ ] Ambiguous requirements are **flagged with a question**, not silently assumed
- [ ] Out-of-scope items are **explicitly listed**

The IDs are load-bearing: Phase 7 requires a passing test per requirement ID. Hand off to
`/architecture`. Start `/prototype` now in parallel.
