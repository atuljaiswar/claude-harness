---
name: plan
description: Plan one ticket's implementation, defining the validation strategy before any code. Use after /prime, in the same conversation.
---

# plan

Interview, research, then write a plan whose most important section is the **validation strategy**.

## Steps

1. **Interview** the user on anything ambiguous (Draft-and-Confirm: options + recommendation, one
   at a time). LLMs confidently make terrible assumptions — surface them.
2. **Research** the codebase for the exact files, seams, and docs involved.
3. Write the plan to a markdown file using `reference/plan-template.md`.

## Non-negotiable

**Validation-first.** Define how you'll test **before** writing code — unit/integration tests,
edge cases, and the exact lint/typecheck/test/manual commands. Grade **outcomes, not paths**. Be
specific about the *end* (what "done" and "validated" mean); let implementation build the road.
If the ticket touches a hot path, include a **performance budget** (p95/throughput/error-rate from
the NFR doc) as an exit criterion — verified with `/benchmark`.

No code blocks in the plan — point at the live code. When confirmed, hand off to `/implement` in a
**fresh conversation** (the plan is the only handoff artifact — avoids context rot).
