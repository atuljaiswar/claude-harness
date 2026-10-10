# Reproducible test data (the seed convention)

`/test-report` needs every run to start from the **same known data** — so results are repeatable and
you can see exactly what each test acted on. This is the convention a project implements once; the
skill then calls it on every run. No Python; TypeScript/SQL/JSON only.

## The three parts

1. **Committed fixtures** — the canonical test data lives in version control at
   `tests/seed/<module>.json` (one file per module: `enquiry.json`, `registration.json`, …). Because
   it's committed, the data is reproducible across machines and its history is a git diff. Example:

   ```json
   // tests/seed/enquiry.json
   {
     "users": [
       { "id": "u-admin",   "role": "admin",   "name": "Asha Admin" },
       { "id": "u-teacher", "role": "teacher", "name": "Tarun Teacher" }
     ],
     "enquiries": [
       { "id": "e-1", "name": "Rahul", "phone": "9990001111", "course": "Physics" }
     ]
   }
   ```

2. **A seed step** the project exposes as `npm run seed:test` — truncates the **test** database and
   loads the fixtures, giving a clean, identical starting state every run. Point it at a dedicated
   test DB / schema via `DATABASE_URL`, never the dev DB. Keep it idempotent (safe to run repeatedly).

3. **Per-test isolation** — each test still wraps its own writes in a transaction+rollback or its own
   schema so tests don't interfere; the global seed is the shared *read* baseline, per-test fixtures
   cover case-specific data. (This is the existing Playwright-fixtures rule in
   `../../tdd/reference/playwright-e2e.md` — the seed just gives it a known floor.)

## How the skill uses it

- **Before the suite:** run `npm run seed:test`. If the command is missing, scaffold it from this
  file and add the fixtures, then run.
- **In the report:** list what was seeded (counts per table + the key rows) in the report's
  **Test data** section, so the data a test used is never a mystery.

## Scaffolding a project that has none

1. Create `tests/seed/<module>.json` for each module with the minimum rows the tests need.
2. Add a `seed:test` script (plain Node/TS) that connects to the test DB, truncates, and inserts the
   fixtures. Keep it dependency-light — a few `INSERT`s or your ORM's `createMany`.
3. Wire it into Playwright via `globalSetup` in `playwright.config.ts` **or** call it from the skill's
   step 1 — either way it runs before the first test.
4. Commit the fixtures + script. From now on every `/test-report` run starts identical.
