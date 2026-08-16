---
name: tooling-survey
description: Phase 0 — survey publicly available tools/frameworks/skills relevant to the project domain and synthesize a combined best-practice approach. Use after stack rules are generated, before BRD.
---

# tooling-survey

Before gathering requirements, survey the landscape for the project's domain.

## Steps

1. From the source material (transcripts, docs, brief), identify the **domain, tools, and
   methodology** it references or implies.
2. Search online (use the `researcher` agent) for publicly available **analysis tools, frameworks,
   or Claude/Codex skills** relevant to that domain.
3. **Do not commit to one source's approach.** Pull the best practice from each candidate and
   **synthesize a combined approach**.
4. Log the survey to `docs/00-tooling-survey.md`: each candidate tool/skill, and **why it was kept
   or discarded**.

## Exit criteria

- [ ] `docs/00-tooling-survey.md` exists with candidates + keep/discard rationale
- [ ] A synthesized approach is stated (not a single copied source)

Prerequisite: `.claude/rules/stack/*.md` generated for every technology (Context7, timestamped).
Do not proceed to `/brd` until stack rules exist.
