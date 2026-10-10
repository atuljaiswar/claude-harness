---
name: test-report
description: Generate a management-facing coverage/regression one-pager from the requirement registry + REQ-tagged tests + the latest test run. Use when someone needs proof that requirements are tested and old features still pass (release sign-off, status to team/management).
---

# test-report

Turns the testing pyramid's raw green/red into a **requirement-level** answer: *how much of what we
promised is tested, and did anything that used to pass break?* It joins three things that already
exist — the [requirement registry](../../../docs/requirements/registry.md), the `[REQ-*]` tags in
test titles, and the latest run results — and writes a one-pager. It **writes no tests and changes
no code**; it only reports. Read `.claude/rules/testing-doctrine.md` § Traceability & reporting first.

> Prerequisite: requirements have REQ-IDs in the registry (seeded at `/to-spec`→`/to-tickets`) and
> tests carry `[REQ-xxx]` title prefixes (written by the normal `/tdd` flow). No tags, no report —
> if coverage is near-zero, the fix is to tag tests, not to touch this skill.

## The loop

1. **Run the suite, capture machine-readable results.** Use the project's own runners with a JSON
   reporter so pass/fail is parseable, not scraped from console text:
   - unit (Vitest): `npx vitest run --reporter=json --outputFile=.claude/state/test-report/unit.json`
   - unit (Jest): `npx jest --json --outputFile=.claude/state/test-report/unit.json`
   - E2E (Playwright-TS): `npx playwright test --reporter=json > .claude/state/test-report/e2e.json`

   Match whatever the repo actually uses — the only requirement is *structured* output with each
   test's **title** and **status**. If a runner can't emit JSON, fall back to its JUnit/XML reporter.

2. **Extract REQ-tags from every test title.** A title may carry several: `[REQ-ENQ-01][REQ-ENQ-03]`.
   Build a map `REQ-ID → [{title, status}]` across both unit and E2E results.

3. **Join against the registry.** Read `docs/requirements/registry.md`. For each **active** row:
   - **Covered** — ≥1 tagged test exists *and* its latest status is passing.
   - **Regression** — ≥1 tagged test exists but at least one is failing.
   - **Gap** — no test carries its ID at all.
   Flag **orphan tags** too: a `[REQ-*]` in a test title with no matching active registry row (stale
   ID, typo, or a deprecated requirement still being tested).

4. **Diff against the last report** for "new since last release". Read the previous
   `docs/reports/test-report.md` if it exists; a requirement whose `Added` version is newer than the
   last report's — or any REQ-ID absent from the previous report — is *new this cycle*.

5. **Write the one-pager** to `docs/reports/test-report.md` (overwrite; git keeps the history, so each
   release's report is one commit). Follow the exact format in
   [`reference/report-format.md`](reference/report-format.md).

6. **Report the headline in chat**: coverage %, pass-rate, regression count, gap count — one line, so
   Atul sees the verdict without opening the file.

## Metrics (definitions — keep these stable)

- **Coverage %** = active requirements *covered* ÷ total active requirements. (A tagged-but-failing
  requirement is **not** covered — it's a regression.)
- **Pass-rate** = passing tests ÷ total tests run. (Test-level, not requirement-level — the two differ
  and the report shows both on purpose.)
- **New since last release** = active requirements whose `Added` version post-dates the previous
  report, or that the previous report didn't list.
- **Regressions caught** = requirements that were covered in the previous report and now have a
  failing tagged test. This is the number management actually cares about.

## Non-negotiables

- **Report reality, never massage it.** A gap is a gap; a regression is a regression. The value of
  this artifact is that it's trusted — one cooked number kills it.
- **Don't invent coverage.** If a requirement has no tagged test, it is a gap even if "obviously" the
  app does it. Coverage means a test asserts it, nothing less.
- **Deterministic join.** Same registry + same run results → same report. The AI formats and
  narrates; the pass/fail and the join are read straight from structured output, never guessed.
- **Read-only on code and tests.** This skill never edits a test to make a number look better. If
  coverage is low, it says so and points at which requirements need `/tdd`.

## When to run it

- **Release sign-off** — before you tell the team/management a release is safe.
- **End of a module** — e.g. after Enquiry's tickets are all green, to show the module is covered.
- **Regression check** — any time you need to prove old features still pass after new work.
- **Not every commit** — `/tdd` + the `check` hook already guard per-edit; this is the periodic,
  stakeholder-facing roll-up, not an inner-loop gate.
