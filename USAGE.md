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
| `/code-review` | Fresh-context review + Fowler smells | After implementing |
| `/codex-check` | Blind Codex black-box tests | Independent verification |
| `/pr-gate` | PR + review + senior approval, no auto-merge | Before merge |
| `/evals` | Stands up an outcome-graded eval suite (correctness + perf) | Want a regression net |
| `/benchmark` | Load-tests the app vs the NFR perf/scale targets | Verify/enforce performance |
| `/write-skill` | Author/prune a skill (deletion test) | Extending the harness |
| `/retro` | Turn a failure into a rule/hook/test/skill | After a bug or bad run |
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
- Run `/retro` after a failure to write the lesson back in — the harness compounds over time.

## Tips

- Keep `CLAUDE.md`'s run/test/typecheck commands accurate — the hook and `/implement` rely on them.
- Do design in separate conversations (grill / spec / plan / implement) to avoid context rot.
- On frontier models, resist adding heavy guardrails — thin skills + leading words win.
