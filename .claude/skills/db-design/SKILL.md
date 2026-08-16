---
name: db-design
description: Phase 3 — design the database with normalization, indexing, FK and rollback strategy, plus an ER diagram. Use after /architecture.
---

# db-design

Design the schema against the architecture decisions and current ORM practices.

## Steps

1. Apply normalization: **3NF baseline**; denormalize only with **documented justification**.
   Cross-check against the current ORM version's practices (from `.claude/rules/stack/*.md` / Context7).
2. Produce `docs/db-design-checklist.md`: naming conventions, indexing strategy, foreign-key
   strategy, migration strategy, and a **generic rollback plan** for schema changes
   (feature-flag or expand/contract pattern — not a one-off).
3. Write `docs/03-database.md` with a **mermaid `erDiagram`**.

## Exit criteria

- [ ] Every table has a documented **primary/foreign key rationale**
- [ ] **Indexing strategy** documented for every high-read table
- [ ] **Rollback strategy** documented for every migration

Hand off to `/backend-design`.
