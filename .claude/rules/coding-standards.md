# Coding standards (stack-agnostic)

Read at **review time** (by `/code-review` and the code-reviewer agent), not loaded into every
prompt — standards belong here, not in `CLAUDE.md`. Add project-specific rules as they're decided.

## Defaults

- **Deep modules** — many capabilities behind a small interface; one door, not many. Callers see a
  simple surface; complexity is hidden. Prefer this over scattered shallow helpers the agent must
  chase across files.
- **Deletion test** — if removing a function/file leaves all tests passing, it's dead; delete it.
- **Single source of truth** — no duplicated *knowledge* (rules, facts) — one authoritative
  representation, derive the rest. Similar-looking code that encodes *different* knowledge is not a
  DRY violation; don't force it together.
- **Decoupled by default** — a change should stay local. **Tell, Don't Ask** (behavior lives with
  its data — call `order.ship()`, don't pull fields out to decide externally); no train-wreck chains
  (`a.b().c().d()` hard-wires the object graph — Law of Demeter). This is the *between*-module rule
  that "deep modules" implies.
- **Names say what they do** — no mysterious names; the name is the first documentation. Rename the
  moment a name stops telling the truth — a lying name is worse than a vague one.
- **Errors are explicit** — no silent failures; every failure path is loud and handled. **Crash
  early** on the *impossible* (a dead program beats a crippled one spreading corrupt state); handle
  the merely-*expected* (bad input, I/O, network) gracefully. Don't confuse the two.
- **Guard the boundaries** — validate/normalize untrusted input where it enters; be strict in what
  you accept. Assert genuine invariants (the "can never happen"); never assert on expected errors.
- **No broken windows** — a known defect is fixed now or bounded with a tracked `FIXME` + ticket;
  never left to normalize. Small neglect compounds into rot.
- **Refactor or feature, never both in one change** — a change alters behavior *or* structure, not
  both; separate commits, so a break has one obvious cause.
- **Shared mutable state is incorrect state** — prefer immutability / passing data over sharing it;
  if you must share across concurrent paths, guard every access. Treat intermittent, unreproducible
  failures as a suspected race until proven otherwise.
- **Small, vertical changes** — end-to-end slices, reviewable in one pass. Small steps beat big
  leaps — verify each before the next; don't outrun your headlights.
- **Tests describe behavior** — written against the spec, not retrofitted to the implementation.
- **No secrets in code** — config/env only.
- **Visual/structured references are HTML, not markdown** — anything whose value is visual (a design
  system, an architecture diagram, a side-by-side option comparison) belongs in a self-contained
  `.html` artifact both the agent *and* a human can render, not a wall of markdown. Prose references
  stay markdown. (`/prototype` is the skill that emits these.)

## Where stack-specific rules go

Per-technology best practices (framework versions, breaking changes, deprecated patterns) live in
`.claude/rules/stack/*.md`, generated per project — see `rules/stack/README.md`.
