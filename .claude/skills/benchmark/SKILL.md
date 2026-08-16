---
name: benchmark
description: Load-test the running app against the Phase-6 NFR performance/scalability targets and report pass/fail. Use after a feature is built, or to establish/refresh a perf baseline.
---

# benchmark

Prove performance and scalability against the **documented targets** — don't guess. This is the
verification half of the NFR pass: `/nfr` writes the numbers, `/benchmark` measures against them.

## Steps

1. **Read the targets** from `docs/non-functional-requirements.md` (target response times, load
   expectations, scaling plan). If none exist, run `/nfr` first — you can't grade without a target.
2. **Pick a tool by stack** (see `reference/load-tools.md`): `autocannon` or `k6` for HTTP APIs,
   `Locust` for Python, Lighthouse for front-end Core Web Vitals.
3. **Define scenarios**, at minimum:
   - **Baseline** — single user, warm cache: the floor latency.
   - **Expected load** — the Phase-6 load expectation: the number that must pass.
   - **Stress** — ramp until it breaks: this *finds the bottleneck* (the scalability check).
4. **Measure** p50 / **p95** / p99 latency, throughput (req/s), and error rate at expected load.
5. **Grade against targets** (outcomes, not vibes): p95 within target, error rate under threshold at
   expected load, and the stress test's breaking point at/above the scaling target.
6. **Save a baseline** (e.g. `docs/perf-baseline.json`) so `/evals` can hold it as a **regression**
   — a later run that regresses p95 fails.
7. If a target is missed, **name the bottleneck** (DB query, N+1, missing index, blocking I/O,
   single-instance limit) and hand it to `/plan` as the next ticket.

## Exit criteria

- [ ] Every NFR performance target has a **measured result** (p95 + throughput + error rate)
- [ ] p95 within target and error rate under threshold **at expected load**
- [ ] Stress test run; **bottleneck identified** if any target is missed
- [ ] Baseline saved for regression tracking

Perf is an **outcome** — measure the running system, not the code's intentions. Pairs with
`/code-review` (which catches perf smells statically) and `/evals` (which holds the numbers over time).
