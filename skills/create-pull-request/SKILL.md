---
name: create-pull-request
description: Use when the user asks to create a pull request or PR for their work - creates PR using available tools with clear, concise title and description following standard template
---

# Create Pull Request

## Overview

Create pull requests with clear, concise descriptions. Use available tools to create PRs in the source repository.

**Core principle:** Brief title, focused summary, flag known issues upfront.

## When to Use

- User asks to create a PR
- User says "make a pull request"
- User requests "open a PR"
- User says "submit this for review"

## User Intent

**Listen for explicit submission intent:**

- "Create a PR for this in GitHub" → Prepare to submit after showing preview
- "Create and submit PR" → Prepare to submit after showing preview
- "Create a pull request" → Show preview, ask before submitting

**Default behavior:** Show PR preview first, then ask user if they want to submit it.

## Process

### 1. Gather Changes

Determine what's being submitted:

- Check git status for staged/committed changes
- Identify the branch being merged
- Review commit messages for context

### 2. Prepare PR Content

Determine information needed for PR creation:

- Base branch (usually `main` or `master`)
- Head branch (current working branch)
- Title (max 8 words)
- Description (following template)

Identify the appropriate tool for the repository:

- **GitHub**: `mcp_github_create_pull_request` or similar
- **GitLab**: Use GitLab tools if available
- **Azure DevOps**: Use Azure Devops tools if avilable
- **Other**: Use platform-specific PR creation tools

### 3. Write Title

**Requirements:**

- Maximum 8 words
- Start with verb (Add, Fix, Update, Remove, Refactor, etc.)
- Describe what changed, not why
- Be specific but concise

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

Follow the template in `template.md`. Keep it under 100 words unless:

- PR is large (10+ files or 500+ lines)
- Complex changes requiring explanation
- Important trade-offs to document

**Structure:**

1. Summary (2-3 sentences max)
2. Known Issues section (only if needed)

### 5. Show Preview and Ask for Confirmation

**Always show the PR content to the user first:**

Display:

- Title
- Description
- Base and head branches
- Target repository

Then ask:

- **If user indicated "create in GitHub" or "submit"**: Ask "Should I create this PR in the repository?"
- **If user didn't specify**: Ask "Would you like me to create this PR?"

**Only create the PR if user confirms.**

If user declines, they can:

- Edit the content
- Create the PR manually using the provided content
- Request changes and regenerate

## Using the Template

See `template.md` for the PR description template.

**Summary section:**

- What changed (1 sentence)
- Why it changed (1 sentence if not obvious)
- Impact/behavior change (1 sentence if relevant)

**Known Issues section:**

- Only include if there are deliberate trade-offs
- Explain rationale for decisions that might be questioned
- Keep each item to 1-2 sentences
- Omit this section if everything is straightforward

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

**Be brief:**

- Title: 8 words max
- Summary: 2-3 sentences (under 100 words)
- Omit obvious information
- Don't explain git or standard practices

**Be clear:**

- State what changed
- State why if not obvious
- Use plain language
- Avoid jargon unless necessary

**Be honest:**

- Flag deliberate trade-offs
- Explain controversial decisions
- Don't hide issues
- Don't over-justify

**Be focused:**

- One PR per logical change
- Don't mix unrelated changes
- Keep description relevant to changes

## Common Mistakes to Avoid

- Don't write novel-length descriptions for simple changes
- Don't include "Known Issues" if there aren't any
- Don't exceed 8 words in title
- Don't be vague ("Updated stuff", "Fixed things")
- Don't include step-by-step implementation details
- Don't list all files changed (reviewer can see this)
- Don't apologize or be overly cautious

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
