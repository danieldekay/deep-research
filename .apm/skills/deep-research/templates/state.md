# Session State — {slug}

> **IPC contract.** Written by orchestrator at startup. Each worker agent reads this file
> at startup (question, output_dir, active_tracks, token_remaining) then writes a single
> status update to its own phase section on completion.
> Orchestrator reads after each phase to decide: proceed / retry / escalate.

## Research Question

{question}

## Session

```
question:   {question}
date:       {date}
slug:       {slug}
output_dir: {output_dir}
```

## Token Budget

```
limit:     {max_tokens}
used:      0
remaining: {max_tokens}
warn_at:   {warn_tokens}
```

## Phase 1 — Gather

```
gate_signal: pending          # pending | ready | failed
```

| Track      | Enabled    | Status  | Sources | Notes |
|------------|------------|---------|---------|-------|
| web        | {web}      | pending | —       |       |
| scholar    | {scholar}  | pending | —       |       |
| codebase   | {codebase} | pending | —       |       |
| knowledge  | {knowledge}| pending | —       |       |
| bookmarks  | {bookmarks}| pending | —       |       |
| pdf        | {pdf}      | pending | —       |       |

## Phase 2 — Process

```
status:         pending       # pending | done | failed
sources_total:  —
sources_t1_t2:  —
gate_signal:    pending
```

## Phase 3 — Extract

```
status:      pending
extracted:   —
gate_signal: pending
```

## Phase 4 — Evaluate

```
gate_signal: pending
```

| Step      | Status  | Notes |
|-----------|---------|-------|
| evidence  | pending |       |
| factcheck | pending |       |
| cite      | pending |       |

## Phase 5 — Synthesize

```
gate_signal: pending
```

| Step      | Status  | Notes |
|-----------|---------|-------|
| brief     | pending |       |
| narrative | pending |       |
| forward   | pending |       |

## Phase 6 — Capture

```
gate_signal: pending
```

| Step      | Status  | Items | Notes |
|-----------|---------|-------|-------|
| knowledge | pending | —     |       |
| bookmarks | pending | —     |       |

## Active Tracks

> Set from config.toml [gather] at session start. Workers read this to confirm they are enabled before running.

```
enabled: [{list}]
```

## Flags

```
skip_tier3_extract: false
brief_only_mode:    false
abort:              false
```

## Last Updated

```
{timestamp} — orchestrator — initialized
```

---

<!-- WORKER UPDATE FORMAT — each agent appends one entry on completion:

{timestamp} — {agent-name} — [{done|failed}]
  field: phases.{phase}.{track|step}.status = done
  field: phases.{phase}.{track|step}.{metric} = {value}
  field: tokens.used = {n}

-->

