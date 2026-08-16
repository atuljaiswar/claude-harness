---
name: to-spec
description: Turn a confirmed set of decisions into a specification. Use after /grill, before /to-tickets.
---

# to-spec

Freeze the shared understanding into a **spec** — the destination, not the route.

## Rules

- **No code blocks.** Agents follow embedded code even when it's stale; a code-free spec forces the
  agent to cross-reference the *live* codebase. Describe behavior and constraints; point at files.
- **Plain editable markdown.** The intelligence is in the conversation and the code; the spec is a
  dumb, correctable artifact.
- Separate **what/why** (problem, users, hypothesis) from **how** (architecture, approach) with
  clear headings — they're different decisions.

## Structure

1. Problem & why it's worth building
2. Users / roles & access model
3. Behavior (functional) + non-functional (perf, security, compliance as relevant)
4. Data model (described, not coded)
5. Out of scope (explicit)
6. Open questions (flag, don't silently assume)

Save where the repo keeps such docs (match existing convention). Hand off to `/to-tickets`.
