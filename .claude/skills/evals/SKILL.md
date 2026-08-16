---
name: evals
description: Stand up or extend an outcome-graded eval suite for the project. Use when you want a repeatable regression net or to measure a capability.
---

# evals

Build a small, graded eval suite — the independent evaluator so the agent doesn't grade its own
work by vibes. See `reference/eval-anatomy.md` for the vocabulary.

## Steps

1. **Start small, from real failures** — 20–50 tasks (or 10–20 reference examples). Don't wait for
   hundreds; early changes show large effects.
2. **Write unambiguous tasks** — two people would grade pass/fail identically. Include a passable
   reference solution (proves solvability + validates the grader).
3. **Balanced set** — test presence *and* absence of a behavior; avoid class imbalance.
4. **Choose graders (cheapest that works):** code-based (unit tests / static analysis — the backbone
   for coding tasks) → LLM judge (rubric, **calibrated** against humans) → human (edge/sampling).
5. **Grade outcomes, not paths.** Isolate trials in clean environments (no shared state).
6. **Read transcripts** to confirm the grader is fair and measures what matters.
7. Wire it as **CI**. Capability evals (start low, target weaknesses) **graduate** to regression
   evals (hold ~100%; a drop = breakage).

Pick `pass@k` (one success suffices) vs `pass^k` (all trials must pass — reliability-critical).
Don't select a model by benchmark alone — evaluate on *your* tasks (model vs product evals).
