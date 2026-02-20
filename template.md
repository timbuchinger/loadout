
## Memory and Knowledge Base

These skills and tools provide persistent memory across sessions through a searchable knowledge base and conversation history.

### Available Skills

- **kb-search** - Search the markdown knowledge base for relevant notes, documentation, and saved information
- **conversations-search** - Search past conversation transcripts to recover context, decisions, and solutions
- **kb-add** - Add or update content in the knowledge base for future reference
- **search-notes** - Search structured notes using hybrid search (BM25 + vector embeddings)
- **1password** - Query and retrieve user-owned secrets from 1Password

### Usage Pattern

**At task start:**

1. Always use the kb-search skill to search for relevant existing knowledge.
2. Use the conversations-search skill to search for similar past sessions if you think it would be helpful or if the user says something like 'we did this before', 'do the same as last time', etc.
3. Use findings to inform your approach.

**During task execution:**

- When discovering useful patterns, solutions, or decisions, add them to the knowledge base using kb-add
- Do not wait until task completion to save important discoveries

**When secrets are needed:**

- Use 1password skill to retrieve user-owned secrets (personal API keys, personal credentials, etc.)
- Do NOT store secrets in the knowledge base
- Note: Application runtime secrets may be stored in cloud secret managers (Azure Key Vault, AWS Secrets Manager, GCP Secret Manager) rather than 1Password

**Key principle:** Proactively store information that would help future agents solve similar problems or understand this domain.

**At Task End**

When a task is complete, always review the conversation to see if any new information was uncovered. Store this in the knowledge base if it would be relevant for future tasks or other agents.
