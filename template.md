
## Memory and Knowledge Base Tools

These tools provide persistent memory across sessions through a searchable knowledge base and conversation history.

### Available Tools

- **kb-search** - Search the markdown knowledge base for relevant notes, documentation, and saved information
- **conversations-search** - Search past conversation transcripts to recover context, decisions, and solutions
- **kb-add** - Add or update content in the knowledge base for future reference
- **search-notes** - Search structured notes using hybrid search (BM25 + vector embeddings)

### Usage Pattern

**At task start:**
1. Search kb-search for relevant existing knowledge
2. Search conversations-search for similar past sessions
3. Use findings to inform your approach

**During task execution:**
- When discovering useful patterns, solutions, or decisions, add them to the knowledge base using kb-add
- Do not wait until task completion to save important discoveries

**Key principle:** Proactively store information that would help future agents solve similar problems or understand this domain.
