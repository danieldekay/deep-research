# Skills vs Agents — Decision Guide

When building or extending this pipeline, you need to choose between an **Agent Skill** (`SKILL.md`) and an **Agent** (`.agent.md`). They solve different problems.

---

## 1. What a Skill Can Do

An Agent Skill is a `SKILL.md` file loaded by Copilot on-demand when the description semantically matches the user's request. It can contain:

- **Multi-phase step-by-step instructions** — numbered phases with explicit gates, checkpoints, and PAUSE directives
- **Bundled templates, scripts, and reference data** — inline in the SKILL.md or referenced as sibling files
- **Domain knowledge** — calibration tables, scoring rubrics, schema references, example outputs
- **Soft gates** — "PAUSE and show the user the source register before proceeding"

Skills run entirely within a single context window. There is no multi-agent delegation; Copilot follows the instructions as a single agent.

---

## 2. Comparison Table

| Capability | Agent (`.agent.md`) | Skill (`SKILL.md`) |
|---|---|---|
| Multi-agent delegation | **Yes** — spawns named subagents via `runSubagent` | No — single context window only |
| Parallel execution | **Yes** — batch-dispatches multiple subagents | No — sequential only |
| Named persona + tool declarations | **Yes** — `name:`, `model:`, `tools:` frontmatter | No — Copilot decides when to load |
| Hard gates / checkpoints | **Yes** — block on subagent sign-off before next phase | Soft only — PAUSE instructions are advisory |
| State persistence across hops | Via written files (state.md, artifacts) | Via written files (same mechanism) |
| Model ceiling control | **Yes** — explicit `model:` in frontmatter | No — inherits caller's model |
| Max count | Unlimited | 5 per skillset (Extensions API limit) |
| Availability | VS Code agent mode, Copilot CLI, coding agent | VS Code agent mode, Copilot CLI, coding agent (not full Visual Studio) |

---

## 3. Recommended Pattern for This Pipeline

Use a **thin orchestrator agent** that:

1. Sets the model ceiling via `model:` frontmatter
2. Declares the tool scope (`runSubagent`, file I/O, `manage_todo_list`)
3. Contains the dispatch logic (which subagent runs when, gate checks)

Encode heavy pipeline logic — phase instructions, extraction schemas, quality rubrics — in the **Skill** (`deep-research` SKILL.md). The orchestrator agent invokes the skill for complex steps; the skill provides the detailed methodology.

This separation means:
- The skill can be updated without touching agent frontmatter
- The orchestrator stays small and easy to reason about
- The skill can be reused by multiple orchestrator variants

---

## 4. When a Skill Alone Is Enough

If your research flow is **single-agent and sequential** — no parallelism needed, one source type, one synthesis artifact — a Skill with numbered phases is equivalent to the full orchestrator + subagent pipeline.

A well-structured Skill can include:
- Phase 1: gather (sequential web search calls)
- Gate: check source count, PAUSE if below threshold
- Phase 2: process and extract
- Phase 3: evaluate and cite
- Phase 4: synthesize brief + narrative

For quick one-off research tasks, invoking the `deep-research` Skill directly (rather than the full orchestrator) is faster and cheaper — you don't pay for parallel subagent overhead.

Use the full orchestrator pipeline when:
- You need parallel gather across 5 source types simultaneously
- You want hard model-tier control per subagent
- The research question is complex enough to warrant concurrent evaluation tracks

---

## 5. Limits to Know

1. **Subagents cannot spawn subagents** — The pipeline is one level deep. If you write a worker agent that tries to invoke another agent, Copilot will not permit it. All worker logic must be self-contained or encoded in the worker's own instructions/skill.

2. **Context is ephemeral** — Each subagent starts fresh. No model memory persists across subagent hops. Use `state.md` as the shared state store; every agent reads and writes it explicitly.

3. **Agent Skills not available in full Visual Studio** — Skills work in VS Code agent mode, Copilot CLI, and the coding agent. They are not yet available in the full Visual Studio IDE extension.

4. **5 skills per skillset limit** — The Extensions API enforces a maximum of 5 skills per skillset registration. If you are building a package with more than 5 skills, split them into multiple skillsets or consolidate related phases into fewer, broader skills.

5. **Model ceiling is set at invocation time** — Once the orchestrator is called with a specific model, that ceiling applies for the entire session. You cannot upgrade the ceiling mid-pipeline without starting a new session.
