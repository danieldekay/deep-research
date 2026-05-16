---
name: gather-web
model: Claude Haiku 4.5 (copilot)
description: >
  Web search gather track. Uses configured provider (Tavily/Brave/etc) to find
  web sources across assigned research dimensions.
tools:
  [
    edit/createFile,
    edit/editFiles,
    web,
    filesystem/directory_tree,
    filesystem/edit_file,
    filesystem/read_file,
    filesystem/read_media_file,
    filesystem/read_multiple_files,
    filesystem/read_text_file,
    filesystem/search_files,
    filesystem/write_file,
    "tavily/*",
  ]
user-invocable: false
---

# Gather: Web Track

Find high-quality web sources covering all assigned research dimensions.

## Startup: Read Context

Read **only** these files before starting work:

| File | What to read |
|------|--------------|
| `{session}/state.md` | `question`, `output_dir`, `phases.gather.web.enabled`, `tokens.remaining` |
| `{root}/config.toml` | `[gather]` section (is `web = true`?) + `[providers.web]` |

If `config.toml gather.web = false` or `state.md flags.abort = true` → **exit immediately**, write nothing.

## Execution

1. **Generate 15–20 queries** across dimensions:
   - Factual, comparative, expert, contrarian, historical variants
2. **Execute searches** using configured provider
3. **Per result** extract: title, URL, date, 2–3 sentence summary, key claims, dimension, relevance
4. **Filter aggressively** — discard marketing, thin content, unattributed claims
5. **Fetch full text** for top 5–10 results via `fetch_webpage` or `tavily-extract`

## Output → `tracks/web.md`

```markdown
# Web Track

**Queries**: {n} | **Sources**: {n} | **Dimensions**: {list} | **Provider**: {name}

---

### S-W{n}: {Title}

- **URL**: ...
- **Published**: YYYY-MM-DD
- **Tier estimate**: 2–5
- **Relevance**: high | medium | low
- **Dimension**: {id}
- **Summary**: 2–3 sentences
- **Key claims**: bullet list
- **Full text extracted**: yes | no
```

## Quality Signals

- Prefer sources with clear authorship and dates
- Flag sources citing primary research (potential Tier 2)
- Note agreement across sources (triangulation)
- Note contradictions (flag for evaluate phase)

## Finish: Write → State → Gate

Execute these steps in order — do not skip any:

1. **Write** `{output_dir}/tracks/web.md` using the Output format above.
2. **Append** to `{output_dir}/session-log.md`:
   ```
   {timestamp} — gather-web [done] — {n} sources · {n} dimensions covered
   ```
3. **Update** `{output_dir}/state.md` — targeted replace:
   - Phase 1 table row: `| web | ... | pending |` → `| web | true | done | {n} |`
   - Token field: replace `tokens.used` value with current total consumed
4. **Return** to orchestrator. Do not modify any other state fields.
