# Citation Format Guide

All references are stored in a central BibTeX file: `notes/references.bib`

## Citekey Format

### Standard Format
```
@lastnameYEAR
```

**Examples:**
- `@wilson2002` - Wilson, 2002
- `@kahneman2011` - Kahneman, 2011
- `@ahrens2017` - Ahrens, 2017

### Disambiguation Format
When author has multiple works in same year:
```
@lastnameYEARtitle
```

**Examples:**
- `@smith2020memory` - Smith's 2020 paper on memory
- `@smith2020learning` - Smith's 2020 paper on learning

### Multi-Author Format
Use first author only:
```
@firstauthorYEAR
```

**Example:**
- `@baddeley1974` for Baddeley & Hitch (1974)

## In-Text Citations

### Inline Reference
```markdown
Research shows that retrieval practice enhances learning [@bjork1994].
```

### Parenthetical
```markdown
This supports the testing effect (see [@roediger2006]).
```

### Multiple Citations
```markdown
Multiple studies confirm this finding [@bjork1994; @roediger2006; @karpicke2008].
```

### With Page Numbers
```markdown
Specifically, "the effort of retrieval strengthens memory" [@bjork1994, p. 187].
```

## BibTeX Entry Formats

Add entries to `notes/references.bib`. Do NOT duplicate citations in individual notes.

### Journal Article
```bibtex
@article{roediger2006,
  author = {Roediger, Henry L. and Karpicke, Jeffrey D.},
  title = {Test-enhanced learning: Taking memory tests improves long-term retention},
  journal = {Psychological Science},
  year = {2006},
  volume = {17},
  number = {3},
  pages = {249--255},
  doi = {10.1111/j.1467-9280.2006.01693.x}
}
```

### Book
```bibtex
@book{kahneman2011,
  author = {Kahneman, Daniel},
  title = {Thinking, Fast and Slow},
  publisher = {Farrar, Straus and Giroux},
  year = {2011}
}
```

### Book Chapter
```bibtex
@incollection{bjork1994,
  author = {Bjork, Robert A.},
  title = {Memory and metamemory considerations in the training of human beings},
  booktitle = {Metacognition: Knowing about knowing},
  editor = {Metcalfe, Janet and Shimamura, Arthur},
  publisher = {MIT Press},
  year = {1994},
  pages = {185--205}
}
```

### Conference Paper
```bibtex
@inproceedings{smith2023,
  author = {Smith, John},
  title = {Title of paper},
  booktitle = {Proceedings of Conference Name},
  year = {2023},
  pages = {100--110},
  doi = {10.1234/example}
}
```

### Webpage / Online
```bibtex
@online{authorYEAR,
  author = {Lastname, Firstname},
  title = {Title of Page},
  year = {2024},
  url = {https://example.com/page},
  urldate = {2024-01-15}
}
```

### ArXiv Preprint
```bibtex
@misc{author2024arxiv,
  author = {Lastname, Firstname},
  title = {Title of preprint},
  year = {2024},
  eprint = {2401.12345},
  archiveprefix = {arXiv},
  primaryclass = {cs.AI}
}
```

## Citation Workflows

### Quick Capture (During Reading)
1. Note the citekey: `@authorYEAR`
2. Note page number if quoting: `p. 123`
3. Add BibTeX entry to `references.bib` during processing

### Literature Note Creation
1. Start with citekey in title: "Concept - Author Year"
2. Add `citekey: @authorYEAR` in frontmatter or note body
3. Write insights in own words
4. Ensure entry exists in `references.bib`
5. Tag with `literature`

### Permanent Note with Sources
When permanent note synthesizes multiple sources:

```markdown
Title: Retrieval Practice Strengthens Memory

[Note content synthesizing multiple sources]

## Sources
- Primary: [@bjork1994] - foundational work on desirable difficulties
- Supporting: [@roediger2006] - testing effect experiments
- Application: [@karpicke2008] - practical implications
```

## Reference Manager Integration

### Zotero Workflow (Recommended)
1. Store bibliographic data in Zotero
2. Install Better BibTeX plugin
3. Configure auto-export to `notes/references.bib`
4. Set citekey format: `[auth:lower][year]`
5. Zotero keeps .bib file synchronized automatically

### Manual Workflow
1. Maintain `notes/references.bib` directly
2. Add entries as you create literature notes
3. Use consistent citekey format

### CLI Tools
```bash
# Find all notes citing a specific source
grep -r "@authorYEAR" notes/

# List all citekeys in .bib file
grep -E "^@" notes/references.bib

# Validate .bib file syntax
biber --tool --validate-datamodel notes/references.bib
```

Or use MCP:
```
zk_search_notes(query="@authorYEAR")
```

## Creating the references.bib File

Initialize the file if it doesn't exist:

```bash
cat > notes/references.bib << 'EOF'
% Zettelkasten Reference Library
% Auto-synced from Zotero or manually maintained
% Format: BibTeX

EOF
```

### Adding Entries

**From DOI (using curl + CrossRef):**
```bash
curl -sLH "Accept: application/x-bibtex" \
  "https://doi.org/10.1111/j.1467-9280.2006.01693.x" \
  >> notes/references.bib
```

**From Zotero:**
Right-click → Export Item → BibTeX → Append to `references.bib`

**Manually:**
```bash
cat >> notes/references.bib << 'EOF'

@article{newkey2024,
  author = {Author, Name},
  title = {Title Here},
  journal = {Journal Name},
  year = {2024}
}
EOF
```

## Citation Quality Checklist

For Literature Notes:
- [ ] Citekey follows `@lastnameYEAR` format
- [ ] Entry exists in `notes/references.bib`
- [ ] Page numbers noted for specific claims
- [ ] Content written in own words, not copied

For Permanent Notes:
- [ ] Sources acknowledged when idea derived from reading
- [ ] Multiple sources indicated when synthesizing
- [ ] All cited citekeys exist in `references.bib`

For references.bib:
- [ ] DOI included when available
- [ ] No duplicate entries
- [ ] Consistent formatting

## Common Citation Patterns

### Direct Derivation
When note directly based on single source:
```markdown
citekey: @authorYEAR

[Note content]
```

### Synthesis
When note synthesizes multiple sources:
```markdown
## Sources
Synthesized from [@author1YEAR; @author2YEAR; @author3YEAR]
```

### Inspired By
When source sparked your own thinking:
```markdown
Prompted by [@authorYEAR], but these are my own conclusions.
```

### Counter-Argument
When disagreeing with source:
```markdown
## In Response To
Challenging claim in [@authorYEAR]: [brief statement of their claim]
```

## Backlink Discovery

Find all notes citing a source:
```
zk_search_notes(query="@authorYEAR")
```

This enables:
- Seeing how you've used a source across your Zettelkasten
- Finding connections between notes sharing sources
- Tracking the influence of key texts on your thinking

## Exporting for Publishing

When writing papers or reports, the .bib file integrates directly with:

**LaTeX:**
```latex
\bibliography{notes/references}
\bibliographystyle{apa}
```
