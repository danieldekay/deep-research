# Note Templates

Quick-reference templates for each Zettelkasten note type. Copy and adapt as needed.

## Fleeting Note

```markdown
Title: [Quick descriptive phrase]

[Raw observation, question, or idea - no formatting needed]

Source: [Where this came from - meeting, reading, shower thought]
Context: [What prompted this thought]
```

**Example:**

```markdown
Title: Task switching costs compound

Read that context switching can cost 23 minutes to regain focus.
Wonder if this compounds - does the 5th switch cost more than the 1st?

Source: Reading Cal Newport's Deep Work
Context: Reflecting on my fragmented workday
```

## Literature Note

```markdown
Title: [Core Concept] - [Author Year]

## Key Insight

[Main idea in your own words - 2-3 sentences max]

## Supporting Evidence

- [Key point or data from source]
- [Another supporting element]

## Implications

[What this means for your work/thinking]

## Questions Raised

- [Question this prompts]

## Reference

[#authorYEAR]: Author, A. (Year). Title of work. Publisher/Journal.
```

**Example:**

```markdown
Title: Desirable Difficulties in Learning - Bjork 1994

## Key Insight

Making learning harder in the short term (through spacing, interleaving,
testing) leads to better long-term retention. The effort of retrieval
strengthens memory more than passive review.

## Supporting Evidence

- Spaced practice beats massed practice despite feeling harder
- Testing effect: retrieval practice > re-reading
- Interleaving topics improves transfer

## Implications

Design learning systems that feel challenging. "Easy" learning is
often ineffective learning. Apply to Zettelkasten review practices.

## Questions Raised

- What's the optimal spacing interval?
- Does this apply to skill learning as well as knowledge?

## Reference

[#bjork1994]: Bjork, R. A. (1994). Memory and metamemory considerations
in the training of human beings. In J. Metcalfe & A. Shimamura (Eds.),
Metacognition: Knowing about knowing (pp. 185-205). MIT Press.
```

## Permanent Note

```markdown
Title: [Declarative statement or concept name]

[Core idea in 3-5 sentences. Self-contained and understandable
without external context.]

## Elaboration

[Optional: Additional nuance, examples, or applications.
Keep brief - if this grows, split into new notes.]

## Links

- Extends: [[Note this builds upon]]
- Supports: [[Note this provides evidence for]]
- Related: [[Thematically connected note]]
```

**Example:**

```markdown
Title: Retrieval Practice Strengthens Memory More Than Review

Actively recalling information creates stronger memory traces than
passively re-reading the same material. This "testing effect" occurs
because retrieval requires reconstructing knowledge, which reinforces
neural pathways. The effort of retrieval, even when unsuccessful,
benefits subsequent learning.

## Elaboration

Implications for note-taking: Don't just re-read notes. Instead,
practice recalling the main idea before looking at the note.
Spaced retrieval practice is more effective than massed practice.

## Links

- Extends: [[Desirable Difficulties in Learning - Bjork 1994]]
- Supports: [[Effective Study Strategies]]
- Related: [[Spacing Effect in Memory]]
```

## Structure Note (MOC)

```markdown
Title: MOC - [Theme Name]

## Overview

[2-3 sentence description of this knowledge domain]

## Core Concepts

Foundational ideas in this domain:

- [[Note 1]] - brief description of relevance
- [[Note 2]] - brief description of relevance

## Key Principles

Operating principles or heuristics:

- [[Principle Note 1]]
- [[Principle Note 2]]

## Applications

How these concepts apply in practice:

- [[Application Note 1]]

## Open Questions

- [Unresolved question in this domain]
- [Another question to explore]

## Related Maps

- [[Related MOC 1]]
- [[Related MOC 2]]
```

**Example:**

```markdown
Title: MOC - Learning Science

## Overview

Evidence-based principles for effective learning and knowledge retention.
Draws from cognitive psychology, educational research, and memory science.

## Core Concepts

- [[Retrieval Practice Strengthens Memory More Than Review]]
- [[Spacing Effect in Memory]]
- [[Interleaving Improves Transfer]]
- [[Elaboration Creates Meaningful Connections]]

## Key Principles

- [[Desirable Difficulties Principle]]
- [[Testing Effect]]
- [[Generation Effect]]

## Applications

- [[Designing Effective Flashcard Systems]]
- [[Zettelkasten as Retrieval Practice]]
- [[Spaced Repetition Scheduling]]

## Open Questions

- Optimal spacing intervals for different content types?
- How do individual differences affect these principles?
- Application to motor skill learning?

## Related Maps

- [[MOC - Memory]]
- [[MOC - Knowledge Management]]
- [[MOC - Productivity Systems]]
```

## Synthesis Note

A **synthesis note** sits _above_ permanent notes. It compares evidence across multiple sources,
records confidence levels per claim, identifies remaining sub-gaps, and documents meta-insights
that only emerge when looking across the whole research landscape. It is distilled from completed
research rather than from a single source.

**When to create**: After gathering 3+ literature/permanent notes on the same research question, OR
when you finish a deep-research session and have cross-cutting observations that don't fit any
single atomic note.

**Lifecycle**: Create once; refine with `refines` links as new evidence arrives.

```markdown
Title: Synthesis - [Research Question or Topic]

## Research Question

[The specific question this synthesis answers]

## Evidence Landscape

| Aspect / Gap  | Source A        | Source B        | Source C        | Confidence |
| ------------- | --------------- | --------------- | --------------- | ---------- |
| [Claim/gap 1] | [A's stance]    | [B's stance]    | [C's stance]    | 🟢 High    |
| [Claim/gap 2] | [A's stance]    | _(not covered)_ | [C's stance]    | 🟡 Medium  |
| [Claim/gap 3] | _(not covered)_ | [B's stance]    | _(not covered)_ | 🟠 Low     |

**Confidence key**: 🟢 ≥3 independent sources agree · 🟡 2 sources or mixed signals · 🟠 Single source or indirect evidence

## What the Evidence Supports (High Confidence 🟢)

[Bullet list of well-evidenced conclusions]

## What Remains Uncertain (🟡 / 🟠)

[Bullet list of open sub-gaps and why they lack evidence]

## Meta-Insights

[Cross-cutting patterns or insights that only emerge from comparing sources]
Examples:

- "All three studies have survivorship bias in their sample"
- "Gaps A and C both trace back to the same unmeasured variable"
- "Industry reports focus on X while academic work focuses on Y — different definitions"

## Research Process Notes

_(Optional: what searches were run, what failed, what's missing from the literature)_

- Searched: [query 1], [query 2]
- Not found: [topic not covered in literature]
- Recommended next step: [where to look next]

## Links

- Synthesizes: [[Literature Note 1]], [[Literature Note 2]], [[Literature Note 3]]
- Supports: [[Permanent Note that benefits from this synthesis]]
- Raises: [[Tension Note if contradictions remain]]
```

**Example (abbreviated):**

```markdown
Title: Synthesis - AI Impact on Developer Productivity Research Gaps

## Research Question

Where are the genuine gaps in AI coding-assistant productivity research?

## Evidence Landscape

| Gap                    | Cui 2024       | Uplevel 2024    | BCG 2023         | GitClear 2024       | Confidence |
| ---------------------- | -------------- | --------------- | ---------------- | ------------------- | ---------- |
| Measurement validity   | Lab tasks only | Real PRs, 2yr   | Controlled tasks | Full commit history | 🟢 High    |
| Code quality effects   | Not measured   | PR volume focus | Not measured     | Churn↑, copy↑       | 🟡 Medium  |
| Long-term productivity | 6wk study      | 2yr (unique)    | 45 days          | Ongoing             | 🟠 Low     |

## Meta-Insights

- Lab studies (Cui, BCG) favor simple algorithmic tasks where AI excels; real-world studies
  (Uplevel, GitClear) show more mixed/negative signals. This sampling gap inflates aggregate estimates.
- "Productivity" is measured as 5 different things across these 4 studies — no common metric exists,
  making direct comparison misleading.

## Research Process Notes

- Searched: Semantic Scholar "AI developer productivity" 2023-2025
- Not found: Studies measuring long-term architecture quality degradation
- Recommended: Longitudinal cohort studies with >1yr follow-up and consistent metrics
```

## Hub Note

```markdown
Title: Hub - [Major Theme]

## Central Theme

[Comprehensive description of this major area - can be longer than
typical notes since hubs serve as entry points]

## Structure Maps

Organized knowledge in this domain:

- [[MOC - Subtopic 1]] - description
- [[MOC - Subtopic 2]] - description

## Key Entry Points

Start here for specific topics:

- [[Important Permanent Note 1]]
- [[Important Permanent Note 2]]

## Cross-Domain Connections

How this connects to other hubs:

- [[Hub - Related Domain 1]] via [connection description]
- [[Hub - Related Domain 2]] via [connection description]
```

## Quick Creation Patterns

### From a Meeting

1. Create fleeting notes during meeting
2. Same day: Review and tag fleeting notes
3. Within week: Extract permanent notes, link to existing knowledge

### From a Paper/Book

1. Create literature note with key insights
2. For each distinct idea: Create permanent note
3. Link permanent notes to literature note with `extends` link
4. Connect to existing relevant permanent notes

### From a Conversation

1. Quick fleeting note capturing key insight
2. If significant: Develop into permanent note
3. Tag with conversation context for future reference

### From Your Own Thinking

1. Fleeting note for initial thought
2. Let it sit 24-48 hours
3. If still valuable: Develop into permanent note
4. If duplicate: Link to existing note instead
