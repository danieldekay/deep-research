# AI-Assisted Zettelkasten Workflows

Advanced patterns for using AI (Claude + MCP) as a thinking partner in your Zettelkasten.

## Graph Traversal for Deep Research

### N-Depth Link Following

Traverse the knowledge graph to discover indirect connections:

```
Depth 0: Starting note
Depth 1: Directly linked notes (zk_get_linked_notes)
Depth 2: Notes linked to depth-1 notes
Depth N: Continue expanding
```

**Algorithm:**

1. Start with a seed note
2. Get all linked notes (depth 1)
3. For each depth-1 note, get its links (depth 2)
4. Continue to depth N (default: 2, max recommended: 3)
5. Deduplicate and score by relevance

**Link Quality Weighting:**
When traversing, weight connections by semantic strength:

| Link Type     | Weight | Reasoning                      |
| ------------- | ------ | ------------------------------ |
| `supports`    | 1.0    | Direct evidential relationship |
| `contradicts` | 1.0    | Critical opposing view         |
| `extends`     | 0.9    | Strong conceptual building     |
| `refines`     | 0.8    | Meaningful clarification       |
| `questions`   | 0.7    | Open inquiry connection        |
| `reference`   | 0.4    | Weak citation link             |
| `related`     | 0.3    | Generic thematic link          |

Use these weights to prioritize which branches to explore during research traversal.

### Argumentation Mapping

Build evidence maps from the knowledge graph:

```
Claim Note
  ├── supported_by: Evidence 1 (weight: 1.0)
  ├── supported_by: Evidence 2 (weight: 1.0)
  ├── contradicted_by: Counter-evidence (weight: 1.0)
  └── questioned_by: Open question (weight: 0.7)
```

Summarize the argument strength by counting weighted support vs contradiction links.

### Cross-Domain Discovery

Find unexpected connections between different knowledge areas:

1. Identify two domain tags (e.g., `ai` and `biology`)
2. Search for notes in each domain
3. Use `zk_find_similar_notes` across domains
4. Look for bridge notes that connect both
5. Create new bridge notes for discovered connections

## Progressive Summarization

Layer summaries on top of raw notes:

| Layer | Content                              | Storage                  |
| ----- | ------------------------------------ | ------------------------ |
| L0    | Raw source material                  | External (papers, books) |
| L1    | Literature note (key ideas)          | `literature` note        |
| L2    | Permanent note (your interpretation) | `permanent` note         |
| L3    | Structure note (theme synthesis)     | `structure` note         |
| L4    | Hub note (domain overview)           | `hub` note               |

Each layer compresses information while preserving the most valuable insights.

## AI Synthesis Patterns

### Thematic Clustering

```
1. zk_search_notes(query="topic") → gather all related notes
2. Group by subtopic using tags and link patterns
3. For each cluster with 7+ notes → create structure note
4. Link structure notes to relevant hub
```

### Contradiction Resolution

```
1. Find pairs with `contradicts` links
2. Examine supporting evidence for each side
3. Create synthesis note that resolves or acknowledges tension
4. Link synthesis note with `extends` to both contradicting notes
```

### Knowledge Gap Detection

```
1. zk_find_orphaned_notes() → notes without connections
2. zk_find_central_notes() → heavily connected hubs
3. Look for topics referenced but not yet captured
4. Check structure notes for "Open Questions" sections
5. Identify domains with few permanent notes relative to literature notes
```

### Spaced Retrieval Practice

Use the Zettelkasten for active learning:

```
1. zk_list_notes_by_date() → find notes not reviewed recently
2. For each: read title only, try to recall content
3. Compare with actual content
4. If outdated: create `refines` link with updated understanding
5. If still valid: note review date in metadata
```

## Batch Processing Patterns

### Fleeting Note Triage

```
1. zk_search_notes(note_type="fleeting") → get all fleeting notes
2. For each fleeting note:
   a. zk_find_similar_notes(note_id) → check for existing coverage
   b. If covered: link or merge → delete fleeting
   c. If novel: promote to literature/permanent
   d. If stale: delete
3. Report: promoted X, merged Y, deleted Z
```

### Structure Note Generation

```
1. zk_get_all_tags() → identify tags with 7+ notes
2. For each qualifying tag:
   a. zk_search_notes(tags=[tag]) → gather notes
   b. Organize by subtopic using content analysis
   c. Create structure note with organized links
   d. Link structure note to relevant hub
```

### Link Enrichment

```
1. zk_find_orphaned_notes() → start with disconnected notes
2. For each orphan:
   a. zk_find_similar_notes(note_id, threshold=0.3)
   b. Review candidates, create typed links
   c. Prefer specific types over `related`
3. For notes with only `related` links:
   a. Re-evaluate: can relationship be more specific?
   b. Upgrade link type where possible
```

## Integration with External Research

### Semantic Scholar → Zettelkasten Pipeline

```
1. Search papers: mcp_semanticschol_search_papers(query)
2. For relevant papers: get details with mcp_semanticschol_get_paper
3. Create literature note with key insights
4. Add BibTeX to notes/references.bib
5. Link to existing permanent notes
6. Check paper references for further reading
```

### Web Research → Zettelkasten Pipeline

```
1. Search: mcp_tavily_tavily-search(query)
2. Extract key insights: mcp_tavily_tavily-extract(urls)
3. Create fleeting notes for each insight
4. Process into literature/permanent notes
5. Link to existing knowledge graph
```

### Meeting → Zettelkasten Pipeline

```
1. Ingest transcript: uv run ingest process
2. Review generated markdown
3. Extract atomic concepts as fleeting notes
4. Process key decisions → permanent notes
5. Link action items to project notes
6. Update relevant structure notes
```

## Quality Metrics

Track these to assess Zettelkasten health:

| Metric                 | Healthy Range            | How to Check                            |
| ---------------------- | ------------------------ | --------------------------------------- |
| Orphan ratio           | < 10% of total           | `zk_find_orphaned_notes()`              |
| Links per note         | 2-8 average              | `zk_find_central_notes()` distribution  |
| Fleeting backlog       | < 20 unprocessed         | `zk_search_notes(note_type="fleeting")` |
| Structure coverage     | Every 7+ cluster has MOC | Tag analysis                            |
| Link type distribution | < 30% `related`          | Link type audit                         |
| Tag consistency        | < 5% near-duplicate tags | `zk_get_all_tags()` review              |
