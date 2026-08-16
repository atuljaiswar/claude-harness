# Performance smells (flag these in review)

Static perf review — caught by reading the diff, before `/benchmark` measures the running system.
Name each one found; the name carries the fix.

- **N+1 query** — a query inside a loop; should be one batched/joined query or a preload.
- **Missing index** — a filter/sort/join on a column with no index (cross-check `/db-design`).
- **Unbounded query** — `SELECT *` / fetch-all with no `LIMIT` or pagination; grows with data.
- **Missing pagination** — list endpoints returning everything; page or cursor them.
- **Over-fetching** — pulling columns/relations the caller doesn't use.
- **Blocking I/O on the hot path** — sync network/disk in a request handler; make it async or move it off-path.
- **Chatty calls** — many round-trips where one batched call would do (also a message-chain smell).
- **No caching of expensive/repeated work** — recomputing or re-fetching identical results per request.
- **Unbounded memory** — loading a whole file/result set into memory instead of streaming.
- **Serial where parallel is safe** — independent awaits run one-by-one instead of concurrently.
- **Missing connection pooling** — opening a new DB/HTTP connection per request.

If a smell maps to an NFR target, hand it to `/benchmark` to confirm impact, then `/plan` to fix.
