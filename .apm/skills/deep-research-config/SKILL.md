---
name: deep-research-config
description: >
  Local-provider configuration layer for the deep-research pipeline.
  Rewrites model assignments to Ollama / LM Studio / MLX and wires SearXNG
  (local web search) and Zotero (local reference manager) as provider tools.
  Run once at workspace setup, or any time you want to switch provider profiles.
triggers:
  - "use local models"
  - "switch to ollama"
  - "switch to lm studio"
  - "switch to mlx"
  - "local research setup"
  - "offline research"
  - "configure providers"
---

# Deep Research — Local Provider Config

This skill patches `config.toml` and wires local MCP tools so the deep-research
pipeline runs entirely on local infrastructure (no cloud APIs required).

## Supported Provider Profiles

| Profile | LLM backend | Web search | Scholar |
|---------|-------------|------------|---------|
| `ollama` | Ollama (localhost:11434) | SearXNG | Zotero |
| `lmstudio` | LM Studio (localhost:1234, OpenAI-compat) | SearXNG | Zotero |
| `mlx` | MLX-LM (localhost:8080, OpenAI-compat) | SearXNG | Zotero |

## Setup (run once per workspace)

### Step 1: Check providers are running

Run the check script and fix any failures before continuing:

```bash
.apm/skills/deep-research-config/scripts/check-providers.sh
```

Output: a status table. All required services must show `✓ reachable`.

### Step 2: Patch config.toml

Run the patch script with your chosen profile:

```bash
# Choose one:
.apm/skills/deep-research-config/scripts/patch-models.sh --profile ollama
.apm/skills/deep-research-config/scripts/patch-models.sh --profile lmstudio
.apm/skills/deep-research-config/scripts/patch-models.sh --profile mlx

# Or patch only the models section, keeping provider settings untouched:
.apm/skills/deep-research-config/scripts/patch-models.sh --profile ollama --models-only
```

The script rewrites `config.toml [models]` and (unless `--models-only`) also
rewrites `[providers.web]` and `[providers.scholar]` for local services.

Reference configs (copy manually if you prefer):

- `references/config.local-ollama.toml` — full Ollama profile
- `references/config.local-lmstudio.toml` — full LM Studio profile
- `references/config.local-mlx.toml` — full MLX profile

### Step 3: Verify

The orchestrator's startup sequence will run `check-providers.sh` automatically
if it detects a local profile in config.toml. It will abort with a clear error
if any required service is unreachable.

## Local Tools Available (via MCP)

Once MCP entries are added to `apm.yml` (see below), agents have access to:

| Tool | Replaces | Notes |
|------|----------|-------|
| `ollama_generate` / `ollama_chat` | Cloud LLM calls | Requires `ollama serve` |
| `lmstudio_chat` | Cloud LLM calls | OpenAI-compat at :1234 |
| `mlx_generate` | Cloud LLM calls | OpenAI-compat at :8080 |
| `searxng_search` | `tavily_search` | Requires SearXNG at :8888 |
| `zotero_search` | Scholar API | Requires Zotero + Better BibTeX |
| `zotero_export_bibtex` | Citation API | Exports .bib for `cite` agent |

## Adding MCPs to apm.yml

Add these entries to your `apm.yml` `dependencies.mcp` list:

```yaml
dependencies:
  mcp:
    # Local LLM — uncomment your backend
    - name: ollama
      registry: false
      transport: http
      url: http://localhost:11434/api
    # - name: lmstudio
    #   registry: false
    #   transport: http
    #   url: http://localhost:1234/v1
    # - name: mlx-lm
    #   registry: false
    #   transport: http
    #   url: http://localhost:8080/v1

    # Local web search
    - name: searxng
      registry: false
      transport: http
      url: http://localhost:8888

    # Zotero reference manager (requires Better BibTeX plugin + MCP bridge)
    - name: zotero
      registry: false
      transport: stdio
      command: npx
      args: ["-y", "zotero-mcp"]
      env:
        ZOTERO_API_KEY: ${{ secrets.ZOTERO_API_KEY }}
        ZOTERO_USER_ID: ${{ secrets.ZOTERO_USER_ID }}
```

## Model Mapping by Profile

### ollama

| Role | Default (cloud) | Local |
|------|----------------|-------|
| orchestrator | Claude Sonnet 4.6 | `ollama:qwen3:32b` |
| gather | Claude Haiku 4.5 | `ollama:qwen3:8b` |
| process | Claude Haiku 4.5 | `ollama:qwen3:8b` |
| extract | Claude Sonnet 4.6 | `ollama:qwen3:32b` |
| evaluate | Claude Sonnet 4.6 | `ollama:qwen3:32b` |
| cite | Claude Haiku 4.5 | `ollama:qwen3:8b` |
| synthesize_brief | Claude Sonnet 4.6 | `ollama:qwen3:32b` |
| synthesize_narrative | Claude Opus 4.6 | `ollama:qwen3:32b` |
| synthesize_forward | Claude Sonnet 4.6 | `ollama:qwen3:32b` |
| capture | Claude Haiku 4.5 | `ollama:qwen3:8b` |

### lmstudio / mlx

Same tier mapping — heavy roles use the largest loaded model, light roles use
the fastest. Set model names to match whatever you have loaded locally.
See `references/config.local-lmstudio.toml` for field names.
