---
name: code-review
description: Review changes on two axes — standards and spec — plus refactoring smells. Use after implementing, ideally in fresh context.
---

# code-review

Review the diff in **fresh context** (don't trust the session that wrote it). Two parallel axes:

1. **Standards** — does it follow `.claude/rules/coding-standards.md` and the stack rules?
2. **Spec** — does it faithfully implement the originating ticket/spec? Anything missing or extra?

Then sweep for **refactoring smells** (see `reference/fowler-smells.md`) — name each one you find;
the name carries the fix.

Then sweep for **performance smells** (see `reference/perf-smells.md`) — N+1 queries, missing
indexes, unbounded/over-fetching queries, missing pagination, blocking I/O on the hot path. Static
perf review here; `/benchmark` measures the running system against the NFR targets.

Report findings grouped by axis, each with a file:line and a concrete fix. Do not rewrite silently
— propose, let the author confirm. Verification is receipts, not "looks good to me."
