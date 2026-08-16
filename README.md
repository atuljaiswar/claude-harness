# claude-harness

A reusable Claude Code harness, compiled from the research in the `atul-wiki` vault
(harness engineering, skill authoring, memory, evals). Drop it into any project to get a
consistent SDLC workflow, early-firing hooks, specialist subagents, and a memory layout.

> **Design stance:** this harness follows its own advice. Skills are **modular** (trigger any
> one, in any order — not a chain), each `SKILL.md` is **tiny** and steered with **leading words**,
> hooks fire **as early as possible**, and verification is **validation-first**. On frontier models,
> thin guides beat heavy guardrails — so nothing here hand-holds more than it must.

> **New / not sure where to start? → [`GETTING-STARTED.md`](GETTING-STARTED.md)** (baby steps, no
> setup knowledge assumed). The quickstart below is the short version.

## Quickstart (30 seconds)

```bash
# from the claude-harness folder
./install.sh /path/to/your/project
```
Then open the project in Claude Code:
1. Edit `CLAUDE.md` → fill the **Project** section (stack + run/test/typecheck commands).
2. `/prime` — load the codebase.
3. `/sdlc` (full pipeline) **or** `/grill` → `/plan` → `/implement` (lightweight).

**Full detail:** [`INSTALL.md`](INSTALL.md) (prerequisites, Codex setup, verify) ·
[`USAGE.md`](USAGE.md) (every command + worked examples).

Prefer to let the agent do it? Say: *"install the .claude harness from this folder into the current
repo, then generate stack rules for my stack."*

## Two ways to work

### A) Full SDLC pipeline — `/sdlc`
Dual-agent maker/checker, Phase 0-9, with exit-criteria gates, `docs/` artifacts, mermaid diagrams,
and a `docs/progress-log.md`. Faithful to the SDLC Harness Prompt. Phases:

`/tooling-survey` (0) → `/brd` (1) → `/architecture` (2) → `/db-design` (3) → `/backend-design` (4)
→ `/prototype` (5, starts after 1, runs in parallel) → `/nfr` (6) → `/plan`+`/implement`+`/codex-check` (7)
→ `/pr-gate` (8) → `/deploy` (9, planned-only)

Maker ≠ checker: Claude makes, **Codex** (blind, contract-only) checks, a human/`senior-reviewer`
approves. No auto-merge. Codex needs one-time setup — see
`skills/codex-check/reference/codex-setup.md`.

### B) Lightweight modular — trigger any skill, any order
**Outer loop:** `/grill` → `/to-spec` → `/to-tickets`
**Inner loop:** `/prime` → `/plan` → `/implement` (calls `/code-review`) → review → PR
**Anytime:** `/evals`, `/write-skill`, `/retro`

Every skill is independently triggerable; artifacts are plain editable markdown, so nothing is
locked into a pipeline. Use B for small changes, A when you want the full gated record.

## What's inside

| Path | What it is | Vault lineage |
|---|---|---|
| `skills/grill` | Relentless one-branch-at-a-time requirements interview | Draft-and-Confirm, grill-me 5 rules, Requirements Decomposition |
| `skills/to-spec` | Spec with **no code blocks** (points at live code) | Spec Not Code |
| `skills/to-tickets` | **Vertical** feature slices, not layers | Vertical Slice |
| `skills/plan` | Per-ticket plan; **testing strategy first** | Validation-First Development |
| `skills/implement` | Tiny: TDD at seams → typecheck → code-review → commit | Modular Skills |
| `skills/code-review` | Two axes (standards + spec) + Fowler smells, fresh context | code-review, Leading Words |
| `skills/evals` | Stand up an outcome-graded suite | AI Evals |
| `skills/prime` | Load codebase context for the current ticket | Context Assembly |
| `skills/write-skill` | Author/prune skills with the deletion test | Skill Authoring |
| `skills/retro` | Harness-evolution loop: failure → infrastructure | Harness Engineering |
| `skills/sdlc` | Orchestrates the full Phase 0-9 pipeline | SDLC Harness Prompt |
| `skills/tooling-survey` | Phase 0 — survey + synthesize domain tools → `docs/00-tooling-survey.md` | SDLC Phase 0 |
| `skills/brd` | Phase 1 — BRD with unique testable IDs + user-journey diagram | SDLC Phase 1 |
| `skills/architecture` | Phase 2 — dual-agent proposals, trade-off table, ADRs, C4 | SDLC Phase 2 |
| `skills/db-design` | Phase 3 — 3NF, indexing, rollback, erDiagram | SDLC Phase 3 |
| `skills/backend-design` | Phase 4 — API contracts, authz per endpoint, sequence diagrams | SDLC Phase 4 |
| `skills/prototype` | Phase 5 — throwaway HTML prototype + checkpoint cadence | SDLC Phase 5 |
| `skills/nfr` | Phase 6 — perf/scale/SEO/GEO/observability/compliance/token-budget | SDLC Phase 6 |
| `skills/codex-check` | Phase 7 — blind Codex maker/checker black-box tests | SDLC Phase 7 |
| `skills/pr-gate` | Phase 8 — PR + review + explicit senior approval, no auto-merge | SDLC Phase 8 |
| `skills/deploy` | Phase 9 — planned-only placeholder | SDLC Phase 9 |
| `agents/*` | requirements-analyst, code-reviewer, security-reviewer, researcher, codex-checker, senior-reviewer | Sub-agents primitive |
| `rules/coding-standards.md` | Stack-agnostic standards, read at review time | code-review |
| `rules/stack/` | Per-project generated stack rules (Context7) | SDLC Harness Pipeline Phase 0 |
| `hooks/*` | Early-firing check/format + session context loader | Hook Design, Context Assembly |
| `memory/*` | Semantic / episodic / procedural memory layout | Agent Memory |
| `settings.json` | Wires hooks + read-only permission allowlist | Hook Design |

## The one diagnostic to remember

When the agent fails, don't only ask *"was the model good enough?"* — ask **which harness layer
ran out of road**: missing instruction? wrong context? stale memory? vague tool schema? wrong
environment? no durable state? no orchestration? should it have been delegated? no skill? no
verification? no trace? learned nothing last time? Fix that layer, then `/retro` it in.
