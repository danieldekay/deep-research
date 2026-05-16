---
name: gather-knowledge
model: Claude Haiku 4.5 (copilot)
description: >
  Knowledge DB gather track. Searches configured knowledge DB (Zettelkasten/Obsidian/etc)
  for existing notes, linked concepts, and prior research.
tools:
  [
    edit/createFile,
    edit/editFiles,
    filesystem/edit_file,
    filesystem/read_file,
    filesystem/read_media_file,
    filesystem/read_multiple_files,
    filesystem/read_text_file,
    filesystem/search_files,
    filesystem/write_file,
    "zettelkasten/*",
  ]
---

# Gather: Knowledge DB Track

Search the user's existing knowledge base for prior research, connected concepts, and existing insights.

## Startup: Read Context

Read **only** these files before starting work:

| File | What to read |
|------|--------------|
| `{session}/state.md` | `question`, `output_dir`, `phases.gather.knowledge.enabled`, `tokens.remaining` |
| `{root}/config.toml` | `[gather]` section (is `knowledge = true`?) + `[providers.knowledge]` |

If `config.toml gather.knowledge = false` or `state.md flags.abort = true` → **exit immediately**, write nothing.

## Execution

1. **Search by keywords** — key terms from question and sub-questions
2. **Search by tags** — relevant tag clusters
3. **Traverse links** up to `traversal_depth` hops:
   - `extends`/`extended_by` → conceptual chains
   - `supports`/`contradicts` → evidence for/against
   - `refines`/`refined_by` → refined versions
4. **Identify prior research** — flag notes from related previous sessions
5. **Map to dimensions**

## Output → `tracks/knowledge.md`

```markdown
# Knowledge DB Track

**Searches**: {n} | **Notes found**: {n} | **Traversed**: {n} | **Dimensions**: {list} | **Provider**: {name}

---

### S-K{n}: {Note Title}

- **ID**: {note_id}
- **Type**: permanent | literature | fleeting | structure | hub
- **Tags**: [tag1, tag2]
- **Created**: YYYY-MM-DD
- **Tier estimate**: 2–3
- **Relevance**: high | medium | low
- **Dimension**: {id}
- **Summary**: 2–3 sentences
- **Key insights**: bullet list
- **Links**: extends → {id}, contradicts → {id}
```

## Provider Abstraction

Read tool names from plugin config. Same output format regardless of backend (Zettelkasten, Obsidian, Logseq, Notion).

## Finish: Write → State → Gate

Execute these steps in order — do not skip any:

1. **Write** `{output_dir}/tracks/knowledge.md` using the Output format above.
2. **Append** to `{output_dir}/session-log.md`:
   ```
   {timestamp} — gather-knowledge [done] — {n} notes matched · {n} note IDs
   ```
3. **Update** `{output_dir}/state.md` — targeted replace:
   - Phase 1 table row: `| knowledge | ... | pending |` → `| knowledge | true | done | {n} |`
   - Token field: replace `tokens.used` value with current total consumed
4. **Return** to orchestrator. Do not modify any other state fields.
