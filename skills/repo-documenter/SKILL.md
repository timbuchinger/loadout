---
name: repo-documenter
description: "Provide repository-wide documentation guidelines under `docs/`. Use tool-based inspection first. Keep README.md updated with a brief project overview and links to detailed docs created under `docs/`."
---

# Repository Documenter Skill

## General Guidance

This skill defines and maintains documentation guidelines for the repository. Primary documentation lives under:

```text
docs/
```

Always use **tool-based inspection first** (MCP tools if configured). Only fall back to CLI when necessary.

Documentation must always reflect **current reality**, not assumptions.

When asked to update documentation:

1. Inspect existing docs (if any).
2. Inspect code/configs/infrastructure via tools.
3. Determine which documentation files make sense for this project.
4. Create/update only relevant files.
5. Never guess — ask for confirmation if unclear.
6. Use **Mermaid diagrams** where they add clarity.

---

## Documentation Structure

### Index File (MANDATORY)

**Always create** For repository-level docs, ensure `docs/` contains `index.md` as an entry point for the reader.

This file should:

- Provide a brief overview of the system
- Link to other documentation pages (if any exist)
- Explain the system or repository structure in a way that's readable on its own
- Include a high-level diagram of key components where helpful

### Per-Application/Service Documentation

For repositories containing multiple applications, services, or agents, create a dedicated documentation file for each:

- `{app-name}.md` - Documentation for each distinct app/service/agent

Use the `app.md` template as guidance. Each app document should include:

- Brief purpose and responsibilities
- Architecture/component diagram
- Technology stack
- Key dependencies and integrations
- Links to relevant detailed documentation

Example: A repository with `service-a` and `service-b` should have `docs/service-a.md` and `docs/service-b.md`.

### Optional Supporting Documentation Files

Only create additional files if the repository complexity warrants them. Use these templates when relevant (templates live in the skill directory):

- `system-overview.md`
- `cloud-architecture.md`
- `service-architecture.md`
- `cicd-architecture.md`

You can also create custom documents based on the project's specific needs (for example `data-architecture.md`, `security-architecture.md`, `api-architecture.md`, or `usage.md`).

---

## Templates

Template files are provided in this skill directory and may be adapted to fit the project. Remove sections that don't apply, add sections that are needed.

- `index.md` - Entry point template
- `system-overview.md` - Optional system-level template
- `cloud-architecture.md` - Optional cloud infrastructure template
- `service-architecture.md` - Optional service/API template
- `cicd-architecture.md` - Optional CI/CD pipeline template

## Behavioral Rules

- **MANDATORY**: Ensure architecture entry points exist under `docs/architecture/` when architecture content is required.
- **MANDATORY**: Clean up the `docs/` directory when updating documentation. Remove obsolete files, consolidate outdated docs, and eliminate temporary planning/analysis documents that are no longer relevant.
- Use tool-based introspection before CLI.
- Ask for files or context when uncertain.
- Only create additional documents if the repository complexity warrants them.
- Update diagrams to match reality.
- Keep diagrams readable and scoped.
- Maintain consistency across documents.
- Filenames: All filenames MUST be lowercase and use dashes (-) as word separators. Do not use spaces or underscores.
- README maintenance: Keep the repository `README.md` up to date with a brief project overview and prominent links to the detailed documentation created under `docs/`. The README should be concise and point readers to `docs/` for full details.
- Suggested (non-mandatory): Add `docs/usage.md` to provide detailed usage guidelines and examples for users.
- If a suggested template doesn't fit, adapt or skip it.
- When in doubt about which files to create, ask the user.

## Documentation Cleanup

When updating documentation, actively maintain the `docs/` directory by:

1. **Identify Obsolete Content**: Remove or consolidate:
   - Draft/planning documents (e.g., `draft-*.md`, `planning-*.md`, `analysis-*.md`)
   - Superseded documentation (old architecture designs, deprecated setup guides)
   - Duplicate information that's now consolidated elsewhere
   - Temporary spike/exploration notes that are no longer relevant

2. **Consolidate Related Content**:
   - Move fragmented information into single authoritative documents
   - Remove redundant explanations that exist in multiple places
   - Ensure only current, active docs remain

3. **Maintain Directory Organization**:
   - Ensure `docs/apps/`, `docs/services/`, and other directories are clean
   - Remove empty or abandoned subdirectories
   - Keep structure flat unless there's complex nested documentation

4. **Verify Documentation Accuracy**:
   - Stale or outdated docs are actively removed, not left to decay
   - If content cannot be verified or updated to reflect current reality, delete it
   - Better to have gaps than misleading documentation

## Notes

- When adding `docs/usage.md`, include a `Recommended` section near the top with the preferred, simple way to run the app and an optional minimal example config if the app requires configuration.
