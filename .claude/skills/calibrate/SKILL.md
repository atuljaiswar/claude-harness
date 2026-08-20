---
name: calibrate
description: End-of-session sweep — fold what was learned this session back into the harness (skills, CLAUDE.md, rules, memory), routed through a three-bucket risk gate. Use when wrapping up a working session, or after several corrections.
---

# calibrate

The harness should get better every session, not just after failures. Where `/retro` converts **one
failure** into **one** durable fix, `/calibrate` reviews the **whole session** and proposes **many**
improvements at once — then gates each by risk so you approve only what matters. This is the
self-improving loop; full-auto drifts, review-everything never gets done, so we **bucket**.

## Steps

1. **Review the session.** Read back the conversation for signal: repeated corrections, a workaround
   you had to explain twice, a preference you stated, a skill that under- or over-fired, a fact about
   the codebase worth remembering, a rule that was wrong or missing.
2. **Draft candidate changes**, each targeting exactly one home:
   - a **skill** (`.claude/skills/*/SKILL.md`) — steering, a leading word, a missing step
   - **CLAUDE.md** — only if it's a routing/non-negotiable change (keep it thin — pointer, not prose)
   - **`.claude/rules/`** — a coding standard or stack rule
   - **memory** — `facts.md` (a standing fact), `decisions.md` (an ADR-style choice), or a
     `sessions/YYYY-MM-DD-*.md` episodic note
3. **Bucket each change by _risk to output quality_** (table below).
4. **Apply bucket 1 silently**, appending each to `.claude/memory/calibrate-log.md` (date + one line).
5. **Write buckets 2 & 3** to `.claude/memory/review/<YYYY-MM-DD>.md` — one entry per change with a
   checkbox: `[ ] approve  [ ] reject  [ ] approve-and-don't-ask-again` and the exact diff/target.
6. **Summarize**: N auto-applied, M awaiting your sign-off, K need more context. Point at the review
   file. Stop — do **not** enact buckets 2/3 until Atul checks the boxes.

## The three buckets

| Bucket | Risk | Examples | Handling |
|---|---|---|---|
| **1 · auto-approve** | low | fix a broken wikilink/path, delete a duplicated line, add a `facts.md` entry, tighten a typo in a description | apply now, log it |
| **2 · needs sign-off** | high | new skill, edit a rubric/scale, change a CLAUDE.md non-negotiable, alter a coding standard | write to review file, wait |
| **3 · more context** | unknown | a correction whose root cause is unclear; two plausible fixes | write to review file with the open question |

Bucket boundary = *would a wrong choice here degrade future output?* If yes, it's 2 or 3.

## Guardrails

- **One change, one home** — don't state the same fact in a skill *and* memory (single source of truth).
- **Forgetting is hygiene** — on a conflict, update the current fact and mark the old superseded
  (see `.claude/memory/README.md`); never store two contradictory facts as equals.
- **Compress feedback loops** — if you already fixed an output by hand this session, the skill that
  produced it is a prime bucket-2 candidate: "improve this skill based on what we just did."
- Model-invocable is fine, but this is best **user-invoked at session end**; consider a routine only
  after it's earned trust (see `/retro` for the reactive path).
