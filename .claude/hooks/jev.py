#!/usr/bin/env python3
"""Ask Jev (TypeSafe's decision model) typed questions via TypeSafe's native API.

Shared by every Jev hook and skill in this pack. Standard library only.

    from jev import ask
    answers = ask("some state", {"risky": {"type": "boolean", "instructions": "Is this risky?"}})
    # {"risky": {"type": "noul", "noul": 0.93, "probability": 0.93}}  or  None on failure

This harness talks to TypeSafe's **native System One endpoint**, not the Vercel AI
Gateway the upstream pack shipped with (our key is a native `apikey_...`). Two shapes
differ, so this client adapts both and the hooks/skills stay unchanged:
  - outbound: a question of `type: "boolean"` is sent as the native `type: "noul"`.
  - inbound: a `noul` answer is mirrored into `probability`, so `probability()`
    and every caller keep working.
`choice` and `score` answers already match the native shape and pass through.

Fails open: on a missing key, timeout, HTTP error or bad response it returns None,
so a hook that gets None must let the action through. A hiccup never blocks Claude.

Env:
    TYPESAFE_API_KEY    required (falls back to JEV_TYPESAFE_API_KEY, then the
                        Vercel gateway vars AI_GATEWAY_API_KEY / AI_GATEWAY_KEY)
    JEV_URL             default https://api.typesafe.ai/v1/systemone
    JEV_MODEL           default jev-latest
    JEV_TIMEOUT         seconds, default 3
    JEV_LOG             optional path; one JSON line per call (latency, cost, error)
"""
import json
import os
import sys
import time
import urllib.error
import urllib.request

DEFAULT_URL = "https://api.typesafe.ai/v1/systemone"

# Jev reads at most ~32k tokens of state; stay well under it (~4 chars per token).
MAX_STATE_CHARS = 100_000


def _to_native_questions(questions):
    """Map the pack's `boolean` question type to the native `noul` type.

    Callers (hooks/skills) write `{"type": "boolean", ...}`; the native API calls
    the same thing `noul`. Everything else (choice, score, already-noul) is left as is.
    """
    out = {}
    for name, q in (questions or {}).items():
        if isinstance(q, dict) and q.get("type") == "boolean":
            q = {**q, "type": "noul"}
        out[name] = q
    return out


def _normalize_answers(answers):
    """Mirror each native `noul` answer into `probability` so `probability()` works."""
    for a in (answers or {}).values():
        if isinstance(a, dict) and "noul" in a and "probability" not in a:
            n = a.get("noul")
            if isinstance(n, (int, float)):
                a["probability"] = float(n)
    return answers


def _log(entry):
    path = os.environ.get("JEV_LOG")
    if not path:
        return
    try:
        with open(path, "a") as f:
            f.write(json.dumps(entry) + "\n")
    except OSError:
        pass


def ask(state, questions, timeout=None):
    key = (
        os.environ.get("TYPESAFE_API_KEY")
        or os.environ.get("JEV_TYPESAFE_API_KEY")
        or os.environ.get("AI_GATEWAY_API_KEY")
        or os.environ.get("AI_GATEWAY_KEY", "")
    ).strip()
    if not key:
        _log({"error": "TYPESAFE_API_KEY not set"})
        return None
    if isinstance(state, str) and len(state) > MAX_STATE_CHARS:
        state = state[:MAX_STATE_CHARS]
    body = json.dumps({
        "model": os.environ.get("JEV_MODEL", "jev-latest"),
        "state": state,
        "questions": _to_native_questions(questions),
    }).encode()
    req = urllib.request.Request(
        os.environ.get("JEV_URL", DEFAULT_URL),
        data=body,
        headers={"Authorization": "Bearer " + key, "Content-Type": "application/json"},
        method="POST",
    )
    started = time.time()
    # Hooks default to no retries (fail open fast). Batch scripts can set JEV_RETRIES
    # to ride out Gateway 429s ("upstream provider is experiencing high demand").
    retries = int(os.environ.get("JEV_RETRIES", "0"))
    try:
        for attempt in range(retries + 1):
            try:
                with urllib.request.urlopen(req, timeout=timeout or float(os.environ.get("JEV_TIMEOUT", "3"))) as resp:
                    data = json.loads(resp.read())
                break
            except urllib.error.HTTPError as e:
                if e.code != 429 or attempt == retries:
                    raise
                _log({"retry": attempt + 1, "status": 429})
                time.sleep(min(10 * (attempt + 1), 45))
        answers = data.get("answers")
        if not isinstance(answers, dict):
            raise ValueError("no answers in response")
        # Native cost lives under usage; keep the gateway path as a fallback.
        cost = (
            ((data.get("providerMetadata") or {}).get("gateway") or {}).get("cost")
            or (data.get("usage") or {}).get("input_tokens")
        )
        _log({"ms": int((time.time() - started) * 1000), "questions": len(questions), "cost": cost})
        return _normalize_answers(answers)
    except (urllib.error.URLError, OSError, ValueError, json.JSONDecodeError) as e:
        _log({"ms": int((time.time() - started) * 1000), "error": str(e)[:200]})
        return None


def probability(answers, name):
    """Probability of a boolean answer, or None if missing."""
    a = (answers or {}).get(name) or {}
    p = a.get("probability")
    return float(p) if isinstance(p, (int, float)) else None


def choice(answers, name):
    """(picked option, its probability) for a choice answer, or (None, None)."""
    a = (answers or {}).get(name) or {}
    picked = a.get("choice")
    probs = a.get("probabilities") or {}
    return picked, probs.get(picked)


if __name__ == "__main__":
    # Smoke test: python3 .claude/hooks/jev.py "state text" "yes/no question"
    state = sys.argv[1] if len(sys.argv) > 1 else "A regular user tried to open the admin settings page."
    question = sys.argv[2] if len(sys.argv) > 2 else "Should this be allowed?"
    print(json.dumps(ask(state, {"q": {"type": "boolean", "instructions": question}}), indent=2))
