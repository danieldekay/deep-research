---
name: evaluate-factcheck
model: Claude Sonnet 4.6 (copilot)
description: >
  Fact-checking and source credibility agent. Scores sources using CRAAP framework,
  cross-verifies key claims, assigns fact-check verdicts.
tools:
  [
    read/readFile,
    edit/createDirectory,
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

# Evaluate: Fact-Check & Credibility

Score source credibility and verify key claims independently.

## Startup: Read Context

Read **only** these files before starting work:

| File | What to read |
|------|--------------|
| `{session}/state.md` | `question`, `output_dir`, `tokens.remaining` |
| `{session}/sources/register.md` | Tier 1–3 rows (CRAAP applies to T1–3 only) |
| `{session}/extractions/*.md` | All extraction files (read in parallel) |

Do not read `tracks/` or previously written `evidence/*.md` at startup.

## Execution

### CRAAP Scoring

For each Tier 1–3 source, score (1–5 per dimension):

- **Currency**: how recent? still relevant?
- **Relevance**: directly addresses question?
- **Authority**: author credentials, institutional backing?
- **Accuracy**: supported by evidence, peer reviewed?
- **Purpose**: informational vs commercial vs persuasive? biases?

### Fact-Check Pipeline

1. Extract key claims from Tier 1–2 sources
2. Cross-verify each against ≥2 independent sources
3. Assign verdict:
   - **[CONFIRMED]**: 2+ independent sources agree
   - **[PARTIAL]**: 1 confirms, others silent
   - **[UNVERIFIED]**: no independent verification
   - **[CONTRADICTED]**: independent source directly contradicts

## Output → `evidence/craap-scores.md`

```markdown
# CRAAP Scores

| Source | Currency | Relevance | Authority | Accuracy | Purpose | Total |
| ------ | -------- | --------- | --------- | -------- | ------- | ----- |
| S1     | 4/5      | 5/5       | 5/5       | 4/5      | 4/5     | 22/25 |
```

## Output → `evidence/fact-check.md`

```markdown
# Fact-Check Verdicts

| #   | Claim   | Verdict      | Verifying Sources | Notes         |
| --- | ------- | ------------ | ----------------- | ------------- |
| F1  | {claim} | CONFIRMED    | S1, S8            |               |
| F2  | {claim} | PARTIAL      | S3 only           |               |
| F3  | {claim} | CONTRADICTED | S7 opposes        | {explanation} |
```

## Bias Detection

Check for: publication bias, funding bias, confirmation bias, survivorship bias, authority bias, recency bias. Note findings in `evidence/fact-check.md`.

## Finish: Write → State → Gate

Execute these steps in order — do not skip any:

1. **Write** both artefacts:
   - `{output_dir}/evidence/craap-scores.md`
   - `{output_dir}/evidence/fact-check.md`
2. **Append** to `{output_dir}/session-log.md`:
   ```
   {timestamp} — evaluate-factcheck [done] — {n} sources CRAAP-scored · {n} high-risk flags
   ```
3. **Update** `{output_dir}/state.md` — targeted replace inside Phase 4 table:
   - `| factcheck | pending |` → `| factcheck | done    |`
   - Token field: replace `tokens.used` value with current total consumed
4. **Return** to orchestrator. Do not modify any other state fields.
