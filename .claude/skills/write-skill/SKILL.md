---
name: write-skill
description: Author a new skill or prune an existing one. Use when adding to this harness or when a skill is bloated or not firing right.
---

# write-skill

Write skills that stay small and steer reliably. Four checks:

## 1. Trigger
Decide **user-invoked vs model-invoked**. A `description` in frontmatter lets the model auto-invoke
— but each one costs context load + unpredictability. Add it deliberately; omit it for skills only
a human should call.

## 2. Structure
Two units: **steps** and **reference**. Keep `SKILL.md` **tiny**. Hide branch-specific reference
behind a pointer to a separate file in the skill folder — don't inline what's only sometimes needed.

## 3. Steering
Use **leading words** — dense-meaning terms ("vertical slice", "feature envy") the agent repeats
back and acts on; verify in the reasoning trace. To force more legwork on a phase, split it into its
own skill so the agent sees one step at a time.

## 4. Pruning
Kill **duplication** (one source of truth), **sediment** (stale accreted text), and **no-ops**.
Apply the **deletion test**: remove a line — if behavior is unchanged, it was a no-op; delete it.

Author skills *with* the agent: describe the change, let it draft, then prune.
