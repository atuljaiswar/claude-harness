---
name: prime
description: Load codebase context for the current ticket at the start of an inner loop. Use before /plan in a fresh conversation.
---

# prime

The agent is stupid at the start of a conversation. Load context before planning.

## Steps

1. Read the ticket (if given) so exploration is scoped to what you're about to build.
2. Explore the codebase **through the lens of the ticket**: entry points, the files you'll touch,
   the conventions in that area, existing tests, the run/test/typecheck commands.
3. Read `.claude/memory/facts.md` and `decisions.md` for settled state.
4. Summarize what you found in a few bullets — the relevant seams, not a tour of the whole repo.

Do not plan or code here. Stay in the same conversation and hand off to `/plan`.
