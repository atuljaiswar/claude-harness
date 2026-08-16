# Eval anatomy & grader types

## Anatomy
- **Task** — one unit: inputs + success criteria.
- **Trial** — one attempt (run several; outputs vary).
- **Grader** — scoring logic / assertions over the transcript.
- **Transcript / trace** — full record: outputs, tool calls, reasoning.
- **Outcome** — final environment state (DB row written, not just "done").
- **Eval harness** — runs it end-to-end; measures the **agent harness + model together**.
- **Suite** — tasks grouped by capability.

## Grader types
- **Code-based** — regex/binary/static-analysis/outcome/tool-call. Fast, cheap, objective, brittle.
  *Coding-agent backbone: unit tests pass/fail.*
- **Model-based (LLM judge)** — rubric/pairwise/reference. Flexible, nuanced; non-deterministic,
  **must be calibrated** against humans (grade same examples → compare → refine → repeat).
- **Human** — SME/spot-check/A-B. Gold standard; slow. For calibration, edge cases, sampling.

## Metrics
- **pass@k** — P(≥1 success in k); rises with k; use when one success suffices.
- **pass^k** — P(all k succeed); falls with k; use for reliability-critical, customer-facing work.

## Capability vs regression
- **Capability** — "what can it do well?" starts at low pass rates, targets weaknesses.
- **Regression** — "does it still work?" holds ~100%; a score drop signals breakage.
- Capability evals graduate to regression after launch/optimization.
