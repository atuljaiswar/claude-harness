---
name: pragmatic-programmer
description: "Actionable software-craftsmanship principles distilled from The Pragmatic Programmer (Thomas & Hunt, 100 Tips). Use while designing, coding, reviewing, or refactoring to make decisions the pragmatic way — ETC, DRY, decoupling, test-first, crash-early, small steps, dig-for-requirements, automate-everything. Load it when writing or reviewing code, shaping a design, or tightening a dev harness."
---

# Pragmatic Programmer — Working Principles

Distilled from *The Pragmatic Programmer, 20th Anniversary Edition* (David Thomas & Andrew Hunt), 100 Tips. This is a **decision aid for building software**, not a summary. When a choice comes up, apply the rule; when you review code, use the smells.

## The one question that settles most design choices
**"Which option is Easier To Change (ETC)?"** → pick that one (Tip 14). Nearly every other principle below is a special case of ETC. When two designs both work, this breaks the tie.

## Decision rules — when X, do Y, because Z
| When you… | Do this | Because |
|---|---|---|
| Face two designs that both work | Pick the one **easier to change** | ETC is the value under all good design (Tip 14) |
| See the same *knowledge* in 2+ places | One authoritative source; derive the rest | Duplicated knowledge drifts → bugs. DRY is about knowledge, not text (Tip 15) |
| Spot a small defect/hack | Fix it now, or board it up with a tracked `FIXME` | Broken windows signal neglect → entropy compounds (Tip 5) |
| Report a failure | 1 sentence of what happened + 2–3 options + a recommendation | Options move it forward; excuses dead-end it (Tip 4) |
| Build something new & uncertain | Fire a **tracer bullet**: thin, real, end-to-end, kept | Finds integration problems early; gives visible progress (Tip 20) |
| Face a risky unknown | **Prototype** it (throwaway), keep the *lesson*, discard the code | Answer the question cheaply, don't ship the clay model (Tip 21) |
| Two modules must touch | Decouple: **Tell, Don't Ask**; no `a.b().c().d()` train wrecks | Localizes change; shrinks blast radius (Tips 44–46) |
| Hit an "impossible" condition | **Crash early**, loudly | Dead < crippled-and-lying with corrupt state (Tip 38) |
| Believe "this can never happen" | **Assert** it (only the truly impossible; handle the expected) | An executable check beats a comment that rots (Tip 39) |
| Write a new function | Write its **test / first call first** | If it's hard to test, it's badly designed — testable = decoupled (Tips 66–69) |
| A value varies by env/customer/time | Push it to **external configuration**, behind an API | Change behavior without a redeploy (Tip 55) |
| A business rule might change | Store it as **metadata/config**, not hard-coded `if`s | Change becomes a data edit, not a deploy (Tip 79) |
| Reach for **inheritance** | Prefer interface + composition ("has-a" > "is-a") | Inheritance taxes you with coupling & rigidity (Tips 51–53) |
| Share mutable state across threads | **Eliminate** the sharing (immutable / actors), don't just lock it | "Shared state is incorrect state" (Tip 57) |
| A problem feels impossible | Find the **false constraint**; list every "must", explain it aloud | You usually invented the wall (Tip 81) |
| Gather requirements | **Dig** — ask "why" past the stated request; no one knows exactly what they want | Users hand you solutions, not needs (Tips 75–77) |
| Anything must run the same way every time | **Automate** it — no manual procedures | Humans are unreliable at repetition (Tip 95) |
| Take a big leap | Take **small steps**, verify, then continue | Don't outrun your headlights; small blast radius (Tips 42–43) |

## Tells & smells — fast heuristics for review
- **Intermittent / "flaky" / unreproducible bug** → suspect a **concurrency race** on shared state (Tip 58).
- **A bug "went away" and nobody knows why** → not fixed; you're **programming by coincidence** — dig until you know *why* it works (Tip 62).
- **A change here forces a change there** → hidden **coupling** / non-orthogonality (Tips 17, 44).
- **`order.getX().getY().getZ()` chains** → hard-wired object graph; Law of Demeter violation (Tip 46).
- **Ask-then-act** (pull fields out, decide externally, push back) → move behavior into the object (Tell, Don't Ask, Tip 45).
- **A name that no longer tells the truth** → rename *now*; a lying name is worse than a vague one (Tip 74).
- **Nested loop over the same growing data** → likely **O(n²)**; fine at 100, melts at 1,000,000 (Tips 63–64).
- **Reluctance / unease you can't name** → listen to it; investigate before proceeding (Tip 61).
- **"Famous company does it, so we will"** → cargo cult; ask *why* it works *here* first (Tip 87).
- **"We installed Agile"** → agile is a verb (small steps + feedback + adjust); a frozen process isn't agile (Tip 83).
- **"Done" = it works on my machine** → done = all tests pass automatically, users delighted (Tips 91, 96).

## Defaults the book commits to
- **Version control**: always, everything, every project — even solo (Tip 28). Drive builds/tests/releases off commits (Tip 89).
- **Testing**: early, often, **automatically**; the test is your code's first user (Tips 66–67, 90).
- **Refactoring**: early and often, small steps, tests green between each, **never** mixed with feature changes (Tip 65).
- **Estimates**: answer in **ranges + units that reveal uncertainty**; iterate the estimate with the code (Tips 23–24).
- **Security**: minimize attack surface, validate all input at the boundary, least privilege, patch fast, don't roll your own crypto (Tips 72–73).
- **Plain text**: keep knowledge in human-readable, tool-agnostic formats — diffable, greppable, future-proof (Tip 25).

## The prototype vs. tracer-bullet trap (don't confuse them)
| | Prototype | Tracer bullet |
|---|---|---|
| Code | Throwaway | Production-grade |
| Fate | Discarded | Kept & grown |
| Scope | One narrow risky question | Thin slice through *all* layers |
| Deliverable | A lesson | The system's skeleton |

## Assertion vs. exception (what catches what)
- **Assertion** → the *impossible* (broken invariant / programmer error). Often disabled in prod — never rely on it for real errors.
- **Exception / error handling** → the *expected-but-abnormal* (bad input, I/O failure, network blip).

## The spirit (the bookend)
Tip 1 **Care About Your Craft** → Tip 3 **You Have Agency** → … → Tip 100 **It's Your Life.** Everything between is that attitude made concrete: take responsibility, keep the system healthy, understand *why* your code works, design for change, automate the repeatable, and build things you'd be proud to sign (Tip 97).

---
*Source: The Pragmatic Programmer, 20th Anniversary Edition — synthesized principles, not the book's text. A 53-lesson story course of the same material lives in the atul-wiki vault (`3 Resources/Lessons/Pragmatic Programmer/`).*
