---
description: Sub-artifact schema reference for v2 session outputs
applyTo: "notes/research/**/*.md"
---

# Artifact Schema

## Design Principle

v2 splits monolithic artifacts into focused sub-artifacts. No single output file should exceed ~200 lines. This keeps each artifact readable, diffable, and independently queryable.

## Session File Map

```mermaid
graph TB
    subgraph Root
        STATE[state.md]
        LOG[log.md]
        BRIEF[brief.md]
        NARR[narrative.md]
        MAN[manifest.md]
    end
    subgraph tracks/
        TW[web.md]
        TS[scholar.md]
        TC[codebase.md]
        TK[knowledge.md]
        TB[bookmarks.md]
    end
    subgraph sources/
        SR[register.md]
        SC[coverage.md]
        SD[discarded.md]
    end
    subgraph extractions/
        EX["NNN-slug.md (per source)"]
    end
    subgraph evidence/
        ECM[claims-map.md]
        ECS[craap-scores.md]
        EFC[fact-check.md]
        ECN[contradictions.md]
    end
    subgraph forward/
        FH[hypotheses.md]
        FOQ[open-questions.md]
        FFR[further-research.md]
    end
    subgraph references/
        RB[citations.bib]
        RL[reading-list.md]
    end
```

## Sub-Artifact Ownership

| Folder       | Producing Agent                                   | Gate   |
| ------------ | ------------------------------------------------- | ------ |
| tracks/      | gather-**                                   | Gate 1 |
| sources/     | process                                     | Gate 2 |
| extractions/ | extract                                     | Gate 3 |
| evidence/    | evaluate-evidence, evaluate-factcheck | Gate 4 |
| references/  | cite                                        | Gate 4 |
| forward/     | synthesize-forward                          | Gate 5 |
| brief.md     | synthesize-brief                            | Gate 5 |
| narrative.md | synthesize-narrative                        | Gate 5 |
| manifest.md  | orchestrator                                | Gate 5 |

## Source ID Convention

Each track uses a prefix to avoid ID collisions:

| Track     | Prefix | Example    |
| --------- | ------ | ---------- |
| Web       | S-W    | S-W1, S-W2 |
| Scholar   | S-A    | S-A1, S-A2 |
| Codebase  | S-C    | S-C1, S-C2 |
| Knowledge | S-K    | S-K1, S-K2 |
| Bookmarks | S-B    | S-B1, S-B2 |

After deduplication in process phase, sources get a unified ID (S1, S2, ...) in `sources/register.md`.

## Cross-References

Sub-artifacts reference each other using:

- Source IDs: `S{N}` (from register)
- Claim IDs: `C{N}` (from claims-map)
- Hypothesis IDs: `H{N}` (from hypotheses)
- Question IDs: `Q{N}` (from open-questions)
- Follow-up IDs: `FR{N}` (from further-research)
- Contradiction IDs: `X{N}` (from contradictions)
- Fact-check IDs: `F{N}` (from fact-check)
