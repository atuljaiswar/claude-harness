---
name: test-optimize
description: Prune and groom the test suite — use when the suite is slow, has flaky tests, or has grown redundant. Periodic Add/Purge/Merge hygiene pass.
---

# test-optimize

One job: **periodic suite hygiene** so the regression net stays fast and trustworthy — the
methodology's Support box. See [`../../rules/testing-doctrine.md` § The pyramid](../../rules/testing-doctrine.md#the-pyramid)
for where this loop sits.

## Add

Cover gaps: behaviors found unguarded by `/retro` or escaped bugs. Graduate capability tests (unit
or E2E) that proved their value into `/evals` so the regression net grows intentionally.

## Purge

Remove flaky, obsolete, or redundant tests — **each with a stated reason**. Maker ≠ checker: never
silently delete a test that guards real behavior. If unsure, demote to a skipped test with a comment,
not a delete.

## Merge

Consolidate overlapping tests into one clear assertion. Split the mega-journey test into per-behavior
tests sharing setup via fixtures. Kill duplication by merging; kill sprawl by splitting.

**Boundary:** `/evals` *builds* the regression net; `/retro` fixes one escaped failure; this skill
*grooms* the whole suite on a recurring cadence.

**Done when:** suite is green-for-real, runs measurably faster, and has no known flakes.
