# Loadout

<p align="center">
  <img src="icon-resized.png" alt="A loadout crate of LLM skills" />
</p>

A curated loadout of modular skills—specialized tools and knowledge packs you can equip before tackling complex engineering missions.
Just like choosing the right gear in a game, this loadout ensures your agent has exactly what it needs to operate efficiently and solve problems with precision.

## What's Here

- **AGENTS.md** - Comprehensive guide for agents on creating skills
- **skills/** - Custom skill implementations

## Available Skills

- **brainstorming** - Refines rough ideas into fully-formed designs through collaborative questioning, alternative exploration, and incremental validation before writing code.
- **code-review** - Performs focused code reviews checking for obvious defects only, with minimal feedback and clear approval/rejection format.
- **create-pull-request** - Creates pull requests with clear, concise descriptions using available tools in the source repository.
- **executing-plans** - Loads and executes implementation plans in controlled batches with review checkpoints between each batch.
- **kubernetes-troubleshoot** - Troubleshoots and manages Kubernetes clusters using MCP server (preferred) or kubectl (fallback) for resource inspection and debugging.
- **loki-troubleshoot** - Helps craft efficient Grafana Loki/LogQL queries with label-based filtering and narrow time windows.
- **mimir-prometheus-troubleshoot** - Helps craft efficient Mimir/Prometheus queries and troubleshoot metric issues while avoiding high-cardinality problems.
- **tempo-troubleshoot** - Helps craft efficient Tempo trace queries and troubleshoot distributed traces with links to logs and metrics.
- **test-driven-development** - Implements features and bugfixes using TDD approach: write test first, watch it fail, write minimal code to pass.
- **user-story** - Creates well-structured user stories with clear acceptance criteria or task lists for software development.
- **writing-plans** - Creates comprehensive implementation plans with exact file paths, complete code examples, and verification steps.

## Creating Skills

See [AGENTS.md](./AGENTS.md) for detailed guidance on skill components, structure, and design principles.

## Reference

Based on the [Anthropic Skills specification](https://github.com/anthropics/skills).
