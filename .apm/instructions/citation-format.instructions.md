---
description: Citation and BibTeX formatting rules
applyTo: "notes/research/**/references/**"
---

# Citation Format

## Inline Citations

| Source Type  | Format                | Example                     |
| ------------ | --------------------- | --------------------------- |
| Academic     | (Author et al., Year) | (Wang et al., 2025)         |
| Web          | (Source Title, Year)  | (Anthropic Docs, 2025)      |
| Knowledge DB | (ZK: Note Title)      | (ZK: Agent Architecture)    |
| Codebase     | (File: path)          | (File: src/orchestrator.py) |

## BibTeX Entry Types

| Source Type      | BibTeX Type                                                   |
| ---------------- | ------------------------------------------------------------- |
| Journal paper    | `@article`                                                    |
| Conference paper | `@inproceedings`                                              |
| ArXiv preprint   | `@article` with `journal = {arXiv preprint arXiv:XXXX.XXXXX}` |
| Book             | `@book`                                                       |
| Web page         | `@misc` with `url` and `note = {Accessed: YYYY-MM-DD}`        |
| Technical report | `@techreport`                                                 |

## Citation Key Format

`{FirstAuthorLastName}{Year}{keyword}` — e.g., `Wang2025deepresearcher`

## Reading List Order

1. **Foundational** — seminal works the field builds on
2. **Key papers** — core evidence for the research question
3. **Supporting** — additional context and triangulation
4. **Supplementary** — background and peripheral

## Citation Network

Render as Mermaid `graph TB` showing paper dependency relationships.
