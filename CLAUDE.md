# <PROJECT NAME> — Claude Code instructions

> Template from `claude-harness`. Tailor the **Project** section per repo; leave the **Harness**
> section as-is. Keep this file small — coding standards live in `.claude/rules/`, not here.

## Project

> FILL THIS IN — it's the only part you must edit. Replace each `<...>` below.

- **What this is:** <one line describing the app>
- **Stack:** <languages / frameworks — one `.claude/rules/stack/<tech>.md` gets generated per technology>
- **Run / test / typecheck:** `<run cmd>` · `<test cmd>` · `<typecheck cmd>`  (hooks use these — keep accurate)
- **Definition of done:** tests pass, typecheck clean, `/code-review` clean, validation strategy met.

<!-- EXAMPLE of a filled-in Project section (delete this comment block once you've filled yours):
- **What this is:** A finance tracker web app — users log expenses and see monthly summaries.
- **Stack:** Next.js (TypeScript), Supabase (Postgres), Tailwind.
- **Run / test / typecheck:** `npm run dev` · `npm test` · `npx tsc --noEmit`
- **Definition of done:** tests pass, typecheck clean, /code-review clean, validation strategy met.
-->


## Harness (how we work)

The system around the model matters as much as the model. Reliability is built into this harness,
not assumed from the model.

**Two ways to work:**
- **Full SDLC pipeline** (`/sdlc`) — dual-agent maker/checker, Phase 0-9, exit-criteria gates,
  `docs/` artifacts + mermaid diagrams + `docs/progress-log.md`. Use for a whole project/greenfield.
- **Lightweight modular** — trigger any skill in any order for smaller work:
  - Plan a feature: `/grill` → `/to-spec` → `/to-tickets`
  - Build a ticket: `/prime` → `/plan` → `/implement` (test-first via `/tdd`, calls `/code-review`) → PR
  - Anytime: `/tdd`, `/evals`, `/write-skill`, `/calibrate` (reactive: one failure → one fix;
    sweep: session end → many improvements, bucketed)

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
  Be specific about the *end*; let the model build the road. Implement it test-first via `/tdd`
  (red before green, one slice at a time; the test is the spec the agent can't argue with).
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

**Jev decision layer (fast, cheap second model):** [Jev](https://typesafe.ai) is TypeSafe's
*decision* model — it doesn't write text, it picks yes/no·choice·score with a confidence, in a
fraction of a second, and is billed on input only. It never replaces Claude; it offloads the
*choices* so Claude spends tokens on code. Shared client: `.claude/hooks/jev.py` (TypeSafe-native
System One endpoint; **fails open** — no key ⇒ hooks do nothing). Key lives in the gitignored
`.claude/settings.local.json` (`TYPESAFE_API_KEY`); template in `.settings.local.json.example`.
Four use cases are wired:
- **Skill picker** (`UserPromptSubmit` → `jev-skill-pick.py`): Jev reads every skill's
  name/description and tells Claude which one skill fits the prompt (or none), so Claude doesn't
  weigh all of them.
- **Rule enforcer** (`PreToolUse` → `jev-rules.py`, rules in `.claude/jev-rules.json`): the hard
  "never do X" subset of `coding-standards.md`, checked on every edit/commit. ≥0.8 blocks and quotes
  the rule; 0.5–0.8 warns. Runs *alongside* the test-first gate.
- **Faster explore** (`/jev-explore` skill): keyword pre-filter, then Jev ranks candidate files so
  Claude opens only the top few. (For real project repos — this harness keeps its own code under
  `.claude/`, which explore skips.)
- **Cheap pre-review triage** (`/adversarial-loop` skill): Jev risk-triages a diff (auth, money,
  schema, data-loss, state, API, secrets); low-risk gets one critic round, risky gets the full loop.

Also shipped but *not* wired (per-project tools): `/jev-spec-check` (+ `jev-spec.json`, optional
`jev-spec-hook.py`) and `/jev-browser-check`. Plumbing tests: `python3 .claude/hooks/test_jev_hooks.py`
(fake Jev, no key). The compaction plugin from the source pack is intentionally **not** adopted.

**When something fails,** ask which harness layer ran out of road (instruction / context / memory /
tool / environment / durable-state / orchestration / delegation / skill / verification / trace /
learning), fix that layer, and `/calibrate` (reactive mode) it so the same class of failure gets harder to repeat.
