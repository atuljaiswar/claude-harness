# Getting Started (baby steps)

New here? This is the "I just want to use it" guide. No prior setup knowledge assumed.

---

## What this is (10-second version)

`claude-harness` is a **folder of instructions** for Claude Code. You copy it into a coding
project, fill in **4 lines**, and then you type commands like `/plan` and `/implement` and Claude
does the work the right way. That's it. It is not an app you install or run.

---

## Step 1 — Have a project to work in

A "project" = a folder with your code (or an empty folder for a new app). Example:
`C:\Users\AtulJ\Desktop\my-app`. If you don't have one, make an empty folder — the harness can
build from scratch.

## Step 2 — Put the harness into that project

**Easiest way (no commands): let Claude do it.**
Open your project in Claude Code and paste this:

> Install the .claude harness from `C:\Users\AtulJ\Desktop\ATUL\claude-harness` into this repo
> (copy the `.claude` folder and `CLAUDE.md`), then show me what to fill in.

**Or do it yourself (PowerShell):**
```powershell
Copy-Item -Recurse "C:\Users\AtulJ\Desktop\ATUL\claude-harness\.claude" "C:\Users\AtulJ\Desktop\my-app\.claude"
Copy-Item "C:\Users\AtulJ\Desktop\ATUL\claude-harness\CLAUDE.md" "C:\Users\AtulJ\Desktop\my-app\CLAUDE.md"
```

**Or (git bash):**
```bash
cd /c/Users/AtulJ/Desktop/ATUL/claude-harness
./install.sh /c/Users/AtulJ/Desktop/my-app
```

After this your project has two new things: a `.claude/` folder and a `CLAUDE.md` file.

## Step 3 — Fill in the ONE thing you must fill

Open `CLAUDE.md` in your project. Only the top **Project** section needs editing. Replace the
`<...>` bits. Example of a filled-in version:

```
## Project
- **What this is:** A finance tracker web app — users log expenses and see monthly summaries.
- **Stack:** Next.js (TypeScript), Supabase (Postgres), Tailwind.
- **Run / test / typecheck:** `npm run dev` · `npm test` · `npx tsc --noEmit`
- **Definition of done:** tests pass, typecheck clean, /code-review clean, validation strategy met.
```

What the three commands mean (ask Claude if unsure for your stack):
- **run** = how you start the app (`npm run dev`, `python manage.py runserver`, ...).
- **test** = how you run tests (`npm test`, `pytest`, ...).
- **typecheck** = how you check types (`npx tsc --noEmit`, `mypy .`, ...). If your stack has none, put `echo skip`.

Leave the rest of `CLAUDE.md` alone. That's the whole "fill-in" job.

## Step 4 — Load the project into Claude

In Claude Code, type:
```
/prime
```
This makes Claude read your codebase so it knows what it's working with.

## Step 5 — Build something

**Small change or feature** (most common) — type these one at a time:
```
/grill        → Claude interviews you about what you want. Answer its questions.
/plan         → Claude writes a plan (including how it'll test). Confirm it.
/implement    → Claude writes the code and tests, then reviews itself.
```
Then look at the result, and if happy, ask Claude to open a PR (or just commit).

**Whole new app / big feature** — type one command:
```
/sdlc
```
Claude runs the full pipeline (requirements → architecture → database → backend → build → review)
writing documents into a `docs/` folder as it goes, and pausing at gates for your approval.

That's everything. You can stop reading here.

---

## Optional extras (when you're ready)

- **Stack rules:** ask Claude to "generate stack rules for my stack" — it writes current best
  practices into `.claude/rules/stack/`. Do this once per project.
- **Codex double-check:** if you have Codex installed, `/codex-check` has a second AI blind-test
  your code independently. (You already have this set up.)
- **Memory:** Claude remembers project facts/decisions in `.claude/memory/`. After a bug, run
  `/retro` so it learns and doesn't repeat it.
- **Full command list:** see [`USAGE.md`](USAGE.md).

---

## How to tell a teammate to use it (copy-paste this)

> 1. Copy the `.claude` folder and `CLAUDE.md` from the harness into your project (or ask Claude
>    Code to do it for you).
> 2. Open `CLAUDE.md` and fill the 4 lines at the top (what the app is, the stack, the
>    run/test/typecheck commands).
> 3. In Claude Code: type `/prime`, then `/grill` → `/plan` → `/implement` for a feature, or
>    `/sdlc` for a whole app.
> That's it — full guide in `GETTING-STARTED.md`.

---

## FAQ

**Do I run the harness folder itself?** No. You copy it into your project and use it there.

**Do I need to fill anything besides `CLAUDE.md`?** No. Everything else has sensible defaults; the
`.claude/rules/stack/` and `.claude/memory/` files get filled by Claude as you work.

**Nothing shows up when I type `/`?** Make sure the `.claude` folder is in the *project you opened*
in Claude Code (not a parent folder), then restart the session.

**I don't have Codex — does it still work?** Yes. Everything works with just Claude Code; the
`/codex-check` step is the only Codex-specific one.

**Claude says it can't edit a file until a test fails first?** That's the **test-first gate** working
as intended. The harness makes Claude write a *failing* test for a new behavior before it writes the
code — that's real TDD (the failing test proves the test actually checks something; then the code
makes it pass). For a legit non-TDD edit (config tweak, quick experiment, emergency fix), run the
command again with `TDD_BYPASS=1`.

**Does it test in a real browser?** Yes, for user-facing flows. `/tdd` writes **Playwright** E2E tests
that drive the app like a user (click, type, see the result) — so Claude confirms the feature actually
works, not just that the logic passes. Needs a running app to point at (your project); nothing to set
up in the harness itself.
