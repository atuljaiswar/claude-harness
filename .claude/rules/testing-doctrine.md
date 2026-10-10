# Testing doctrine

The harness already had unit→evals; this doc names the full pyramid and where the browser fits.
Everything here feeds one goal: the agent closes the self-verification loop without human clicking.

## The pyramid

Four layers, each with a single owner:

- **Unit inner loop** — [/tdd]: write one failing test per thin behavior, make it pass, refactor. Fast, isolated, runs on every edit.
- **E2E outer loop** — [/tdd] (Playwright variant): drive the running app like a user for one user-visible behavior. Slower; reserved for flows a unit test can't reach.
- **Regression net** — [/evals]: graded suite that holds capabilities over time. Both unit and E2E capability tests **graduate** here once worth keeping — a kept test proves the behavior stays.
- **Hygiene loop** — [/test-optimize]: periodic Add/Purge/Merge pass so the net stays fast and trustworthy.

Graduation arrow: a capability test (unit or E2E) that the team wants to hold permanently moves into `/evals`; a drop in its grade signals breakage.

## Which level?

Default to unit. Pick the Playwright E2E variant when any of these signals fires:

- **Type of scenario** — the behavior spans multiple UI layers or requires a real browser (navigation, form submission, auth redirect).
- **Existing coverage** — the unit net already covers the logic; what's untested is the wiring through the real stack.
- **Frequency of use** — the flow is a critical path users hit every session; a silent regression would be high-impact.
- **Feasibility** — the behavior cannot be isolated without mocking so much that the test only verifies the mock.
- **Customer-facing priority** — a stakeholder has flagged this flow as must-not-break.
- **Stability** — the UI contract is stable enough that the test won't flake every other sprint.

If none fire, stay at the unit level.

## Grading

Assert **user-visible outcomes**: what text appears, what state changes, what the user can do next. Never assert on DOM class names, element IDs, internal call order, or implementation structure — those break on every refactor while behavior stays unchanged. **Grade outcomes, not paths** is the through-line linking this doc to `coding-standards.md`: the same principle that says "test behavior, not implementation" at the unit level applies at the browser level too.

## Traceability & reporting

The pyramid above proves *tests pass*. This layer proves *which requirement each test covers* — so you can answer "is every requirement tested, and do old features still pass?" with an artifact, not a claim. It is **additive**: it changes nothing about how tests are written or run. It adds one ID, one tag convention, and one report.

**REQ-IDs.** Every requirement gets a stable, human-readable ID — `REQ-<MODULE>-<NN>` (e.g. `REQ-ENQ-01` for the first Enquiry requirement). IDs are **seeded during `/to-spec` → `/to-tickets`** and recorded in `docs/requirements/registry.md` (one row per requirement). An ID is **permanent and append-only**: once `REQ-ENQ-01` exists it is never renumbered or reused, even if the requirement is later deprecated (mark it `deprecated`, don't delete the row). This is what makes "coverage" and "new-since-last-release" meaningful across time — git history + stable IDs do the versioning, so there is no content-hash machinery here.

**Tag convention.** Each test declares the requirement(s) it covers by prefixing its title with the ID in brackets:

- unit (Vitest/Jest): `it('[REQ-ENQ-01] rejects an enquiry with no phone number', …)`
- E2E (Playwright-TS): `test('[REQ-ENQ-01] submits an enquiry and shows it in the list', …)`

One test may carry several tags (`[REQ-ENQ-01][REQ-ENQ-03]`); one requirement may be covered by many tests. Tags are written by the normal `/tdd` flow — **no new test-writing tool**. The bracket prefix is the entire contract: `/test-report` discovers coverage by scanning test titles, so the tag is both documentation and the machine-readable link.

**The report.** `/test-report` reads the registry + the REQ-tags across the suite + the latest run results and emits a management one-pager: **coverage %** (requirements with ≥1 passing test), **pass-rate**, **new-since-last-release**, and **regressions caught**. This is the "prove to the team that old features still pass" artifact — the piece a plain green suite can't give you. See [`../skills/test-report/SKILL.md`](../skills/test-report/SKILL.md).

**Definition of covered:** a requirement is *covered* when at least one test tagged with its ID exists **and passed in the latest run**. A tagged-but-failing requirement counts as a regression, not coverage. An untagged requirement is a traceability gap the report surfaces by name.
