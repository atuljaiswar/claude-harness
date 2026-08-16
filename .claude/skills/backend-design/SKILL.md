---
name: backend-design
description: Phase 4 — define API contracts, service boundaries, and auth per endpoint, with sequence diagrams. Use after /db-design.
---

# backend-design

Specify the backend surface precisely enough to build and test against.

## Steps

1. **API contracts** — endpoints, request/response schemas, and **error formats** for each.
2. **Service boundaries** — internal vs external API distinction; where the seams are.
3. **Auth/authz per endpoint** — explicitly mark each as **public / authenticated / role-gated**.
   (The UI must not leak structure the API gates — see `security-reviewer`.)
4. Write `docs/04-backend.md` with a **mermaid sequence diagram** for each core flow.

## Exit criteria

- [ ] Every endpoint has a documented **error-response contract**
- [ ] Auth/authz strategy is **explicit per endpoint** (public / authenticated / role-gated)

These contracts are the blind input Codex gets in Phase 7 — keep them complete and code-free.
Hand off to `/nfr`.
