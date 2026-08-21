# Playwright E2E reference

Pulled in on demand — `/tdd` SKILL.md stays thin (progressive disclosure).

## Which level?

Default to unit. Choose the Playwright E2E variant per the six prioritization signals in
[`../../rules/testing-doctrine.md` § Which level?](../../rules/testing-doctrine.md#which-level).

## Drive it like a user

Interact via what the user perceives: `getByRole`, `getByLabel`, `getByText`. Assert on visible
outcomes — text on screen, enabled/disabled state, URL after navigation. Never reach into CSS
classes, element IDs, or internal call counts. If you can't assert it through the browser's
accessibility tree, the behavior may not be user-visible enough to warrant an E2E test.

## Flakiness traps

- **Implicit waits / sleep** — fixed delays make tests time-dependent; use web-first assertions instead (they auto-retry).
- **Test ordering / shared state** — each test must be independently runnable; use fresh browser contexts and seed/reset DB state in fixtures, not in a shared `beforeAll`.
- **Shared DB / external state** — tests that mutate shared state interleave unpredictably in CI; isolate with per-test fixtures or a test DB that resets between runs.

## Stack

See [`.claude/rules/stack/playwright.md`](../../rules/stack/playwright.md) for install, config,
trace-on-failure setup, and the Context7 pointer for version-specific API.
