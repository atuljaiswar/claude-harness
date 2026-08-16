---
name: pr-gate
description: Phase 8 — raise a PR, run code + security review alongside Codex test results, and require explicit senior approval before merge. Use after implementation + codex-check.
---

# pr-gate

Gate the change into the codebase. **No auto-merge.**

## Steps

1. Raise a PR for the change (`gh pr create`). One PR per logical commit/ticket.
2. Run the **`code-reviewer`** agent — quality + adherence to `.claude/rules/*.md` + architecture
   conformance. This works **alongside** Codex's Phase 7 test results, not instead of them.
3. Run the **`security-reviewer`** agent if not already run this cycle.
4. Attach receipts to the PR: Codex test results (per BRD ID), review findings, security scan.

## Exit criteria (maker ≠ checker)

- [ ] Code-reviewer + Codex results attached
- [ ] A **senior reviewer** (human, or the `senior-reviewer` agent) has **explicitly approved**
- [ ] **No auto-merge** — merge only after explicit approval
- [ ] Phase logged in `docs/progress-log.md` by someone other than the implementer

Then `/deploy` (currently planned-only) or move to the next ticket.
