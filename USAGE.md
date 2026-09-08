# How to use the harness

Two ways to work. Pick per task; they share the same skills.

## Quick reference — every command

| Command | Does | When |
|---|---|---|
| `/sdlc` | Runs the full Phase 0-9 pipeline with gates | New project / big feature |
| `/prime` | Loads codebase context | Start of any build session |
| `/grill` | Interviews you to shared understanding | Requirements are fuzzy |
| `/to-spec` | Writes a code-free spec | After grilling |
| `/to-tickets` | Cuts vertical feature slices | After a spec |
| `/plan` | Per-ticket plan, validation-first | Before building a ticket |
| `/implement` | Builds it (TDD, typecheck, review, commit) | After a plan |
| `/tdd` | Inner loop: red→green→refactor, unit **and** Playwright E2E | Writing any feature/fix |
| `/test-optimize` | Prune the suite — Add / Purge / Merge (flaky, redundant) | Suite slow or noisy |
| `/code-review` | Fresh-context review + Fowler smells | After implementing |
| `/codex-check` | Blind Codex black-box tests **+ non-blind test-first audit** | Independent verification |
| `/pr-gate` | PR + review + senior approval, no auto-merge | Before merge |
| `/evals` | Stands up an outcome-graded eval suite (correctness + perf) | Want a regression net |
| `/benchmark` | Load-tests the app vs the NFR perf/scale targets | Verify/enforce performance |
| `/write-skill` | Author/prune a skill (deletion test) | Extending the harness |
| `/calibrate` | Fold learnings into the harness — reactive (one failure→one fix) or session sweep | After a bug/bad run, or at session end |
| `/deploy` | Placeholder (planned-only) | Not active yet |

Phase skills used by `/sdlc`: `/tooling-survey` `/brd` `/architecture` `/db-design`
`/backend-design` `/prototype` `/nfr`.

## Workflow A — lightweight (most days)

For a feature or fix on an existing codebase:

```
/prime                 # load context (fresh conversation)
/grill                 # nail down what & why
/to-spec               # freeze the destination (no code)
/to-tickets            # slice into vertical features
# then per ticket, in a fresh conversation each:
/prime  →  /plan  →  /implement       (/implement calls /code-review)
# you review the diff, then open a PR
```

If a step was wrong, just re-run that one skill — nothing is chained.

## Workflow B — full SDLC pipeline (new project / greenfield)

```
/sdlc
```
It walks Phase 0-9, writing artifacts under `docs/` (BRD, architecture + ADRs, DB, backend, NFR),
a throwaway `prototype/index.html`, and a `docs/progress-log.md`. Each phase has **exit criteria**
that must pass before the next. **Maker ≠ checker:** Claude builds, **Codex** blind-checks against
the contracts, a human/`senior-reviewer` approves the merge. No auto-merge.

## Test-first is enforced (not just advised)

The **testing doctrine** (`.claude/rules/testing-doctrine.md`) sets the pyramid: unit inner loop →
Playwright **E2E** outer loop → `/evals` regression net → `/test-optimize` hygiene. `/tdd` picks the
level per slice (user-facing flow → E2E; else unit).

Two enforcement layers keep it honest:
- **Blocking gate** (`.claude/hooks/test-first-gate.sh`, PreToolUse) — refuses to edit an
  *implementation* file until a **failing test exists** (`/tdd` records a red receipt at the red step,
  clears it at green). Test files, docs, config, `.claude/` are exempt. Legit non-TDD edit? Run with
  `TDD_BYPASS=1`. The gate **fails open** — a hook bug never blocks you, only a real impl-without-test does.
- **Independent audit** (`/codex-check`) — a non-blind reviewer reads git history + diff and verifies
  every new impl change had a **non-vacuous** test committed **test-first**. Codex itself stays blind.

> Order in one line: a *new* behavior's test fails first (red) → you implement → it passes (green);
> meanwhile *all existing* tests stay green. You build on a green base; the new test is the permission
> to write code.

## The subagents (Claude spawns these)

- `requirements-analyst` — decompose + edge-case sweep + assumptions to confirm.
- `code-reviewer` — standards + spec axes, fresh context.
- `security-reviewer` — authz/secrets/injection/deps; logs every finding.
- `researcher` — primary-source research for open questions.
- `codex-checker` — the blind black-box verifier (backed by the Codex CLI).
- `senior-reviewer` — the final approve/block gate.

## Memory (so it remembers across sessions)

- Put standing facts in `.claude/memory/facts.md`, decisions in `.claude/memory/decisions.md`.
- The session-start hook loads their **index** each session (pointers, not full text).
- Run `/calibrate` after a failure (reactive mode) to write the lesson back in — the harness compounds over time.

## Tips

- Keep `CLAUDE.md`'s run/test/typecheck commands accurate — the hook and `/implement` rely on them.
- Do design in separate conversations (grill / spec / plan / implement) to avoid context rot.
- On frontier models, resist adding heavy guardrails — thin skills + leading words win.
