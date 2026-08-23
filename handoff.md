# Handoff — claude-harness

Where we are, so the next session continues from here. Newest section on top.

---

## 2026-08-23 — prototype LOGIC branch + Playwright doc fixes

**Branch:** `improve/prototype-logic-and-playwright-docs` (commit `6fb5e4b`) — **NOT merged to
`master`, NOT pushed.** Review, then merge/push.

**What was done (5 files):**

*Requirements robustness — from [Matt Pocock's `prototype` skill](https://github.com/mattpocock/skills/blob/main/skills/engineering/prototype/SKILL.md):*
- `.claude/skills/prototype/SKILL.md` — now forks on **"the question decides the shape."** Added a
  drivable **LOGIC branch** (a self-contained HTML demo the user *clicks through* to validate a
  state / access / data model, logic isolated in a portable module, full state surfaced after every
  action) alongside the existing **UI / visible-progress branch**. Added the 6 shared rules.
- `.claude/skills/grill/SKILL.md` — added an **escalation rule**: when a decision survives grilling
  but is high-risk (non-trivial state machine, contested/multi-role access model, concurrency, or a
  hedging user), escalate from a text list to a `/prototype` LOGIC demo before building.
- `.claude/skills/brd/SKILL.md` — same escalation wired into step 1; fold the prototype verdict back
  into the BRD against its requirement ID.
- Rationale: directly attacks the "assumptions confirmed in words but wrong in reality" failure —
  the Covenx "assumed 5 roles, real model was 2" class of rework.

*Playwright docs — from the tdd-e2e-demo experience report (2026-08-22):*
- `.claude/rules/stack/playwright.md` + `.claude/skills/tdd/reference/playwright-e2e.md` — two
  field-verified `webServer` gotchas: (1) use an uncommon port on `127.0.0.1` (a `:3000` `EADDRINUSE`
  is a *wrong-reason* red, not a valid failure); (2) a reachable base page must return 2xx before the
  first meaningful red (no `index.html` → server 404s → Playwright times out before the test runs).

**Pending / next up:**
1. **Merge + push** `improve/prototype-logic-and-playwright-docs` once reviewed.
2. **Next E2E probe (from the experience report):** run the `/tdd` loop from a Claude Code session
   started *inside* a target repo so the test-first gate blocks a live Claude (it only loads
   per-project at session start); add a second slice ("empty input adds nothing") for multi-slice
   red→green. Consider graduating the kept E2E into an `/evals` CI run.
3. **Try the new LOGIC prototype** on the next real feature with a contested access/state model.

---

## 2026-08-22 — broaden-TDD (E2E arm + test-first gate) — DONE + validated

Merged to `master` (`540b10f`). `/tdd` spans unit + Playwright E2E under `testing-doctrine`; blocking
PreToolUse `test-first-gate.sh` (red-receipt in `.claude/state/`, fails open, `TDD_BYPASS=1` escape);
non-blind test-first audit in `/codex-check`; `/test-optimize` for suite hygiene. Design spec at
`docs/specs/2026-08-21-broaden-tdd-e2e-design.md`.

**Validated live 2026-08-23** on a throwaway demo (`../tdd-e2e-demo`, `ffe307e`): real Chromium drove
a Todo flow test-first red→green in ~1.9s; gate blocked impl-without-a-red across all 4 scenarios.
Write-up ingested into the vault as `[[TDD E2E First Live Run Experience Report]]`.
