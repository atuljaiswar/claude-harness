# Playwright (E2E testing)

Generated: 2026-08-21 | Covers: Playwright v1.x (current stable)

## Current best practice

- **Install / runner:** `npm init playwright@latest` to scaffold; run with `npx playwright test`. CI uses `--reporter=html` for trace artifacts.
- **Project config:** `playwright.config.ts` at repo root — define projects (chromium/firefox/webkit), base URL, and `use.trace: 'on-first-retry'`.
- **Auto-waiting:** Playwright waits for elements to be actionable before interacting. Never add manual `sleep` or fixed timeouts — use **web-first assertions** (`expect(locator).toBeVisible()`) which auto-retry until timeout.
- **Locate by role/label:** `page.getByRole()`, `page.getByLabel()`, `page.getByText()` — match what the user sees, not internal CSS selectors or test IDs.
- **Trace on failure:** enable `trace: 'on-first-retry'` in config so every CI failure ships a `.zip` trace viewable in `playwright show-trace`.
- **Isolation:** each test gets a fresh browser context (`use.storageState` for pre-authenticated state; never share mutable state between tests).
- **Version specifics:** pull the exact API via Context7 (`@playwright/test` for current version in lockfile) — do not rely on training-data knowledge of the API surface.
