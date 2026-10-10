---
name: test-report
description: One command that does the whole verification run — seeds reproducible test data, runs the FULL suite live in a visible browser (Playwright headed/UI so you watch it click through), re-runs every old test to prove new work broke nothing, and writes a management coverage/regression one-pager. Use whenever you want to see the app tested live and get proof that requirements are covered and old features still pass.
---

# test-report

The **single front door** for verification. You run one thing; it gives you everything:

1. **Test data** — seeds reproducible, inspectable data so every run starts from the same known state.
2. **Live browser** — runs the full Playwright suite **headed** (browsers open on screen, you watch
   each test click through the app) — not invisible/headless.
3. **Regression proof** — it runs the **whole** suite, so every *old* test re-runs in front of you;
   anything the new feature broke is caught and named.
4. **The paper** — a management one-pager: coverage %, pass-rate, new-since-release, regressions caught.

It does not write tests (that's `/tdd`) — it **runs and proves**. One invocation, four outcomes above.
Read `.claude/rules/testing-doctrine.md` § Traceability & reporting first.

> Prerequisite: tests exist and carry `[REQ-xxx]` title tags (written by `/tdd`), requirements are in
> `docs/requirements/registry.md`, and the project exposes a **test-seed step** (see step 1). If there
> are no tagged tests yet, there is nothing to run — build a slice with `/tdd` first.

## The run (one pass, top to bottom)

### 1. Seed reproducible test data
Reset the test database to a known, version-controlled seed so the run is repeatable and you can see
exactly what data each test used. The project exposes this as **`npm run seed:test`** (convention),
backed by committed fixtures under **`tests/seed/<module>.json`** (or a Playwright `globalSetup` that
loads them). The skill runs the seed step first, then reports the seeded rows in the one-pager's
"Test data" section so the data is never a mystery. If a project has no seed step yet, scaffold one
from `reference/test-data-seed.md` before the first run.

### 2. Run the FULL suite — live, in a visible browser
Run everything (old + new), headed, with a JSON reporter so results are both **watchable** and
**parseable**:

```bash
# unit — fast, captured for the report
npx vitest run --reporter=json --outputFile=.claude/state/test-report/unit.json

# E2E — VISIBLE browser, you watch every test click through; JSON captured too
npx playwright test --headed --reporter=json > .claude/state/test-report/e2e.json
#   • prefer `--ui` for an interactive panel (time-travel, re-run a single test, pause)
#   • add `--trace on` so every step is replayable afterwards via `npx playwright show-trace`
#   • use `--workers=1` so tests open one at a time and are easy to follow by eye
```

Match whatever runners the repo actually uses; the only requirement is structured output with each
test's **title** and **status**. Because this runs the *whole* suite, the old tests re-execute on
screen — that *is* the live regression check.

### 3. Join requirements → tests (the traceability)
Extract `[REQ-*]` tags from every test title (a title may carry several: `[REQ-ENQ-01][REQ-ENQ-03]`),
then join against `docs/requirements/registry.md`. For each **active** requirement:
- **Covered** — ≥1 tagged test exists *and* passed.
- **Regression** — ≥1 tagged test exists but is now failing (a feature that used to work).
- **Gap** — no test carries its ID.
Also flag **orphan tags** (a `[REQ-*]` with no matching active row — stale ID or typo).

### 4. Write the one-pager + say the headline
Overwrite `docs/reports/test-report.md` using the exact shape in
[`reference/report-format.md`](reference/report-format.md) — including the **Test data** section from
step 1 and the **Regressions** section up top. Then in chat, one line: coverage %, pass-rate,
regression count, gap count — so the verdict is visible without opening the file.

## Metrics (keep these definitions stable)

- **Coverage %** = active requirements *covered* ÷ total active. (Tagged-but-failing ≠ covered — it's a regression.)
- **Pass-rate** = passing tests ÷ total run (test-level; shown alongside coverage, they differ on purpose).
- **New since last release** = active requirements whose `Added` version post-dates the previous report.
- **Regressions caught** = requirements covered in the previous report that now have a failing tagged test.

## Non-negotiables

- **Live and visible by default.** The E2E run is headed/UI, one worker, so Atul actually watches the
  browser drive the app. A silent headless run defeats the point — headless is only for unattended CI.
- **Reproducible data, shown.** Same seed → same run. The report states what data was seeded; test
  data is never invisible or guessed.
- **Whole suite, every time.** The regression guarantee ("old features still pass") only holds if the
  *full* suite runs — never report on a subset.
- **Report reality, never massage it.** A gap is a gap; a regression is a regression. Read-only on
  code and tests — this skill never edits a test to make a number look better.
- **Deterministic join.** Same registry + same results → same report. The AI formats and narrates;
  pass/fail and the join are read from structured output, never invented.

## When to run it

Release sign-off; end of a module (e.g. after Enquiry's tickets are green — your first real run);
any "did I break old features?" moment. Not per-commit — `/tdd` + the `check` hook already guard
per-edit; this is the periodic, watch-it-live, stakeholder-facing roll-up.
