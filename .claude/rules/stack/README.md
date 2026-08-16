# Stack rules (generated per project)

One file per technology in the stack (`django.md`, `nextjs.md`, `supabase.md`, ...), holding
**current** best practices, breaking changes, and deprecated patterns — because a model's training
data may be stale.

## How to generate

For each technology in use:
1. Pull the latest docs via **Context7** (or the official docs) for the exact version in
   `package.json` / `pyproject.toml` / lockfile.
2. Write `<tech>.md` with: current idioms, breaking changes since the last major, deprecated
   patterns to avoid, and the project's chosen conventions for that tech.
3. **Timestamp** the file (generated date + version covered) so staleness is visible.

Regenerate when you bump a major version. These files are read at review and planning time.

> Not committed to the harness template — they're project-specific. Generate on first setup.
