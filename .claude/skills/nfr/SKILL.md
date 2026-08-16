---
name: nfr
description: Phase 6 — produce the non-functional requirements pass (performance, scalability, SEO/GEO, observability, compliance, token budget). Use after /backend-design.
---

# nfr

Write `docs/non-functional-requirements.md` covering, **per feature**:

- **Performance** — target response times, load expectations.
- **Scalability** — horizontal/vertical scaling plan, bottleneck analysis.
- **SEO** (public pages only) — meta tags, structured data, sitemap, Core Web Vitals targets.
- **GEO** (public pages only, if applicable) — `llms.txt`, structured/clear content for generative
  engines, and an **explicit definition** of what counts as "GEO-optimized" (don't leave it vague).
- **Observability** — logging strategy, monitoring, alerting thresholds. Required **before** calling
  anything "scalable" or "production-ready".
- **Compliance / data privacy** — applicable regulations (e.g. **DPDP Act** if India-facing), data
  retention, PII handling. Mandatory if client-facing/public.
- **Token / context budget** — the rule for when the self-improving knowledge base gets
  summarized/compressed so agent context doesn't bloat over time (see `.claude/memory/README.md`).

## Exit criteria

- [ ] Every feature has each applicable NFR dimension addressed (or explicitly N/A with a reason)
- [ ] Observability defined before any "production-ready" claim
- [ ] Token/context-budget compaction rule stated

Hand off to Phase 7: `/plan` → `/implement`.
