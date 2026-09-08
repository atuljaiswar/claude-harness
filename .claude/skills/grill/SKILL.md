---
name: grill
description: Relentlessly interview the user to reach shared understanding before any planning. Use at the start of a feature, when requirements are vague, or when the agent is tempted to assume.
---

# grill

Interview the user until you reach **shared understanding**. Do not plan or code yet.

## Rules

1. **Relentlessly** — keep asking until nothing important is undecided.
2. **One branch at a time** — follow the decision tree down one path; don't scatter across topics.
3. **One question at a time** — ask, wait for the answer, then ask the next. Multiple questions at once is bewildering.
4. **Recommend one** — never a blank question; give options and *your* recommendation with a reason.
5. **Facts vs decisions** — *facts* you find yourself (explore the code); *decisions* only the user can make. Don't grill yourself over facts.
6. **Do not act** — do not enact anything until the user confirms shared understanding is reached.

## Decompose before you finish

Before declaring done, sweep the edges: empty / one / many; invalid / boundary; concurrency;
state transitions; failure paths; **access control**. Confirm the **role/access model** and the
**data model** explicitly — these cause the most rework when assumed.

## Escalate words → a drivable prototype when the model is risky

Words are a weak gate for a model the user can't picture. When a decision survives grilling but is
still **high-risk** — a non-trivial state machine, a multi-role / contested access model,
concurrency or ordering that matters, or the user is **hedging** ("I think…") — don't settle it in
prose. Run `/prototype` (LOGIC branch): a 10-minute drivable HTML demo the user *clicks through* to
catch the wrong assumption before it's built. Don't prototype every requirement — reserve it for the
few that would be expensive to get wrong (respects the time budget).

Output when confirmed: a short bullet list of the settled decisions. Hand off to `/to-spec`.
