---
description: Quality gate evaluation protocol for all 5 gates
applyTo: "notes/research/**/state.md"
---

# Gate Check Protocol

Evaluate each gate by checking ALL criteria. ALL must PASS for the gate to pass.

## Gate 1: Source Sufficiency

- [ ] Total unique sources ≥ `min_sources` (default: 15)
- [ ] Source categories ≥ `min_source_categories` (default: 3)
- [ ] All mandatory dimensions have ≥1 source

**On fail**: re-dispatch underperforming tracks with refined queries.

## Gate 2: Source Quality

- [ ] `sources/register.md` exists and lists ALL sources with tier ratings
- [ ] Tier 1–2 sources ≥ `min_tier_1_2_sources` (default: 3)
- [ ] No duplicate URL/DOI entries

**On fail**: retry process with stricter dedup or re-gather for higher-quality sources.

## Gate 3: Extraction Completeness

- [ ] All Tier 1–3 sources have corresponding `extractions/*.md`
- [ ] All available PDFs downloaded and reading method applied

**On fail**: retry extraction for missing sources.

## Gate 4: Evaluation Completeness

- [ ] `evidence/claims-map.md` exists with claims → evidence mapping
- [ ] `references/citations.bib` exists with academic entries
- [ ] `evidence/fact-check.md` has verdicts for key claims
- [ ] `evidence/contradictions.md` has identified disagreements

**On fail**: `warn_and_continue` (default). Partial evaluation is still valuable.

## Gate 5: Output Completeness

- [ ] Required artifacts: brief.md, evidence/claims-map.md, forward/open-questions.md, forward/hypotheses.md, forward/further-research.md, manifest.md
- [ ] `narrative.md` contains inline citation markers
- [ ] Reference list at end of narrative

**On fail**: retry synthesis for missing artifacts.

## Failure Recovery

| Action              | When                                              |
| ------------------- | ------------------------------------------------- |
| `retry_{phase}`     | Specific criteria failed, retries remain          |
| `warn_and_continue` | Gap is non-critical, retry unlikely to help       |
| `abort`             | Fundamental failure (0 sources), budget exhausted |
