# Plan: <ticket title>

## Feature description & user story
<what and for whom>

## Problem statement
<what we're solving>

## Solution statement
<the approach, in prose — no code>

## Out of scope / non-goals
<explicit>

## Context to reference
- Files to touch: <paths>
- Docs/conventions to read: <paths>

## Task-by-task plan
1. <step>
2. <step>

## Validation strategy  ← the most important section
- Unit tests: <what>
- Integration tests: <what>
- Edge cases: <empty/one/many, invalid/boundary, concurrency, failures, access-control>
- Commands (exact): lint `<cmd>` · typecheck `<cmd>` · unit `<cmd>` · integration `<cmd>`
- Manual / browser validation: <how a user would exercise it>
- **Performance budget** (if this touches a hot path): p95 latency target `<Nms>`, throughput
  `<N req/s>`, error rate `<N%>` at expected load — pulled from `docs/non-functional-requirements.md`.
  Verify with `/benchmark`. **Advisory, not a gate:** if unmet, flag the numbers to the user — the
  user decides whether to ship or optimize; it does not block completion.
- Definition of done: <the outcome that must hold — graded, not vibes>
