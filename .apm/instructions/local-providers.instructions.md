---
applyTo: "**/*.agent.md"
---

# Local Provider Tools

When `config.toml [models]` contains entries starting with `ollama:`, `lmstudio:`,
or `mlx:`, the following local tools are available. Use them **instead of** cloud
API calls for all LLM inference, web search, and reference lookups.

## LLM Inference

Do **not** make direct API calls — the harness routes your model calls via the
active MCP. The `model:` frontmatter on each agent is read by the orchestrator
and passed to the correct local endpoint:

| Config prefix | MCP tool | Endpoint |
|---------------|----------|----------|
| `ollama:*` | `ollama_chat` | `http://localhost:11434/api/chat` |
| `lmstudio:*` | `lmstudio_chat` | `http://localhost:1234/v1/chat/completions` |
| `mlx:*` | `mlx_generate` | `http://localhost:8080/v1/chat/completions` |

## Web Search (gather-web)

When `config.toml providers.web.provider = "searxng"`, use `searxng_search`
instead of `tavily_search`:

```
searxng_search(query, categories=["general","science"], language="en")
```

SearXNG runs at `http://localhost:8888`. It is self-hosted and returns no
tracking or rate-limit restrictions.

## Reference / Scholar Search (gather-scholar)

When `config.toml providers.scholar.provider = "zotero"`, use Zotero tools:

```
zotero_search(query, limit=20)         → returns items with metadata
zotero_export_bibtex(item_keys=[...])  → returns .bib content for cite agent
```

The `cite` agent should call `zotero_export_bibtex` for all matched items and
merge the result into `references/citations.bib`.

## Provider Detection

At startup, read `config.toml [models].orchestrator`. If it starts with
`ollama:`, `lmstudio:`, or `mlx:`, you are in a local-provider session.
Check `state.md flags.providers_verified = true` before proceeding — if not
set, the orchestrator should have run `check-providers.sh` first.
