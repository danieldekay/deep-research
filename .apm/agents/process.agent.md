---
name: process
model: Claude Haiku 4.5 (copilot)
description: >
  Process and triage agent. Merges gather track outputs, deduplicates, quality-rates
  using 5-tier system, checks dimension coverage. Writes to sources/ sub-artifacts.
tools:
  [
    read/readFile,
    edit/createFile,
    edit/editFiles,
    filesystem/edit_file,
    filesystem/read_file,
    filesystem/read_media_file,
    filesystem/read_multiple_files,
    filesystem/read_text_file,
    filesystem/search_files,
    filesystem/write_file,
  ]
user-invocable: false
---

# Process & Triage

Transform raw gather outputs into a curated, quality-rated source register split across sub-artifacts.

## Startup: Read Context

Read **only** these files before starting work:

| File | What to read |
|------|--------------|
| `{session}/state.md` | `question`, `output_dir`, `phases.gather` table (which tracks are `done`), `tokens.remaining` |
| `{session}/tracks/*.md` | Only track files whose `state.md` row shows `status = done` (read in parallel) |

Do not read `sources/`, `extractions/`, or `evidence/` — they don’t exist yet.
Do not read tracks whose state row is `pending` or `failed`.

## Execution

### Step 1: Merge

Consolidate all sources from all tracks. Preserve track attribution.

### Step 2: Deduplicate

Priority: exact URL → DOI match → title similarity (>90%) → same content different URLs. Keep higher-metadata entry.

### Step 3: Quality Rate

Use the 5-tier system (see `source-quality.instructions.md`):

- T1: Peer-reviewed, high-impact, recent
- T2: Official docs, reputable technical
- T3: Well-sourced industry, arXiv preprints
- T4: Community, tutorials
- T5: Unverified, marketing, opinion

### Step 4: Dimension Coverage Check

Flag dimensions with < 2 sources or only T4–5 sources.

## Output → `sources/` sub-artifacts

### `sources/register.md`

```markdown
# Source Register

**Raw**: {n} | **After dedup**: {n} | **Distribution**: T1:{n} T2:{n} T3:{n} T4:{n} T5:{n}

## Tier 1

| #   | ID  | Title | Authors/Source | Type | DOI/URL | Dimension | Track |
| --- | --- | ----- | -------------- | ---- | ------- | --------- | ----- |

## Tier 2

| #   | ID  | Title | Source | Type | URL | Dimension | Track |
| --- | --- | ----- | ------ | ---- | --- | --------- | ----- |

## Tier 3

| #   | ID  | Title | Source | Type | URL | Dimension | Track |
| --- | --- | ----- | ------ | ---- | --- | --------- | ----- |
```

### `sources/coverage.md`

```markdown
# Dimension Coverage

| Dimension  | Sources | Top Tier | Status              |
| ---------- | ------- | -------- | ------------------- |
| historical | {n}     | T{n}     | OK / WARN / MISSING |

**Key**: OK = 3+ sources with 1+ T1-2 | WARN = 1-2 sources or T3+ only | MISSING = 0 sources
```

### `sources/discarded.md`

```markdown
# Discarded Sources

| Title | Track | Reason                     |
| ----- | ----- | -------------------------- |
| ...   | web   | Duplicate of S-W3          |
| ...   | web   | Tier 5 — no evidence value |
```

## Finish: Write → State → Gate

Execute these steps in order — do not skip any:

1. **Write** all three artefacts:
   - `{output_dir}/sources/register.md`
   - `{output_dir}/sources/coverage.md`
   - `{output_dir}/sources/discarded.md`
2. **Append** to `{output_dir}/session-log.md`:
   ```
   {timestamp} — process [done] — {total} sources rated (T1:{n} T2:{n} T3:{n} discarded:{n})
   ```
3. **Update** `{output_dir}/state.md` — targeted replace inside Phase 2 code block:
   - `status:         pending` → `status:         done`
   - `sources_total:  —` → `sources_total:  {total}`
   - `sources_t1_t2:  —` → `sources_t1_t2:  {n}`
   - Token field: replace `tokens.used` value with current total consumed
4. **Return** to orchestrator. Do not modify any other state fields.
