---
name: pr-create
description: Use when the user asks to create a pull request or PR for their work - creates PR using available tools with clear, concise title and description following standard template
---

# Create Pull Request

## Overview

Create pull requests with clear, concise descriptions. Use available tools to create PRs in the source repository.

**Core principle:** Brief title, focused summary, flag known issues upfront.

## When to Use

Use this skill when the user asks to create a PR, make a pull request, open a PR, or submit their work for review.

## User Intent

Listen for explicit submission intent. If the user says "Create a PR for this in GitHub" or "Create and submit PR," prepare to submit after showing a preview. If the user simply says "Create a pull request" without specifying submission, show the preview and ask before submitting.

**Default behavior:** Show the PR preview first, then ask the user if they want to submit it.

## Process

### 1. Gather Changes

Check git status for staged and committed changes, identify the branch being merged, and review commit messages for context.

### 2. Prepare PR Content

Collect the information needed for PR creation: the base branch (usually `main` or `master`), the head branch, a title (max 8 words), and a description following the template.

Identify the appropriate tool for the repository. Use `mcp_github_create_pull_request` or a similar tool for GitHub, GitLab tools for GitLab, Azure DevOps tools for Azure DevOps, or the platform-specific tool for other hosts.

### 3. Write Title

The title must be 8 words or fewer, start with a verb (Add, Fix, Update, Remove, Refactor), describe what changed rather than why, and be specific but concise.

**Good Examples:**

- "Add user authentication with OAuth"
- "Fix race condition in payment processing"
- "Update API error handling"
- "Remove deprecated logging utility"

**Bad Examples:**

- "Made some changes to the authentication system and updated tests" (too long)
- "Changes" (too vague)
- "This PR fixes the bug we talked about" (unclear)

### 4. Write Description

Follow the template in `template.md`. Keep it under 100 words unless the PR is large (10+ files or 500+ lines), involves complex changes that require explanation, or has important trade-offs to document.

The description has two sections: a Summary (2-3 sentences max) and an optional Known Issues section.

### 5. Show Preview and Ask for Confirmation

Always show the PR content to the user first, including the title, description, base and head branches, and target repository.

If the user indicated "create in GitHub" or "submit," ask: "Should I create this PR in the repository?" Otherwise ask: "Would you like me to create this PR?"

Only create the PR if the user confirms. If the user declines, they can edit the content, create the PR manually using the provided content, or request changes and have it regenerated.

## Using the Template

See `template.md` for the PR description template.

The Summary section should state what changed (1 sentence), why it changed if not obvious (1 sentence), and the impact or behavior change if relevant (1 sentence).

The Known Issues section should only be included if there are deliberate trade-offs or decisions that might be questioned. Keep each item to 1-2 sentences and omit the section entirely if everything is straightforward.

## Examples

### Example 1: Simple Feature

**Title:** Add email validation to signup form

**Description:**

```markdown
# Add email validation to signup form

## Summary
Adds client-side and server-side email validation to prevent invalid emails 
during signup. Uses regex pattern matching and DNS verification.

## Known Issues
Client-side validation uses regex instead of a library to avoid adding 
dependencies. Pattern covers 99% of valid emails per RFC 5322.
```

### Example 2: Bug Fix

**Title:** Fix pagination off-by-one error

**Description:**

```markdown
# Fix pagination off-by-one error

## Summary
Fixes pagination logic that was returning one extra item per page. Changed 
loop condition from `<=` to `<` in getUserPage().
```

### Example 3: Refactor

**Title:** Refactor auth middleware for testability

**Description:**

```markdown
# Refactor auth middleware for testability

## Summary
Extracts token validation into separate functions and adds dependency 
injection. Makes middleware easier to test and reduces coupling to 
external services.

## Known Issues
Some existing tests were updated to match new function signatures. Test 
behavior unchanged, only structure modified for better isolation.
```

## Guidelines

**Be brief:** Keep the title to 8 words max. Keep the summary to 2-3 sentences under 100 words. Omit obvious information and don't explain standard practices.

**Be clear:** State what changed and why if it isn't obvious. Use plain language and avoid jargon unless necessary.

**Be honest:** Flag deliberate trade-offs and explain controversial decisions. Don't hide issues or over-justify choices.

**Be focused:** Limit each PR to one logical change. Don't mix unrelated changes and keep the description relevant to the changes made.

## Common Mistakes to Avoid

Don't write lengthy descriptions for simple changes. Don't include a "Known Issues" section if there are none. Don't exceed 8 words in the title or be vague ("Updated stuff", "Fixed things"). Don't include step-by-step implementation details or list all files changed, since the reviewer can see them. Don't apologize or be overly cautious.

## Quick Reference

| Element      | Constraint                 | Purpose                   |
|--------------|----------------------------|---------------------------|
| Title | Max 8 words | Quick scan of what changed |
| Summary | 2-3 sentences (~50 words) | Core changes and rationale |
| Known Issues | Only if needed | Preempt review questions |
| Total length | <100 words typical | Respect reviewer time |

## Final Rule

```text
Clear title + brief summary + flag trade-offs = good PR
```

Keep it short. Make it clear.
