---
name: qmd-knowledge-base
description: Maintain a markdown knowledge base at ~/git/knowledge-base/. Use when the user asks to interact with 'kb' or 'knowledge base' - adding content, deleting obsolete information, searching, or maintaining organization. Triggers on phrases like "add this to the kb", "delete from kb", "update kb", "maintain kb", "search kb", or any knowledge base operation.
---

# Knowledge Base Management

Maintain a structured markdown knowledge base for project documentation, code references, and learnings.

**Tool split**:

- **Write operations** (add, edit, delete files): direct file system tools
- **Read/search operations**: qmd MCP tools (`qmd_search`, `qmd_vector_search`, `qmd_deep_search`,
  `qmd_get`, `qmd_multi_get`, `qmd_status`)
- **After any write**: run `qmd update` in the terminal to re-index so future searches reflect
  the change

## Knowledge Base Structure

```text
~/git/knowledge-base/
├── index.md                    # Central index with references to all content
└── repos/                      # Repository-specific documentation
    ├── <repo-name>/           # One directory per repository
    │   ├── overview.md        # Repository overview
    │   ├── architecture.md    # Code structure and architecture
    │   ├── testing.md         # How to run tests
    │   └── ...                # Additional repo-specific docs
    └── ...
```

## Operation Modes

### Add Content

When the user asks to add content to the knowledge base:

1. **Determine target location**
   - If repo-specific: `~/git/knowledge-base/repos/<repo-name>/`
   - If general knowledge: `~/git/knowledge-base/`
   - Ask user only if ambiguous

2. **Identify appropriate file using qmd**
   - Use `qmd_search` (or `qmd_deep_search` for semantic matching) to find existing files
     covering the same topic
   - If a matching file is found, use `qmd_get` to read its full content
   - Create a new file only when no existing file matches the topic
   - Default to `overview.md` for general repo information

3. **Intelligent merge (CRITICAL)**
   - **DO NOT simply append** - this creates duplication
   - Read the destination file via `qmd_get` before editing
   - Check if similar content already exists
   - If content exists:
     - Update/enhance existing content with new information
     - Merge bullet points without duplication
     - Replace outdated information
   - If content is new:
     - Find the most logical section to insert it
     - Add to appropriate heading or create new heading
     - Maintain existing document structure

4. **Write the file** using file system tools (create or edit)

5. **Maintain structure**
   - Use clear markdown headings
   - Group related information together
   - Keep consistent formatting
   - Use bullet points for lists
   - Use code blocks for commands/code snippets

6. **Update index.md**
   - Add reference to new file if created
   - Keep index organized by category
   - Use descriptive link text

7. **Verify and confirm**
   - Show user what was added/updated
   - Report location of changes

### Delete Content

When the user asks to delete content from the knowledge base:

1. **Locate content using qmd**
   - Use `qmd_search` for keyword matches or `qmd_deep_search` for semantic search
   - Call `qmd_get` on the returned document(s) to read the full context
   - Confirm with user if multiple matches found

2. **Remove precisely** using file system tools
   - Delete the specific content, not entire files unless requested
   - Remove associated headings if section becomes empty
   - Clean up orphaned references

3. **Update index.md**
   - Remove references to deleted files
   - Update references if content was moved/consolidated

4. **Re-index** by running `qmd update`

5. **Report changes**
   - Show what was deleted
   - Confirm completion

### Search Content

When the user asks to search the knowledge base, use qmd MCP tools exclusively:

| Use case | Tool |
|---|---|
| Exact keyword / phrase | `qmd_search` |
| Semantic / natural language | `qmd_vector_search` |
| Best quality, hybrid | `qmd_deep_search` |
| Retrieve a specific file | `qmd_get <path>` |
| Retrieve multiple files | `qmd_multi_get <glob>` |
| Check index health | `qmd_status` |

Show the user the document paths, scores, and relevant snippets returned by qmd. For deep
dives, follow up with `qmd_get` on the most relevant results.

### Maintain Knowledge Base

When the user asks to maintain or clean up the knowledge base:

1. **Check index health** with `qmd_status`
   - Review collection info and any warnings

2. **Scan entire structure**
   - Use `qmd_multi_get "**/*.md"` to read all files in the knowledge base
   - Use `qmd_get index.md` to understand documented structure
   - Identify files not referenced in index

3. **Check for duplication**
   - Use `qmd_deep_search` with topic keywords to surface similar content across files
   - Flag sections that appear in multiple places
   - **Consolidate duplicates** using file system tools:
     - Keep the most comprehensive version
     - Delete redundant content
     - Add cross-references if needed

4. **Verify organization**
   - Ensure repo-specific content is in `repos/<repo-name>/`
   - Move misplaced files to correct locations
   - Verify file naming follows conventions:
     - `overview.md` - general repo information
     - `architecture.md` - code structure
     - `testing.md` - test instructions
     - `setup.md` - environment setup
     - `troubleshooting.md` - common issues
     - `commands.md` - useful commands

5. **Check index.md completeness**
   - Ensure all files are referenced
   - Remove broken links
   - Add missing files
   - Organize by logical categories:
     - General Knowledge
     - Repository Documentation
     - Troubleshooting
     - References

6. **Improve formatting**
   - Ensure consistent heading levels
   - Fix markdown linting issues
   - Standardize code block formatting
   - Normalize bullet point styles

7. **Re-index** by running `qmd update`

8. **Generate report**
   - Summary of changes made
   - List of duplicates consolidated
   - Files moved or renamed
   - Items added to index
   - Recommendations for user review

## Directory Creation

**Always create missing directories automatically** without asking permission:

```bash
mkdir -p ~/git/knowledge-base/repos/<repo-name>
```

If `index.md` doesn't exist, create it with initial structure:

```markdown
# Knowledge Base Index

## Repository Documentation

- [Repository Name](repos/repository-name/overview.md)

## General Knowledge

(No entries yet)
```

## Best Practices

### Content Quality

- **Be specific**: Include file paths, function names, exact commands
- **Be concise**: Remove unnecessary verbosity
- **Be current**: Delete outdated information during updates
- **Cross-reference**: Link related topics across files

### File Organization

- One repo = one directory under `repos/`
- Split large files by topic (don't create 1000+ line files)
- Use descriptive filenames
- Keep `index.md` current

### Merge Strategy

When adding content that partially overlaps with existing content:

1. **Identify overlap**: What's new vs what exists
2. **Enhance existing**: Add new details to existing sections
3. **Avoid redundancy**: Don't repeat information
4. **Preserve context**: Keep related information together

**Example**:

Existing content:

```markdown
## Running Tests

- Run `npm test` for unit tests
```

New content to add: "Integration tests are in `tests/integration/` and run with `npm run test:integration`"

**Correct merge**:

```markdown
## Running Tests

- Run `npm test` for unit tests
- Run `npm run test:integration` for integration tests (located in `tests/integration/`)
```

**Incorrect (simple append)**:

```markdown
## Running Tests

- Run `npm test` for unit tests

## Running Tests

- Integration tests are in `tests/integration/` and run with `npm run test:integration`
```

## Common Patterns

### Adding repo-specific knowledge

```text
User: "Add to kb: The auth service is in src/services/auth/"

Steps:
1. Check current working directory or ask which repo
2. qmd_search "auth service" to find any existing file covering this
3. qmd_get the best match (e.g. repos/<repo>/architecture.md) to read current content
4. Add/update section about auth service location
5. Run qmd update to re-index
6. Update index.md if a new file was created
```

### Deleting obsolete content

```text
User: "Delete the old deployment instructions from kb"

Steps:
1. qmd_search "deployment" to find matching documents
2. qmd_get the relevant file to read full content
3. Confirm with user which content to delete
4. Remove specified content using file system tools
5. Run qmd update to re-index
6. Clean up empty sections and index.md references
```

### Maintenance workflow

```text
User: "Maintain the kb"

Steps:
1. qmd_status to check index health
2. qmd_get index.md to understand documented structure
3. qmd_multi_get "**/*.md" to read all files and check for duplicates
4. Consolidate duplicates using file system tools
5. Move misplaced files
6. Update index.md
7. Run qmd update to re-index
8. Report all changes
```

## Error Handling

- If knowledge base directory doesn't exist: Create `~/git/knowledge-base/` and `index.md`
- If repo directory doesn't exist: Create `~/git/knowledge-base/repos/<repo-name>/`
- If uncertain about repo context: Ask user once, then proceed
- If file is very large (>500 lines): Suggest splitting into topic-specific files
- If `qmd_status` shows collection missing: run `qmd collection add ~/git/knowledge-base --name kb`
  then `qmd embed` to set up the index

## Examples

### Example 1: Add architectural knowledge

**User**: "Add to kb: User management code is in src/modules/users, tests are in tests/unit/users"

**Agent**:

1. Determine repo (check current directory or ask)
2. `qmd_search "user management architecture <repo>"` to find the right file
3. `qmd_get "repos/<repo>/architecture.md"` to read current content
4. Find "Users" or "User Management" section, or create it
5. Add/update:

   ```markdown
   ### User Management

   - **Location**: `src/modules/users`
   - **Tests**: `tests/unit/users`
   ```

6. Run `qmd update` in the terminal
7. Confirm: "Added user management location to kb at `repos/<repo>/architecture.md`"

### Example 2: Delete outdated content

**User**: "Remove the Heroku deployment steps from kb, we use Kubernetes now"

**Agent**:

1. `qmd_search "Heroku"` to find matching documents
2. `qmd_get "repos/web-app/deployment.md"` to read the section
3. Show user the section
4. Delete Heroku section using file system tools
5. Run `qmd update` in the terminal
6. Confirm: "Removed Heroku deployment instructions from `repos/web-app/deployment.md`"

### Example 3: Maintain knowledge base

**User**: "Maintain kb"

**Agent**:

1. `qmd_status` to check index health
2. `qmd_multi_get "**/*.md"` to read entire kb structure
3. `qmd_deep_search "running tests"` to surface duplicate content
4. Find duplicate "running tests" in `repos/api/overview.md` and `repos/api/testing.md`
5. Consolidate to `testing.md`, remove from `overview.md` using file system tools
6. Move `repos/troubleshooting.md` (general) to `~/git/knowledge-base/troubleshooting.md`
7. Update index.md with all files
8. Run `qmd update` in the terminal
9. Report:

   ```text
   Maintenance complete:
   - Consolidated duplicate test instructions
   - Moved 1 file to correct location
   - Updated index.md with 3 new references
   - No formatting issues found
   ```

## Quick Reference

| User Request | Operation | Key Actions |
|---|---|---|
| "Add X to kb" | Add | `qmd_search` to find existing → `qmd_get` to read → merge → write file → `qmd update` |
| "Delete X from kb" | Delete | `qmd_search` to locate → `qmd_get` to read → edit file → `qmd update` |
| "Search kb for X" | Search | `qmd_deep_search` (semantic) or `qmd_search` (keyword) → `qmd_get` for full content |
| "Maintain kb" | Maintain | `qmd_status` → `qmd_multi_get` → deduplicate → reorganize → `qmd update` |
