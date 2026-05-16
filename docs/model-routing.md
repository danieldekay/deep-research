# Model Routing for GH Copilot Subagents

This guide explains how GitHub Copilot routes models to subagents in the deep-research pipeline and why the model assignments in each `.agent.md` file are set the way they are.

---

## 1. The Ceiling Rule

When you invoke an agent in Copilot (VS Code agent mode or Copilot CLI), the model you select for that invocation sets a **ceiling** for all subagents it spawns.

> **A subagent cannot use a model with a higher premium multiplier than the orchestrator model used to start the session.**

If the ceiling is exceeded, Copilot silently falls back to the highest-allowed model — no error is raised. This means:

- Invoke `orchestrator` with `GPT-4.5` (1x) → `synthesize-narrative` falls back from Opus to a ≤1x model, producing lower-quality output.
- Invoke `orchestrator` with `Claude Sonnet 4.6` (3x) → all subagents up to 3x (Sonnet, Opus) run as declared.

**Always start your session using the orchestrator agent.** The model you select for the orchestrator call is the model ceiling for the entire pipeline run.

---

## 2. Premium Multiplier Reference

| Model | Approx. Multiplier | Notes |
|---|---|---|
| Claude Haiku 4.5 | 0.33x | Cheapest Claude tier |
| GPT-4.5 nano | 0.33x | Cheapest GPT tier |
| GPT-4.5 | 1x | Standard GPT tier |
| Claude Haiku (older) | 1x | |
| Claude Sonnet 4.6 | 3x | Mid-tier, good reasoning |
| Claude Opus 4.6 | 3x | Highest reasoning, same tier as Sonnet 4.6 |

> Multipliers are approximate and subject to change. The key ordering is: Haiku < Sonnet ≈ Opus at their respective generations.

---

## 3. Pipeline Model Assignments

| Agent | Model | Rationale |
|---|---|---|
| `orchestrator` | Claude Sonnet 4.6 | **Sets the 3x ceiling** for all subagents |
| `gather-web` | Claude Haiku 4.5 | Mechanical I/O — search + write file |
| `gather-scholar` | Claude Haiku 4.5 | Mechanical I/O |
| `gather-codebase` | Claude Haiku 4.5 | Mechanical I/O |
| `gather-knowledge` | Claude Haiku 4.5 | Mechanical I/O |
| `gather-bookmarks` | Claude Haiku 4.5 | Mechanical I/O |
| `gather-pdf` | Claude Haiku 4.5 | Mechanical download + file ops |
| `explore-knowledge` | Claude Sonnet 4.6 | Zettelkasten traversal + linking |
| `process` | Claude Haiku 4.5 | Dedup + tier-rating, no deep reasoning |
| `extract` | Claude Sonnet 4.6 | Structured deep-reading (Keshav 3-pass) |
| `evaluate-evidence` | Claude Sonnet 4.6 | Claims map + contradiction detection |
| `evaluate-factcheck` | Claude Sonnet 4.6 | CRAAP scoring + fact-check verdicts |
| `cite` | Claude Haiku 4.5 | Mechanical BibTeX generation |
| `synthesize-brief` | Claude Sonnet 4.6 | Executive summary writing |
| `synthesize-narrative` | Claude Opus 4.6 | Most reasoning-heavy; ≤3x ceiling ✓ |
| `synthesize-forward` | Claude Sonnet 4.6 | Hypotheses + open questions |
| `capture-knowledge` | Claude Haiku 4.5 | Mechanical Zettelkasten writes |
| `capture-bookmarks` | Claude Haiku 4.5 | Mechanical bookmark API calls |

Model assignments can be overridden in `config.toml` under `[models]` without editing agent files.

---

## 4. How to Invoke

```
@workspace /agent orchestrator <your research question>
```

Select **Claude Sonnet 4.6** (or higher) for the orchestrator call. This unlocks:
- `synthesize-narrative` → Claude Opus 4.6
- All Sonnet-tier agents → Claude Sonnet 4.6
- All Haiku-tier agents → Claude Haiku 4.5

If you select a 1x model for the orchestrator, `synthesize-narrative` silently downgrades — you will still get output, but with less reasoning depth.

---

## 5. Auto Model Selection Caveat

Copilot's **auto** model selection excludes premium (>1x) models unless your subscription includes them. If you're on a base plan, `auto` resolves to a ≤1x model, causing the Sonnet/Opus agents to silently fall back.

Explicit `model:` declarations in `.agent.md` give you full control and bypass this ambiguity. Always prefer explicit model declarations for production pipelines.

---

## 6. State Management Note

Agent context is **ephemeral** — each subagent starts with a blank context window. No model "remembers" what a previous subagent did.

All pipeline state must be written to files. This pipeline uses:

- `state.md` — lightweight IPC file updated after each phase
- `log.md` — phase execution log
- `sources/`, `extractions/`, `evidence/` — per-phase artifact folders

See `config.toml` for pipeline settings and gate thresholds, and `docs/architecture.md` for the session folder tree.
