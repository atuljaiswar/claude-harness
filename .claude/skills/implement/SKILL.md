---
name: implement
description: Implement the work described in a plan or ticket. Use in a fresh conversation with the plan as the only context.
---

# implement

Implement the work described by the user in the plan/ticket. Build it **test-first — run `/tdd`**
(red→green→refactor, one vertical slice at a time; refactoring stays in `/code-review`, not the
loop). Run **type checking regularly** and single test files regularly; run the full suite once at
the end. Then use `/code-review` to review the work, and commit to the current branch.

- Follow the plan's **validation strategy**; the work is done when those checks pass, not when it
  "looks right". Attach the receipts (test output).
- If the plan has a **performance budget**, run `/benchmark` and report the numbers. If they miss
  the NFR targets, **highlight it to the user** (measured vs target p95/throughput/error-rate + the
  likely bottleneck) — do **not** block the ticket; the user decides whether to ship or optimize.
  Correctness tests gate completion; performance is advisory.
