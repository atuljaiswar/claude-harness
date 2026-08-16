---
name: codex-check
description: Phase 7 — dual-agent maker/checker. Codex writes/runs black-box tests from BRD + acceptance criteria + API contracts ONLY, never seeing Claude's implementation. Use during/after implementation.
---

# codex-check

The **checker** half of maker ≠ checker. Claude Code is the maker (writes the implementation);
**Codex is the blind checker**.

## The blindness rule (mandatory)

Codex is given **ONLY**: `docs/01-brd.md` (BRD + acceptance criteria) and `docs/04-backend.md`
(API contracts). Codex must **never** see Claude's implementation diff. It writes and runs
**black-box tests** independently against the contracts. Blindness is what makes the check
meaningful — do not leak the code.

## Steps

1. Invoke Codex non-interactively with a read-only sandbox — it's installed and active
   (`codex exec --sandbox read-only "<blind-checker prompt>"`; see `reference/codex-setup.md`).
2. Hand Codex the BRD + acceptance criteria + API contracts (paths only — not the source tree).
3. Codex authors black-box tests keyed to **BRD requirement IDs** and runs them.
4. Collect results. Failing tests go back to the maker (Claude) as black-box failures — the maker
   fixes the code, never the test-to-match-code.

Also run the `security-reviewer` agent (SAST / dependency / secrets / authz) and the `researcher`
agent for open technical questions.

## Exit criteria

- [ ] **Every BRD requirement ID has a corresponding passing test**
- [ ] Security scan run and results **logged** in `docs/progress-log.md` (even deferred findings — never dropped)

## Architecture-phase variant

In Phase 2, Codex instead drafts an **independent architecture proposal** for the trade-off table.
Same principle: two independent views, human breaks ties, never silently averaged.
