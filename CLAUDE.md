# <PROJECT NAME> — Claude Code instructions

> Template from `claude-harness`. Tailor the **Project** section per repo; leave the **Harness**
> section as-is. Keep this file small — coding standards live in `.claude/rules/`, not here.

## Project

- **What this is:** <one line>
- **Stack:** <languages / frameworks — generate `.claude/rules/stack/<tech>.md` per technology>
- **Run / test / typecheck:** `<commands>`  (the hooks use these — keep them accurate)
- **Definition of done:** tests pass, typecheck clean, `/code-review` clean, validation strategy met.

## Harness (how we work)

The system around the model matters as much as the model. Reliability is built into this harness,
not assumed from the model.

**Two ways to work:**
- **Full SDLC pipeline** (`/sdlc`) — dual-agent maker/checker, Phase 0-9, exit-criteria gates,
  `docs/` artifacts + mermaid diagrams + `docs/progress-log.md`. Use for a whole project/greenfield.
- **Lightweight modular** — trigger any skill in any order for smaller work:
  - Plan a feature: `/grill` → `/to-spec` → `/to-tickets`
  - Build a ticket: `/prime` → `/plan` → `/implement` (calls `/code-review`) → review → PR
  - Anytime: `/evals`, `/write-skill`, `/retro`

**SDLC docs layout** (created by the pipeline in the target repo): `docs/00-tooling-survey.md`,
`docs/01-brd.md`, `docs/02-architecture.md`, `docs/adr/NNN-*.md`, `docs/03-database.md`,
`docs/04-backend.md`, `docs/non-functional-requirements.md`, `docs/progress-log.md`,
`prototype/index.html`.

**Maker ≠ checker:** the agent that did a phase may not sign off its own exit criteria. Claude is
the maker; **Codex** (blind, contract-only) is the checker; a human/`senior-reviewer` approves the
merge. No auto-merge. Codex is **active** (`codex exec`, installed + authenticated) — invocation in
`.claude/skills/codex-check/reference/codex-setup.md`.

**Non-negotiables (leading words):**
- **Validation-first** — define the testing strategy *before* code. Grade **outcomes, not paths**.
  Be specific about the *end*; let the model build the road.
- **Spec, not code** — specs and plans contain no code blocks; they point at the live codebase.
- **Vertical slice** — tickets are thin end-to-end features, never horizontal layers.
- **Draft-and-confirm** — propose options + a recommendation and wait for confirmation; never grill
  with blank questions; never enact a plan before shared understanding is confirmed.
- **Decompose requirements first** — sweep edge cases (empty/one/many, invalid/boundary,
  concurrency, state transitions, failures, access-control) and confirm the role/access model and
  data model **before** any schema.

**Verification (don't trust the final sentence):** run typecheck + tests + `/code-review`; attach
receipts. "Looks good to me" is not a verification strategy.

**Memory:** durable state lives in `.claude/memory/` (semantic facts, decisions, episodic session
notes). The model only acts on what reaches the context window — the session-start hook loads the
memory *index*, not bodies; pull detail on demand.

**Standards & stack rules:** `.claude/rules/coding-standards.md` (read at review time) and
`.claude/rules/stack/*.md` (current best practices per technology, generated via Context7).

**When something fails,** ask which harness layer ran out of road (instruction / context / memory /
tool / environment / durable-state / orchestration / delegation / skill / verification / trace /
learning), fix that layer, and `/retro` it so the same class of failure gets harder to repeat.
