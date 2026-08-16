---
name: retro
description: Turn a failure into harness infrastructure so the same class of failure gets harder to repeat. Use after a bug, a bad run, or a repeated correction.
---

# retro

The harness should compound. Don't just explain the incident — change the system.

## Diagnose: which layer ran out of road?

Instruction · context · memory · tool schema · execution environment · durable state ·
orchestration · delegation · skill · verification · trace · learning. Name the layer that failed.

## Convert the failure into infrastructure

| Failure | Fix |
|---|---|
| Repeated context miss | a retrieval/priming rule or a `facts.md` entry |
| Bad tool result | a stricter schema / validation |
| Dangerous command seen | a permission gate in `settings.json` |
| Missed edge case | a new eval task / test |
| Recurring correction | a memory (`decisions.md`) or a leading word in a skill |
| Repeated workflow | a new skill (`/write-skill`) |

Make exactly one durable change and note it in `.claude/memory/decisions.md`. The point isn't a
perfect run once — it's that the next run starts from a better place.
