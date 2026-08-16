# Load-testing tools (pick by stack)

| Surface | Tool | Quick invocation |
|---|---|---|
| HTTP API (any) | **autocannon** (node) | `npx autocannon -c 100 -d 30 http://localhost:3000/api/x` |
| HTTP API (scripted scenarios) | **k6** | `k6 run script.js` (define stages/thresholds in JS) |
| Python API | **Locust** | `locust -f locustfile.py --headless -u 100 -r 10 -t 30s` |
| Front-end (Core Web Vitals) | **Lighthouse** | `npx lighthouse <url> --only-categories=performance` |
| Quick one-off | **ApacheBench** | `ab -n 1000 -c 50 http://localhost:3000/` |

## What to capture

- **p50 / p95 / p99 latency** — p95 is the number you grade against (tail latency is what users feel).
- **Throughput** — requests/sec sustained at the target concurrency.
- **Error rate** — non-2xx / timeouts under load (must stay under threshold, e.g. <1%).
- **Breaking point** — the concurrency where latency/error rate blows past target (the bottleneck).

## Setting thresholds (k6 example)

```js
export const options = {
  scenarios: { expected: { executor: 'constant-vus', vus: 100, duration: '30s' } },
  thresholds: {
    http_req_duration: ['p(95)<200'],   // p95 under 200ms — from the NFR target
    http_req_failed:   ['rate<0.01'],   // <1% errors
  },
};
```

k6 exits non-zero if a threshold fails — capture that as a **warning/annotation** (surface it to the
user), not a hard CI failure. Performance is advisory here; don't block the build or the PR on it.

## Notes

- Test against a production-like build/data volume; localhost dev servers lie about performance.
- Warm up before measuring (discard the first few seconds).
- Isolate the run (no other heavy processes) so numbers are comparable across runs.
