---
name: architecture-documenter
description: "Maintain and update architecture documentation in docs/architecture/. Uses tool-based inspection first, falling back to CLI only when needed."
---

# Architecture Documenter Skill

## General Guidance

This skill maintains a minimal set of architecture documents under:

```text
docs/architecture/
```

Always use **tool-based inspection first** (MCP tools if configured).  
Only fall back to CLI when necessary.

Documentation must always reflect **current reality**, not assumptions.  
If documentation files do not exist, the skill initializes them.

When asked to update documentation:

1. Inspect existing docs.
2. Inspect code/configs/infrastructure via tools.
3. Reconcile differences.
4. Update only the necessary sections.
5. Never guess — ask for confirmation if unclear.
6. Use **Mermaid diagrams** in every file.

---

## Required Documentation Files

### 1. system-overview.md

High-level map of the entire system, major components, and external integrations.

### 2. cloud-architecture.md

Cloud deployment topology, networking model, load balancers, compute layers, storage.

### 3. service-architecture.md

Internal services, modules, queues, APIs, and data flows.

### 4. cicd-architecture.md

Build, test, artifact creation, deployment flow, environments.

---

## Behavioral Rules

- Use tool-based introspection before CLI.
- Ask for files or context when uncertain.
- Update diagrams to match reality.
- Keep diagrams readable and scoped.
- Maintain consistency across documents.
- Generate missing files automatically.
