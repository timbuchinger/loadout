---
description: Increase test coverage by targeting untested branches and edge cases
tags: testing, coverage, unit-tests
---

# Expand Unit Tests

Expand existing unit tests adapted to the project's testing framework and this repository's conventions:

1. **Analyze coverage**: Run coverage report to identify untested branches, edge cases, and low-coverage areas
2. **Identify gaps**: Review code for logical branches, error paths, boundary conditions, null/empty inputs
3. **Write tests** using the project's framework:
   - Jest/Vitest/Mocha (JavaScript/TypeScript)
   - pytest/unittest (Python)
   - Go testing/testify (Go)
   - Rust test framework (Rust)
   - Bats (Bash scripts - see `skills/bats-testing-patterns` for comprehensive guidance)
4. **Target specific scenarios**:
   - Error handling and exceptions
   - Boundary values (min/max, empty, null)
   - Edge cases and corner cases
   - State transitions and side effects
5. **Verify improvement**: Run coverage again, confirm measurable increase

Present new test code blocks only. Follow existing test patterns and naming conventions in the repository.

## Repository-Specific Notes

When testing Bash scripts in this repository:

- Use the `bats-testing-patterns` skill for comprehensive Bash testing guidance
- Follow defensive patterns outlined in `bash-defensive-patterns` skill
- Ensure tests are idempotent and don't leave temporary files or state

When testing skills or commands:

- Reference `writing-skills` skill for testing skill documentation with subagents
- Verify markdown formatting with `npx markdownlint-cli2 "**/*.md"`
