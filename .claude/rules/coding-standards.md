# Coding standards (stack-agnostic)

Read at **review time** (by `/code-review` and the code-reviewer agent), not loaded into every
prompt — standards belong here, not in `CLAUDE.md`. Add project-specific rules as they're decided.

## Defaults

- **Deep modules** — many capabilities behind a small interface; one door, not many. Callers see a
  simple surface; complexity is hidden. Prefer this over scattered shallow helpers the agent must
  chase across files.
- **Deletion test** — if removing a function/file leaves all tests passing, it's dead; delete it.
- **Single source of truth** — no duplicated logic or facts; centralize.
- **Names say what they do** — no mysterious names; the name is the first documentation.
- **Errors are explicit** — no silent failures; every failure path is loud and handled.
- **Small, vertical changes** — end-to-end slices, reviewable in one pass.
- **Tests describe behavior** — written against the spec, not retrofitted to the implementation.
- **No secrets in code** — config/env only.

## Where stack-specific rules go

Per-technology best practices (framework versions, breaking changes, deprecated patterns) live in
`.claude/rules/stack/*.md`, generated per project — see `rules/stack/README.md`.
