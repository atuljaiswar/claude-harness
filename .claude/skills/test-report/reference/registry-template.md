# Requirement registry (TEMPLATE)

Scaffold this into each project at **`docs/requirements/registry.md`** on the first `/test-report`
run (or during `/to-tickets`). It is **project-agnostic** — the machinery (`scripts/test-report.mjs`,
the `[REQ-*]` tag convention) is identical across every project; only this table's contents differ.
Copy it into the project, delete the example rows, and fill in that project's real requirements.

The registry is the source of truth for **what this product must do**, one row per requirement, each
with a stable `REQ-ID`. Tests tag themselves with these IDs (`[REQ-AUTH-01]` in the test title);
`/test-report` joins this table to the test run to produce the coverage/regression one-pager.

**Rules**
- IDs are `REQ-<MODULE>-<NN>`, zero-padded. **Permanent and append-only** — never renumber, never
  reuse. To retire a requirement, set its status to `deprecated`; keep the row.
- Seed rows during `/to-spec` → `/to-tickets`. One requirement = one row = one acceptance statement.
- `Added` is the release/version the requirement first shipped in (free "new-since-release" signal).
- `Module` prefixes group related requirements and must match the test-title module tag.

---

<!-- Everything below this line is what gets copied to the project's docs/requirements/registry.md -->

# Requirement registry

<!-- EXAMPLE ROWS — illustrative only. Replace with this project's real requirements. -->

| REQ-ID | Module | Requirement (testable statement) | Priority | Added | Status |
|--------|--------|----------------------------------|----------|-------|--------|
| REQ-XXX-01 | XXX | A clear, testable statement of one requirement. | P0 | v1 | active |
| REQ-XXX-02 | XXX | Another requirement, one row each. | P1 | v1 | active |

<!--
Module codes: pick short uppercase prefixes for YOUR project's modules, e.g.
  AUTH = Authentication,  BILL = Billing,  CART = Shopping cart  (whatever this project has).
IDs are permanent + append-only: never renumber or reuse. Retire with Status = deprecated.
Status values: active | deprecated
-->
