---
name: tdd
description: Build a ticket test-first — red → green → refactor, one vertical slice at a time. Use when implementing a feature or fixing a bug, before writing implementation code.
---

# tdd

The **inner build loop**: write the failing test first, make it pass, then clean up. The test is the
spec the agent can't argue with — an objective, rule-based gate to grind toward instead of grading
its own work by vibes. This is **validation-first** made mechanical; pair it with `/code-review`
(which owns the heavy refactor) and `/evals` (the outer regression net a green test graduates into).

> Prerequisite: the testing strategy is already defined (from the plan/spec). If it isn't, stop and
> define *how you'll validate* before touching code — that's the load-bearing decision.

## The loop (one slice at a time)

1. **Red** — write **one** test for the next thin behavior (a [vertical slice], not a whole layer).
   Run it. **Confirm it fails for the right reason** — an assertion failure, not an import/typo
   error. A test that errors out proves nothing.
2. **Green** — write the **minimum** code to pass that test. Run the **whole** suite; nothing else
   may break. Resist building beyond the current test.
3. **Refactor** — with the suite green, improve names/structure. Keep refactoring *small* here; hand
   structural smells to `/code-review` so the implement step stays focused on one slice.
4. **Repeat** for the next slice. Commit at green (one logical slice per commit).

## Non-negotiables (leading words)

- **Red before green** — never write the implementation first. A test written against code that
  already works just locks in whatever the code happens to do, bugs included.
- **Test behavior, not implementation** — assert on observable outcomes (return values, state,
  effects), not private internals. Tests written to the spec survive refactors; tests retrofitted to
  the code break on every change. (See `.claude/rules/coding-standards.md`.)
- **One slice at a time** — one failing test → pass → next. Don't batch ten tests then implement.
- **Receipts, not vibes** — paste the failing run *and* the passing run. "Looks right" is not a
  verification strategy. Grade **outcomes, not paths**.
- **Maker ≠ checker** — the agent that wrote the code doesn't get to declare the suite green on its
  own judgement; the suite (and later Codex / `/code-review`) is the independent checker.

## Edge-case discipline (before you start a feature)

Sweep the input space so your red tests actually cover it: **empty / one / many**, **invalid /
boundary**, **concurrency**, **state transitions**, **failure paths**, **access control**. Each
non-trivial case is its own red test. (This is `decompose-requirements` applied at the test level.)

## When NOT to force TDD

Exploratory spikes / throwaway prototypes where the design is still unknown — spike first, then
delete the spike and rebuild it test-first. Don't test-drive a `prototype/` throwaway.

## Anti-patterns

See `reference/tdd-antipatterns.md` — the vacuous test, testing the mock, the mega-test, and
asserting on implementation detail. Name the smell; the name carries the fix.

## Definition of done for a ticket

- [ ] Every new behavior has a test that was seen to fail first, then pass
- [ ] Whole suite green + typecheck clean (the on-edit `check` hook stays quiet)
- [ ] Failing-then-passing receipts attached
- [ ] Capability tests worth keeping promoted into the `/evals` suite
- [ ] `/code-review` run in fresh context before the PR
