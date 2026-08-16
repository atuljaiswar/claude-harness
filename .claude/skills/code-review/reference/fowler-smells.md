# Refactoring smells (Martin Fowler)

These terms are deep in the model's priors — naming one invokes the whole fix. One line each is
enough; watch the reasoning trace repeat the name back.

- **Mysterious name** — a name that doesn't say what it does.
- **Duplicated code** — same structure in more than one place.
- **Long function / large class** — doing too much; split by responsibility.
- **Shotgun surgery** — one change forces edits in many places (e.g. a color changed in 6 files).
- **Divergent change** — one module changed for many unrelated reasons.
- **Feature envy** — logic lives in the wrong file, reaching into another's data.
- **Data clumps** — the same group of fields travels together; make it a type.
- **Primitive obsession** — primitives where a small domain type belongs.
- **Repeated switches** — the same switch/if-chain duplicated; polymorphism or a map.
- **Message chains** — `a.b().c().d()`; hide the navigation.
- **Middle man** — a class that only delegates.
- **Speculative generality** — abstraction for a need that doesn't exist yet.
