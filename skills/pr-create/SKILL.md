---
name: pr-create
description: Use when the user asks to create a pull request or PR for their work - creates PR using available tools with clear, concise title and description following standard template
---

# Create Pull Request

## Overview

Create brief, focused pull requests. Core principle: **Title + Summary + Flag Issues = Good PR**.

Use available tools to create PRs across GitHub, GitLab, Azure DevOps, and other platforms.

## When to Use

Use this skill when the user asks to create a PR, make a pull request, open a PR, or submit their work for review.

## User Intent

Listen for explicit submission intent. If the user says "Create a PR for this in GitHub" or "Create and submit PR," prepare to submit after showing a preview. If the user simply says "Create a pull request" without specifying submission, show the preview and ask before submitting.

**Default behavior:** Show the PR preview first, then ask the user if they want to submit it.

## Process

### 1. Gather Context

Check git status, identify base/head branches, and review commit messages.

### 2. Write Title (Continued)

**Rules:** Max 8 words, start with verb (Add, Fix, Update, Remove, Refactor), specific but concise.

✓ "Add OAuth to signup form" | ✗ "Made changes"

### 3. Write Description

Follow the template in `template.md`. Summary: what changed and why (2-3 sentences). Known Issues: only if trade-offs exist.

### 4. Show Preview & Confirm

Always show preview first (title, description, branches, repo). Ask user confirmation before creating.

If user said "submit" or "create in GitHub", ask: "Should I create this PR?" Otherwise: "Create this PR?"

Only proceed if confirmed.

## Examples

### Simple Feature

**Title:** Add email validation to signup form

```markdown
## Summary
Adds client-side and server-side email validation to prevent invalid emails.
Uses regex pattern matching and DNS verification.

## Known Issues
Client-side validation uses regex to avoid dependencies (covers 99% of emails per RFC 5322).
```

### Bug Fix

**Title:** Fix pagination off-by-one error

```markdown
## Summary
Fixes pagination logic returning one extra item per page. Changed loop condition from `<=` to `<`.
```

## Guidelines

- **Be brief** — Title: max 8 words. Summary: under 100 words. Omit obvious information.
- **Be clear** — State what and why. Use plain language.
- **Be honest** — Flag trade-offs upfront. Don't hide issues.
- **Be focused** — One logical change per PR. Keep description relevant.

## Quick Reference

| Element | Rule |
|---------|------|
| Title | Max 8 words, verb-first |
| Summary | 2-3 sentences, <100 words |
| Known Issues | Only if trade-offs exist |
| Preview | Always show before creating |
| Intent | "Create in GitHub" = submit; "create PR" = ask first |
