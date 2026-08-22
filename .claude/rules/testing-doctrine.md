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
