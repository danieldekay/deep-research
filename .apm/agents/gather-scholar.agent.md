---
name: gather-scholar
model: Claude Haiku 4.5 (copilot)
description: >
  Academic search gather track. Uses Semantic Scholar (or configured provider)
  to find peer-reviewed papers and preprints.
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

# Gather: Scholar Track

Find peer-reviewed papers and preprints addressing the research question.

## Startup: Read Context

Read **only** these files before starting work:

| File | What to read |
|------|--------------|
| `{session}/state.md` | `question`, `output_dir`, `phases.gather.scholar.enabled`, `tokens.remaining` |
| `{root}/config.toml` | `[gather]` section (is `scholar = true`?) + `[providers.scholar]` |

If `config.toml gather.scholar = false` or `state.md flags.abort = true` → **exit immediately**, write nothing.

## Execution

1. **Generate 8–12 academic queries** using technical terminology, author names, Boolean operators
2. **Execute searches** against configured provider
3. **Per paper** extract: title, authors, year, venue, DOI, citation count, abstract, open-access PDF URL, dimension
4. **Prioritize** by: citation count × recency × relevance
5. **Follow citation chains** for top 3 papers:
   - References → seminal work
   - Citations → recent developments

## Output → `tracks/scholar.md`

```markdown
# Scholar Track

**Queries**: {n} | **Papers**: {n} | **Dimensions**: {list} | **Provider**: {name}

---

### S-A{n}: {Title}

- **Authors**: First Author et al.
- **Year**: YYYY | **Venue**: {name}
- **DOI**: doi:... | **ArXiv**: {id if applicable}
- **Citations**: {count}
- **Tier estimate**: 1–2
- **Open access PDF**: URL | none
- **Relevance**: high | medium | low
- **Dimension**: {id}
- **Abstract summary**: 2–3 sentences
- **Key contributions**: bullet list

## Citation Chains

- Paper A (YYYY, N cit) → cites → Paper B (YYYY, foundational)
- Paper A → cited by → Paper C (YYYY, extends findings)
```

## ArXiv Protocol

- Note arXiv ID, check for published peer-reviewed version
- Prefer published version but record both
- Flag for PDF download in extract phase

## Finish: Write → State → Gate

Execute these steps in order — do not skip any:

1. **Write** `{output_dir}/tracks/scholar.md` using the Output format above.
2. **Append** to `{output_dir}/session-log.md`:
   ```
   {timestamp} — gather-scholar [done] — {n} sources · {n} with DOIs
   ```
3. **Update** `{output_dir}/state.md` — targeted replace:
   - Phase 1 table row: `| scholar | ... | pending |` → `| scholar | true | done | {n} |`
   - Token field: replace `tokens.used` value with current total consumed
4. **Return** to orchestrator. Do not modify any other state fields.
