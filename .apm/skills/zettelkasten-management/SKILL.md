---
name: zettelkasten-management
description: Comprehensive knowledge management using the Zettelkasten method with MCP server integration. Use when creating atomic notes, building knowledge graphs, establishing semantic links between ideas, managing citations, or organizing research insights. Triggers for note creation, linking, tagging, searching the knowledge base, finding connections, processing research, building second brain workflows, AI-assisted knowledge synthesis, graph traversal, and progressive summarization.
---

# Zettelkasten Knowledge Management

Manage a networked knowledge base using the Zettelkasten methodology through the MCP server.

## Core Principles

1. **Atomicity**: One idea per note. If scrolling is needed, split.
2. **Connectivity**: Link every note to 2+ existing notes. Use specific link types.
3. **Own Words**: Reformulate; don't copy. Understanding emerges through restatement.
4. **Bottom-Up Structure**: Let organization emerge from connections, not predefined hierarchies.
5. **Progressive Refinement**: Notes evolve from fleeting → literature → permanent. Refine continuously.
6. **AI as Thinking Partner**: Use MCP tools for discovery, not just storage. AI finds connections humans miss.

## MCP Tools

| Tool                     | Purpose                                                  |
| ------------------------ | -------------------------------------------------------- |
| `zk_create_note`         | Create note (type, tags, content)                        |
| `zk_get_note`            | Retrieve by ID                                           |
| `zk_update_note`         | Modify existing notes                                    |
| `zk_delete_note`         | Remove notes                                             |
| `zk_search_notes`        | Search by text, tags, type                               |
| `zk_create_link`         | Establish semantic connections                           |
| `zk_remove_link`         | Delete connections                                       |
| `zk_get_linked_notes`    | Find connected notes (direction: both/outgoing/incoming) |
| `zk_find_similar_notes`  | Semantic similarity search                               |
| `zk_find_central_notes`  | Identify hubs by connection count                        |
| `zk_find_orphaned_notes` | Find unconnected notes                                   |
| `zk_get_all_tags`        | List all tags                                            |
| `zk_list_notes_by_date`  | Filter by date                                           |
| `zk_rebuild_index`       | Rebuild SQLite index from markdown files                 |

## Note Types

| Type         | Purpose                                                                      | Lifecycle                                               |
| ------------ | ---------------------------------------------------------------------------- | ------------------------------------------------------- |
| `fleeting`   | Raw captures                                                                 | Process within 1 week → promote or delete               |
| `literature` | Source extractions with citation                                             | Stable; link to permanent notes                         |
| `permanent`  | Refined standalone ideas                                                     | Core of Zettelkasten; evolve via `refines` links        |
| `tension`    | Unresolved dialectical contradictions                                        | Preserve productive ambiguity; link both sides          |
| `synthesis`  | Cross-source comparison with confidence ratings, sub-gaps, and meta-insights | Create after 3+ sources; refine as evidence accumulates |
| `structure`  | Maps of Content (MOCs)                                                       | Create when 7+ notes cluster around a theme             |
| `hub`        | Entry points to major themes                                                 | Connect multiple MOCs; top-level navigation             |

### Quality Gate for Permanent Notes

- [ ] Single coherent idea (atomic)
- [ ] Written in own words (not copied)
- [ ] Self-contained (understandable without source)
- [ ] Declarative title ("Active Recall Strengthens Memory" not "Learning Note")
- [ ] 3-7 relevant tags
- [ ] Linked to 2+ notes with specific link types
- [ ] Citation if derived from source material

### Tension Notes: When to Use

**Create tension note when:**

- High-quality notes `contradict` each other
- Both sides have compelling evidence
- Trade-offs are context-dependent (quality vs. speed, depth vs. breadth)
- Active scholarly debate without consensus
- Premature resolution would oversimplify

**Structure:**

1. **Tension Statement**: Clear articulation of the unresolved conflict
2. **Thesis Position**: One perspective (strengths, evidence, limitations)
3. **Antithesis Position**: Opposing perspective (strengths, evidence, limitations)
4. **Synthesis Attempts**: Why existing resolutions are insufficient
5. **Productive Questions**: What would resolve this tension?
6. **Links**: `contradicts` to opposing notes, `supports` to evidence

**Don't create tension notes for:**

- False balance (one side clearly wrong)
- Easily resolvable contradictions
- Personal indecision (use fleeting → permanent instead)

### Synthesis Notes: When to Use

**Create synthesis note when:**

- You have 3+ literature or permanent notes on the same research question
- You need a side-by-side comparison of what different sources say about the same claims or gaps
- You want to record confidence levels per claim (🟢 High / 🟡 Medium / 🟠 Low)
- You've identified sub-gaps that exist across sources but don't fit a single atomic permanent note
- You observe meta-insights (methodological biases, definitional inconsistencies, sampling patterns)
  that only emerge when looking across the whole research landscape
- You complete a deep-research sprint and have process notes (what was searched, what failed) worth preserving

**Structure** (see full template in [note-templates.md](note-templates.md)):

1. **Research Question**: The specific question this synthesis answers
2. **Evidence Landscape**: Comparative table — sources × claims, with confidence ratings
3. **Supported Conclusions**: What the evidence clearly supports (🟢)
4. **Remaining Uncertainty**: Open sub-gaps and why they lack evidence (🟡/🟠)
5. **Meta-Insights**: Cross-cutting patterns only visible from the aggregate view
6. **Research Process Notes**: Searches run, what wasn't found, recommended next steps
7. **Links**: `synthesizes` → literature/permanent notes · `supports` → downstream notes

**Don't create synthesis notes for:**

- Single-source summaries (use `literature` instead)
- Single atomic concepts (use `permanent` instead)
- Less than 3 sources (insufficient for comparison)

| Link Type     | Inverse           | Use When              | Weight |
| ------------- | ----------------- | --------------------- | ------ |
| `supports`    | `supported_by`    | Evidence for a claim  | High   |
| `contradicts` | `contradicted_by` | Opposing views        | High   |
| `extends`     | `extended_by`     | Building on a concept | High   |
| `refines`     | `refined_by`      | Clarifying/improving  | Medium |
| `questions`   | `questioned_by`   | Raising doubts        | Medium |
| `reference`   | `reference`       | Simple citation       | Low    |
| `related`     | `related`         | Generic thematic      | Low    |

**Weight** indicates semantic strength for graph traversal and research synthesis:

- **High**: Strong epistemic relationship—follow these first during deep research
- **Medium**: Meaningful relationship—follow when exploring a topic
- **Low**: Weak connection—useful for discovery, not argumentation

**Heuristics:**

1. Prefer specific types over `related`
2. Use `bidirectional=true` for all links
3. Add descriptions explaining WHY notes are connected
4. Ask: "Will future-me understand this connection?"

## Workflows

### Knowledge Creation (Search → Create → Link)

```
1. zk_search_notes(query="concept") → check for duplicates
2. zk_create_note(title, content, note_type, tags) → create atomic note
3. zk_find_similar_notes(note_id) → find connection candidates
4. zk_create_link(source, target, type, description, bidirectional=true) → link immediately
```

### Research Capture

1. **During reading**: `fleeting` notes per interesting point
2. **After session**: Review fleeting notes, create `literature` notes with [@citekey]
3. **Synthesize**: Create `permanent` notes combining insights across sources
4. **Update structures**: Add permanent notes to relevant MOCs
5. **Add to references.bib**: BibTeX entry for each source

### Knowledge Discovery

```
zk_find_central_notes(limit=10)          # What are your core ideas?
zk_find_orphaned_notes()                 # What's disconnected?
zk_get_linked_notes(note_id, "both")     # What connects to X?
zk_find_similar_notes(note_id, 0.3)      # What's semantically close?
```

### AI-Assisted Synthesis

1. **Cross-pollination**: "Find notes in domain A that could connect to domain B"
2. **Structure generation**: "Find all permanent notes tagged [X] → create MOC"
3. **Gap analysis**: "What questions remain unanswered in [topic]?"
4. **Contradiction mapping**: "Find notes that contradict each other"

### Weekly Maintenance

1. Process fleeting notes → promote or delete
2. `zk_find_orphaned_notes()` → link or delete
3. `zk_find_central_notes()` → create MOCs for emerging clusters
4. `zk_get_all_tags()` → consolidate duplicates
5. Review structure notes → add recent permanent notes

## Citation Management

All references in `notes/references.bib` (BibTeX format).

**Citekey**: `@lastnameYEAR` (e.g., `@ahrens2017`). Disambiguate: `@smith2024memory`.

**In-note**: `[@authorYEAR]` or `[@author2024, p. 15]`

**Literature note must include**: citekey, key insight in own words, DOI/URL when available.

## Tagging Strategy

| Category | Examples                                    | Purpose                |
| -------- | ------------------------------------------- | ---------------------- |
| Domain   | `ai`, `chemistry`, `philosophy`             | Subject classification |
| Type     | `method`, `concept`, `principle`, `pattern` | Idea classification    |
| Project  | `project-rotf`, `thesis-ch3`                | Work context           |
| Status   | `wip`, `needs-review`, `evergreen`          | Note maturity          |
| Source   | `book`, `paper`, `talk`, `conversation`     | Origin type            |

**Rules**: 3-7 tags, hyphens not spaces, check `zk_get_all_tags()` before creating new.

## Response Format

**MANDATORY**: Every note creation, update, or link operation MUST be reported with a
clickable VS Code link. Never report a note by ID alone — always wrap it in a markdown link.

### Link Format Rules

Notes live at `notes/zettelkasten/{NOTE_ID}.md` relative to the workspace root
(`/home/kaesmad/projects/rotf/notes-workspace`). Use workspace-relative paths with
forward slashes. Do NOT use `file://` URIs or absolute paths — they will not render
as clickable in VS Code chat.

**CORRECT** — use the note title as display text, workspace-relative path as target:

```
[Note Title](notes/zettelkasten/20260218T142535215869000.md)
```

**WRONG** — never use ID alone, never use absolute path, never use backtick-wrapped path:

```
20260218T142535215869000          ← not clickable
`notes/zettelkasten/ID.md`        ← backticks prevent click
/home/kaesmad/.../ID.md           ← absolute path won't open in editor
```

### Summary Block Template

After any note operation, emit a summary block in this exact format:

```
**Notes created/updated:**
- [Note Title](notes/zettelkasten/{NOTE_ID}.md) — one-line description

**Links established:**
- [Source Title](notes/zettelkasten/{SOURCE_ID}.md) →{link-type}→ [Target Title](notes/zettelkasten/{TARGET_ID}.md)
```

### Examples

Single note created:

```
Created: [Foam Plugin Best Practices](notes/zettelkasten/20260218T150121525028000.md)
```

Multiple notes:

```
**Notes created:**
- [Productivity Measurement Paradox](notes/zettelkasten/20260217T175408984059000.md) — permanent note on contradictory AI productivity metrics
- [Security Attack Surface Multiplication](notes/zettelkasten/20260217T175449884195000.md) — parallel agents multiply security risk

**Links established:**
- [Productivity Measurement Paradox](notes/zettelkasten/20260217T175408984059000.md) →extends→ [SE 3.0 Empirical Study](notes/zettelkasten/20260127T161732710842000.md)
```

## Integration with Deep Research Agents

This skill is used by the **Deep Research Orchestrator** agent system for knowledge capture and graph traversal.
Agents that load this skill:

| Agent                                                                        | Role                    | Uses From This Skill                                                 |
| ---------------------------------------------------------------------------- | ----------------------- | -------------------------------------------------------------------- |
| [zk-researcher](../../agents/zk-researcher.agent.md)                         | N-depth graph traversal | Link types, quality weights, note types, discovery workflows         |
| [zk-maintenance](../../agents/zk-maintenance.agent.md)                       | Knowledge base health   | Tag strategy, orphan resolution, MOC creation, maintenance workflows |
| [research-web-track](../../agents/research-web-track.agent.md)               | Web research            | Note types for classification                                        |
| [research-scholar-track](../../_agents/research-scholar-track.agent.md)      | Academic research       | Literature note creation                                             |
| [research-codebase-track](../../agents/research-codebase-track.agent.md)     | Codebase research       | Note types for classification                                        |
| [research-synthesis-writer](../../agents/research-synthesis-writer.agent.md) | Narrative writing       | Knowledge organization                                               |

**Orchestrator**: [deep-research-orchestrator](../../agents/deep-research-orchestrator.agent.md) coordinates all agents and drives automatic knowledge capture (Phase 4).

**Quick Start**: See [docs/deep-research-quick-start.md](../../../docs/deep-research-quick-start.md) for usage guide.

## References

- [note-templates.md](references/note-templates.md) — Copy-paste templates for each note type
- [linking-patterns.md](references/linking-patterns.md) — Advanced linking strategies and patterns
- [citation-format.md](references/citation-format.md) — BibTeX format and citation workflows
- [ai-assisted-workflows.md](references/ai-assisted-workflows.md) — AI graph traversal, synthesis, and maintenance
