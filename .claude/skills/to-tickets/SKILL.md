---
name: to-tickets
description: Slice a spec into buildable tickets. Use after /to-spec, before the inner build loop.
---

# to-tickets

Cut the spec into tickets, then map dependencies.

## Rules

- **Vertical slice, not layer.** Each ticket is a thin **end-to-end feature** (data + logic + UI
  together), independently testable — never "all the DB, then all the API". Nothing should be
  undemoable until every layer lands.
- **One agent session per ticket.** Size each so it fits one focused conversation (avoid context rot).
- Map **dependencies** and what can run in **parallel**; note the order.
- Each ticket states its own **acceptance criteria** (what "done" looks like, testably).
- **Carry REQ-IDs.** Each acceptance criterion traces to one or more requirements in
  `docs/requirements/registry.md`. If a requirement has no ID yet, add its row now
  (`REQ-<MODULE>-<NN>`, append-only); then **list the ticket's REQ-IDs in the ticket**. These IDs
  become the `[REQ-xxx]` test-title tags in `/tdd` and feed `/test-report`'s coverage join. A ticket
  that touches a requirement with no REQ-ID is not ready — register it first. See
  `.claude/rules/testing-doctrine.md` § Traceability & reporting.

Output: a list of tickets (markdown files, GitHub issues, or Jira — match the repo). Each ticket is
the input to one inner loop: `/prime` → `/plan` → `/implement`.
