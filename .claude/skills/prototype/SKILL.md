---
name: prototype
description: Phase 5 — build a throwaway HTML prototype for visible client progress, in parallel with Phases 2-4. Also usable standalone to raise discussion fidelity before a spec.
---

# prototype

Raise the fidelity of the discussion with a cheap, concrete artifact to react to.

## Steps

1. Immediately after the Phase 1 grill-down, build a **rapid HTML prototype** — throwaway/reference,
   **not production code**. Run it in parallel with Phases 2-4.
2. Output: `prototype/index.html` (self-contained; inline CSS/JS is fine).
3. It exists to show visible progress and answer "how should it look / behave" — links in as an
   asset for the spec, not a source of truth.

## Client checkpoint cadence

Deliver a **demoable snapshot at the end of every phase (1-6)**, not just at the end. Define what
"demoable" means per phase, e.g.:
- Phase 1 = clickable flow diagram
- Phase 5 = working prototype
- Phase 7 = live PR preview

Standalone use: invoke anytime a "how should it look / behave?" question is blocking a spec —
especially anything touching front-end.

**Also the home for non-UI visual references** (richer-references rule): a design system, an
architecture diagram, or a side-by-side option comparison is far clearer as a self-contained `.html`
artifact than a markdown wall — readable by both the agent and a human. Emit those here too; keep
prose references in markdown.
