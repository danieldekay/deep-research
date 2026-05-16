# Semantic Linking Patterns

Advanced strategies for building a rich, navigable knowledge graph through intentional linking.

## Link Type Deep Dive

### `extends` / `extended_by`

**Use when:** New note builds upon, develops, or elaborates concepts from an existing note.

**Direction:** New note `extends` → Original note

**Examples:**
- "Applications of X" extends "Theory of X"
- "Case Study: X in Practice" extends "X Principle"
- "Critique of X" extends "Original X Argument"

**Pattern:** Create extension chains for developing ideas:
```
Foundational Concept
  ↑ extended_by
  Application in Context A
    ↑ extended_by
    Specific Implementation Details
```

### `refines` / `refined_by`

**Use when:** New note clarifies, improves precision, or corrects an existing note.

**Direction:** Refined note `refines` → Original note

**Examples:**
- "Clarification: X only applies when Y" refines "General statement about X"
- "Updated understanding of X" refines "Initial X hypothesis"
- "Nuanced view of X" refines "Simplistic X claim"

**Pattern:** Track evolution of understanding:
```
Initial Understanding (v1)
  ↑ refined_by
  Improved Understanding (v2)
    ↑ refined_by
    Current Best Understanding (v3)
```

### `contradicts` / `contradicted_by`

**Use when:** Notes present genuinely opposing views or incompatible claims.

**Direction:** Challenging note `contradicts` → Challenged note

**Examples:**
- "Evidence against X" contradicts "Argument for X"
- "Alternative theory Y" contradicts "Theory X"
- "Counterexample to X" contradicts "X is always true"

**Pattern:** Build dialectical structures:
```
Thesis A ←contradicts→ Antithesis B
        ↓ both extended_by
        Synthesis C
```

**Caution:** Don't overuse. Reserve for genuine contradictions, not mere differences.

### `supports` / `supported_by`

**Use when:** One note provides evidence, justification, or backing for another.

**Direction:** Evidence note `supports` → Claim note

**Examples:**
- "Study showing X" supports "X hypothesis"
- "Historical example of X" supports "X pattern claim"
- "Logical argument for X" supports "X conclusion"

**Pattern:** Build evidence networks:
```
Main Claim
  ↑ supported_by
  Evidence 1
  Evidence 2
  Evidence 3
    ↓ contradicted_by
    Counter-evidence (weakens but doesn't disprove)
```

### `questions` / `questioned_by`

**Use when:** One note raises doubts, asks for clarification, or challenges assumptions.

**Direction:** Questioning note `questions` → Questioned note

**Examples:**
- "What about edge case Y?" questions "X is generally true"
- "Assumption check: Is Y valid?" questions "Argument depending on Y"
- "Open problem: How does X scale?" questions "X solution"

**Pattern:** Track open questions and their resolution:
```
Established Claim
  ↑ questioned_by
  Open Question Note
    ↑ extended_by (when resolved)
    Resolution/Answer Note
```

### `reference` (bidirectional)

**Use when:** Simple citation or mention without strong semantic relationship.

**Direction:** Either direction works (symmetric relationship)

**Examples:**
- Note mentions another as background
- Note cites another as source
- Note acknowledges related work

**Caution:** Prefer specific link types when relationship is clear.

### `related` (bidirectional)

**Use when:** Thematic connection exists but no specific relationship type fits.

**Direction:** Either direction works (symmetric relationship)

**Examples:**
- Notes in same domain but different aspects
- Notes with overlapping tags
- Notes that might benefit from future integration

**Caution:** This is the weakest link type. Ask: "Can I be more specific?"

## Linking Heuristics

### The "Value-Add" Test
Before creating a link, ask: "Does following this link add value when reading the source note?"

**Good link:** Reading about memory → link to specific learning technique
**Poor link:** Reading about memory → link to vaguely related note about brain anatomy

### The "Future Self" Test
Ask: "Will my future self understand why these notes are connected?"

If not, either:
1. Choose a more specific link type
2. Add a description to the link
3. Don't create the link

### The "Minimum Two" Rule
Each permanent note should link to at least 2 other notes:
- One that provides context/foundation (where this idea comes from)
- One that shows application/extension (where this idea leads)

### The "Avoid Hub Overload" Rule
Don't link everything to a few central notes. If a note has 50+ connections, consider:
- Splitting into multiple notes
- Creating intermediate structure notes
- Being more selective about links

## Advanced Patterns

### The Bridge Pattern
Connect seemingly unrelated domains through shared principles:

```
Domain A Concept
       ↓ extends
Underlying Principle (bridge note)
       ↑ extends
Domain B Concept
```

**Example:**
- "Compound Interest in Finance" extends "Exponential Growth Principle"
- "Spaced Repetition in Learning" extends "Exponential Growth Principle"

The bridge note reveals unexpected connections.

### The Synthesis Pattern
Combine multiple sources into novel insights:

```
Source A Insight ──┐
                   ├──→ Synthesis Note (extends both)
Source B Insight ──┘
```

The synthesis note should be your original contribution, not just summary.

### The Argument Chain
Build structured arguments through linked notes:

```
Premise 1 ─→ supports ─→ Intermediate Conclusion ─→ supports ─→ Final Conclusion
Premise 2 ─↗
```

Allows challenging individual premises without losing entire argument.

### The Problem-Solution Pattern
Track problems and their potential solutions:

```
Problem Statement
  ↑ questioned_by
  Solution Attempt 1 (marked as unsuccessful)
  Solution Attempt 2 (marked as partial)
  Solution Attempt 3 (current best) ─→ supports ─→ Resolution Note
```

### The Evolution Pattern
Track how understanding develops over time:

```
v1: Initial Understanding
  ↑ refined_by
v2: After encountering contradiction
  ↑ refined_by
v3: Integrated understanding
```

Use `zk_list_notes_by_date()` to see this evolution chronologically.

## Link Discovery Workflow

### Finding Missing Links

1. **After creating new note:**
   ```
   zk_find_similar_notes(note_id="new_note", threshold=0.3)
   ```
   Review results and create appropriate links.

2. **During weekly review:**
   ```
   zk_find_orphaned_notes()
   ```
   For each orphan, either link it or question its value.

3. **Exploring a topic:**
   ```
   zk_get_linked_notes(note_id="topic_note", direction="both")
   ```
   Then explore second-order connections.

### Strengthening Weak Areas

1. Find notes with only generic `related` links
2. Re-evaluate: can the relationship be made more specific?
3. Update link types or add linking notes that explain the connection

### Identifying Emerging Hubs

```
zk_find_central_notes(limit=10)
```

Central notes often indicate:
- Core concepts in your thinking
- Potential structure note candidates
- Areas where you have deep knowledge

Consider creating explicit structure notes around these hubs.

## Anti-Patterns to Avoid

### Over-Linking
**Problem:** Every note links to dozens of others
**Solution:** Be intentional. Ask "What's the specific relationship?"

### Under-Typing
**Problem:** All links are `related`
**Solution:** Pause before linking. What's the actual relationship?

### Citation-Only Links
**Problem:** Links only go to sources, never to other permanent notes
**Solution:** Integrate ideas. Create synthesis notes that link across sources.

### Hub Collapse
**Problem:** One "master note" connected to everything
**Solution:** Break into structure notes. Create hierarchy of organization.

### Orphan Accumulation
**Problem:** New notes created but never linked
**Solution:** Enforce "minimum two links" rule. Weekly orphan review.
