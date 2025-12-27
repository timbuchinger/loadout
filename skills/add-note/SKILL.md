---
name: add-note
description: Use this skill whenever important information is learned during a task or when the user explicitly asks to store something.
---

Be **proactive**, but intentional:
- Store CLI commands, API endpoints, error resolutions, operational gotchas, patterns, and internal processes
- Prefer **small, focused, reusable notes**
- If the information would save time if recalled later, it likely belongs here

---

## What this skill does
Stores a structured knowledge note in Qdrant for retrieval by AI coding agents.

This skill uses the **Qdrant MCP server** via the **`qdrant-store`** tool.

---

## Collection
All notes are stored in the following collection:

```
notes-hybrid
```

---

## Storage guardrails (IMPORTANT)
These rules must be followed exactly:

- **Do not store test notes** unless they contain a concrete, reusable learning
- **Context is required** unless the text is completely self-explanatory
- All fields must be **top-level**
- **Do not introduce new fields**
- Do **not** use wrappers such as `document`, `metadata`, or similar
- Only the fields listed below are allowed

If any rule is violated, do **not** store the note.

---

## Minimum acceptable note
A note must meet at least this standard:

```json
{
  "text": "<concrete command, endpoint, or learning>",
  "context": "<when or why this is useful>",
  "type": "<cli | api | learning | snippet | pattern>",
  "created_at": "<ISO-8601 timestamp>"
}
```

If you cannot fill in all required fields meaningfully, do not store the note.

---

## Fields and how to use them

### text (required)
The primary knowledge content.
- One command, endpoint, rule, or learning
- Must be understandable without chat history

Good examples:
- `kubectl rollout restart deployment my-app -n prod`
- `Avoid using async forEach in Node.js; it does not await promises`

Bad examples:
- `testing the note system`
- `this worked`

---

### context (required unless self-explanatory)
Explains **when, why, or how** the text is useful.
Include:
- Conditions
- Warnings
- Operational context

If you cannot explain the usefulness, do not store the note.

---

### type (required)
Choose exactly one:
- `cli`
- `api`
- `learning`
- `snippet`
- `pattern`

---

### tool (optional but recommended)
The tool, system, or service involved.

Examples:
- `kubectl`
- `aws`
- `terraform`
- `internal-api`
- `github-actions`

---

### tags (optional)
Short, lowercase keywords describing concepts or domains.

Examples:
- `kubernetes`
- `deployments`
- `auth`
- `debugging`

---

### language (optional)
Use for code or CLI-related notes.

Examples:
- `bash`
- `python`
- `yaml`
- `json`

---

### source (optional)
Where this knowledge applies.

Examples:
- `personal-notes`
- `repo:infra`
- `service:billing`
- `team:platform`

---

### created_at (required)
ISO-8601 timestamp.
Use the current date/time if not explicitly provided.

---

## Embedding guidance
- Dense embedding input:
  ```
  text + "\n\n" + context
  ```
- Sparse vector input:
  - Generate from `text` only (keywords, flags, identifiers)

---

## Tool usage
Use the **`qdrant-store`** MCP tool with:
- Dense vector
- Sparse vector
- Flat payload containing only the approved fields

---

## Pre-store quality checklist
Before storing, confirm:
- Would another agent benefit from this in 30 days?
- Is the note understandable without chat history?
- Does `context` clearly explain when or why it applies?
- Is this more than a test or confirmation?

If any answer is **no**, do not store the note.

---

## Agent reminder
When in doubt:
> **Check existing notes first. Store only what improves future decisions.**

