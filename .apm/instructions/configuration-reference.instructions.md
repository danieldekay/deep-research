---
description: Complete configuration reference for config.toml
applyTo: "config.toml"
---

# Configuration Reference

## Pipeline Phases

| Key                          | Type         | Description                       |
| ---------------------------- | ------------ | --------------------------------- |
| `pipeline.phases[].id`       | string       | Unique phase ID                   |
| `pipeline.phases[].name`     | string       | Display name                      |
| `pipeline.phases[].parallel` | boolean      | Sub-tasks run in parallel         |
| `pipeline.phases[].gate`     | string\|null | Gate ID after phase (null = skip) |

## Quality Gates

| Key                      | Type    | Description                                       |
| ------------------------ | ------- | ------------------------------------------------- |
| `gates.{id}.name`        | string  | Gate display name                                 |
| `gates.{id}.criteria.*`  | varies  | Pass/fail criteria                                |
| `gates.{id}.on_fail`     | string  | `retry_{phase}` \| `abort` \| `warn_and_continue` |
| `gates.{id}.max_retries` | integer | Max retry attempts                                |

### Gate Defaults

| Gate | Criterion             | Default |
| ---- | --------------------- | ------- |
| 1    | min_sources           | 15      |
| 1    | min_source_categories | 3       |
| 2    | min_tier_1_2_sources  | 3       |

## Dimensions

| Key                          | Type   | Description         |
| ---------------------------- | ------ | ------------------- |
| `dimensions.required[].id`   | string | Unique dimension ID |
| `dimensions.required[].name` | string | Display name        |
| `dimensions.custom[].id`     | string | Custom dimension ID |

## Plugins

All plugins share: `provider` (string), `enabled` (boolean), `config` (object).

### search_web

| Config              | Default    | Description             |
| ------------------- | ---------- | ----------------------- |
| queries_per_session | "15–20"    | Search query count      |
| search_depth        | "advanced" | Provider-specific depth |
| include_domains     | []         | Domain whitelist        |
| exclude_domains     | []         | Domain blacklist        |

### search_scholar

| Config                | Default      | Description            |
| --------------------- | ------------ | ---------------------- |
| max_results_per_query | 20           | Results per query      |
| min_citation_count    | 10           | Citation filter        |
| year_range            | [2022, 2026] | Publication year range |

### search_knowledge_db

| Config          | Default           | Description         |
| --------------- | ----------------- | ------------------- |
| mcp_server      | "#zettelkasten"   | MCP server name     |
| tools.search    | "zk_search_notes" | Search tool         |
| tools.get       | "zk_get_note"     | Get note tool       |
| traversal_depth | 2                 | Link traversal hops |

### search_bookmarks

| Config     | Default     | Description     |
| ---------- | ----------- | --------------- |
| mcp_server | "#raindrop" | MCP server name |

## Models

| Role              | Default       | Purpose               |
| ----------------- | ------------- | --------------------- |
| orchestrator      | claude-sonnet | Routing decisions     |
| gather_tracks     | claude-haiku  | High volume, low cost |
| process           | claude-haiku  | Classification        |
| extract           | claude-sonnet | Nuanced reading       |
| evaluate          | claude-opus   | Highest quality       |
| synthesize        | claude-sonnet | Good writing          |
| knowledge_capture | claude-haiku  | Structured notes      |
| citation_manager  | gemini-flash  | Fast metadata         |

## Session

| Key              | Default                         | Description     |
| ---------------- | ------------------------------- | --------------- |
| output_dir       | "notes/research/{date}-{slug}/" | Session folder  |
| state_file       | "state.md"                      | IPC file        |
| max_total_tokens | 500000                          | Budget guard    |
| timeout_minutes  | 60                              | Session timeout |

## Topic Presets

| Preset    | min_sources | min_categories | min_tier_1_2 |
| --------- | ----------- | -------------- | ------------ |
| Academic  | 20          | 3              | 5            |
| Technical | 15          | 3              | 3            |
| Industry  | 12          | 3              | 2            |
| Quick     | 8           | 2              | 1            |
