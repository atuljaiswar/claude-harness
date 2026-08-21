# TDD anti-patterns (name the smell; the name carries the fix)

Pulled in on demand — the main `SKILL.md` stays thin (progressive disclosure).

## Vacuous test
A test that passes no matter what the code does (no meaningful assertion, or asserts something always
true like `expect(result).toBeDefined()` on a function that can't return undefined). **Fix:** every
test must be able to fail — prove it by seeing red before green.

## Test-after masquerading as TDD
Writing the implementation, then a test that encodes whatever the code already does. It locks in bugs
and gives false confidence. **Fix:** red first, always. If the code exists, delete-and-rebuild or at
minimum write the test and confirm it fails against a broken stub first.

## Testing the mock
Mocking so much that the test only verifies the mock's wiring, not real behavior. **Fix:** mock only
at true external seams (network, clock, filesystem); assert on the real unit's output.

## Asserting on implementation detail
Reaching into private state / call-order / internal method names. Breaks on every refactor even when
behavior is unchanged, so tests become a tax instead of a safety net. **Fix:** assert observable
outcomes only — inputs → outputs/state/effects.

## The mega-test
One test that exercises ten behaviors, so a failure doesn't tell you which. **Fix:** one behavior per
test; a failing test name should localize the bug.

## Green-chasing by weakening the test
When a test fails, editing the *test* (loosening the assertion) instead of fixing the code. **Fix:**
change the test only when the spec changed; otherwise the code is what's wrong.

## Skipping the "fails for the right reason" check
Test goes red because of an import error / typo, you fix the typo, it goes green — but the assertion
never actually ran. **Fix:** read the red output; confirm it's an *assertion* failure before writing
implementation.

## The sleep-based wait
Fixed `sleep`/timeout used to "wait for" the app to reach a state — flaky by construction because
timing varies across machines and load. **Fix:** use web-first assertions / auto-wait on the visible
outcome (`expect(locator).toBeVisible()`) so the test retries until true or times out with a clear message.

## The DOM-internals assertion
Asserting on CSS class names, element IDs, or internal call order instead of what the user actually
sees and can do. Breaks on every visual refactor while behavior stays unchanged. **Fix:** assert
visible text, ARIA role, or accessible state — what the browser's accessibility tree exposes.

## The mega-journey test (E2E)
One E2E test walking ten screens so a failure localizes nothing and any screen's flakiness fails the
whole suite. **Fix:** one user-visible behavior per test; share setup (auth, seeded data) via
fixtures, not one long sequential script.
