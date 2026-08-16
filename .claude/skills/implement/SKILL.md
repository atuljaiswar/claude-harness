---
name: implement
description: Implement the work described in a plan or ticket. Use in a fresh conversation with the plan as the only context.
---

# implement

Implement the work described by the user in the plan/ticket. Use **TDD** where possible at
pre-agreed seams. Run **type checking regularly** and single test files regularly; run the full
suite once at the end. Then use `/code-review` to review the work, and commit to the current branch.

- **Red before green**, one vertical slice at a time. Refactoring is not part of the loop — it
  happens in `/code-review`, so implementation isn't overloaded.
- Follow the plan's **validation strategy**; the work is done when those checks pass, not when it
  "looks right". Attach the receipts (test output).
- If the plan has a **performance budget**, it's an exit criterion: run `/benchmark` and confirm
  p95/throughput/error-rate meet the NFR targets before calling the ticket done.
