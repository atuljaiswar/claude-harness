---
name: prototype
description: Build throwaway code that answers a design question — either a drivable LOGIC demo (does this state/access/data model feel right?) or a UI exploration (what should this look like?). Also the Phase 5 visible-progress artifact.
---

# prototype

A prototype is **throwaway code that answers a question. The question decides the shape.** It raises
the fidelity of the discussion with a cheap, concrete artifact to react to — so a wrong model gets
caught by *clicking*, not by imagining it in words.

## Pick a branch

Name the question first, then build the matching artifact. Getting the branch wrong wastes the whole
prototype.

- **"Does this logic / state / access / data model feel right?"** → **LOGIC branch** (below). Build a
  single self-contained HTML file the user *drives* — free-play buttons plus guided walkthroughs that
  push the model through the hard cases. This is the branch that hardens **requirements**.
- **"What should this look like / behave like?"** → **UI branch** (below). Build the visible-progress
  HTML artifact.

If the question is genuinely ambiguous and the user is unreachable, default by context (a
backend/module/state question → LOGIC; a page/component → UI) and **state the assumption at the top of
the prototype**.

## LOGIC branch — harden a model before it's built

Use when grilling exposed a non-trivial **state machine**, a contested **role/access model**,
concurrency/ordering, or the user is hedging ("I think…"). This is the concrete answer to
"assumptions confirmed in words but wrong in reality" — the most expensive class of rework.

1. **State the question explicitly at the top** of the demo (e.g. "Should a viewer ever reach the
   approve action?").
2. **Isolate the logic in a portable, DOM-free module** — a reducer / state machine / pure functions
   in one `<script>` block, written so it could be lifted straight into the real codebase later.
3. **Build one self-contained HTML file** with: a **current-state display**, **free-play buttons** for
   each action/transition, and a few **guided-scenario** buttons that replay the awkward cases.
4. **Surface the full relevant state after every action** so the user sees exactly what changed.
5. **Hand it to the user to drive**; collect corrections on the awkward cases.
6. **Capture the verdict.** Fold the validated decision back into `docs/01-brd.md` against its
   requirement ID and drop it from the flagged-assumptions list. Keep the logic module (now
   production-ready); the HTML shell is disposable.

## UI branch — visible progress + "how should it look?"

1. Immediately after the Phase 1 grill-down, build a **rapid HTML prototype** — throwaway/reference,
   **not production code**. Run it in parallel with Phases 2-4.
2. Output: `prototype/index.html` (self-contained; inline CSS/JS is fine). For real comparison,
   generate a few radically different variations switchable via a URL param.
3. It exists to show visible progress and answer "how should it look / behave" — links in as an
   asset for the spec, not a source of truth.

### Client checkpoint cadence

Deliver a **demoable snapshot at the end of every phase (1-6)**, not just at the end. Define what
"demoable" means per phase, e.g.:
- Phase 1 = clickable flow diagram
- Phase 5 = working prototype
- Phase 7 = live PR preview

**Also the home for non-UI visual references** (richer-references rule): a design system, an
architecture diagram, or a side-by-side option comparison is far clearer as a self-contained `.html`
artifact than a markdown wall — readable by both the agent and a human. Emit those here too; keep
prose references in markdown.

## Rules (both branches)

1. **Throwaway from day one, clearly marked as such** — located next to the module/page it prototypes,
   named so no one mistakes it for production. Obey the project's existing routing convention.
2. **Trivial to run** — one command (`pnpm <name>`, `bun <path>`) or a double-clickable HTML file. No
   thinking required to start it.
3. **No persistence by default** — state lives in memory. Persistence is what the prototype *checks*,
   not something it depends on. If the DB is the question, hit a scratch DB named "PROTOTYPE, wipe me".
4. **Skip the polish** — no tests, no error handling beyond what makes it runnable, no abstractions.
5. **Surface the state** — after every action (LOGIC) or on every variant switch (UI), render the full
   relevant state.
6. **Capture it when done** — fold the validated decision into the real code, then commit the prototype
   to a **throwaway branch** (out of `main`) and leave a pointer + the settled verdict on the issue.
