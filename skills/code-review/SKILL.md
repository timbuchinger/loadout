---
name: code-review
description: Use when the user asks to review code or a pull request - performs focused review checking for obvious defects only, provides minimal feedback with clear approval/rejection format
---

# Code Review

## Overview

Perform focused code reviews that identify only obvious defects. Keep feedback minimal and actionable.

**Core principle:** Catch critical issues, not nitpicks. Approve when code is solid, reject with clear priorities when it's not.

## When to Use

- User asks to review a pull request
- User asks to review code changes
- User requests code feedback
- User asks "can you review this?"

## Review Process

### 1. Retrieve the Code

Use available tools to get the PR or code:

- GitHub tools for PRs (`get_pull_request`, `get_file_contents`)
- Git tools for local changes (`git diff`, `git show`)
- Read files directly if paths provided

### 2. Focus on Obvious Defects

**Check for:**

- **Security vulnerabilities** - SQL injection, XSS, hardcoded secrets, unsafe dependencies
- **Correctness bugs** - Logic errors, off-by-one errors, null/undefined handling, race conditions
- **Breaking changes** - API changes, removed functionality, incompatible modifications
- **Critical performance issues** - N+1 queries, memory leaks, blocking operations
- **Test coverage gaps** - Missing tests for new logic, untested edge cases

**Ignore:**

- Style preferences (unless blocking)
- Minor refactoring opportunities
- Documentation suggestions (unless critical)
- Theoretical optimizations
- Personal preferences

### 3. Provide Verdict

#### If Approved

Provide brief explanation, then end with the approval format:

```text
The changes look solid because [brief reason].

Approved - [3-5 words summarizing why]
```

**Examples:**

- "Approved - Clean implementation, well tested"
- "Approved - Straightforward bug fix"
- "Approved - Good error handling"
- "Approved - Simple refactor, no issues"

#### If Not Approved

Provide prioritized list of issues:

```text
Cannot approve due to:

1. [Critical issue with specific location]
2. [Important issue with specific location]
3. [Blocking issue with specific location]

[Additional context if needed]
```

**Prioritization:**

1. Security vulnerabilities (always first)
2. Correctness bugs
3. Breaking changes
4. Critical performance issues
5. Missing test coverage for new logic

## Review Examples

### Example 1: Simple Approval

```text
Reviewed the authentication fix in auth.ts. The null check properly handles 
the edge case and the test coverage is good.

Approved - Solid fix, well tested
```

### Example 2: Security Issue

```text
Cannot approve due to:

1. SQL injection vulnerability in getUserData() (line 45) - uses string 
   concatenation instead of parameterized query
2. Missing input validation on email parameter (line 23) - accepts 
   unsanitized user input

These need to be fixed before merging.
```

### Example 3: Logic Bug

```text
Cannot approve due to:

1. Off-by-one error in pagination logic (line 102) - should be `i < limit` 
   not `i <= limit`
2. Missing null check before accessing user.profile (line 87) - will crash 
   if profile is undefined

Fix these issues and re-request review.
```

## Guidelines

**Be specific:**

- Reference line numbers or function names
- Explain the actual problem
- Don't be vague ("this could be better")

**Be minimal:**

- Only mention obvious issues
- Skip style nitpicks unless they cause bugs
- Don't suggest refactors unless code is broken

**Be clear:**

- Use numbered lists for multiple issues
- Put most critical issues first
- State exactly what needs fixing

**Be helpful:**

- Explain why something is a problem
- Suggest fix if it's not obvious
- Keep tone constructive

## Common Pitfalls to Avoid

- Don't approve with caveats ("Approved but you should...") - either approve or reject
- Don't list non-blocking suggestions in rejection - only blocking issues
- Don't review style unless it causes bugs
- Don't request tests for trivial changes
- Don't mention theoretical edge cases without clear impact

## Quick Reference

| Situation                   | Action                          |
|-----------------------------|--------------------------------|
| No obvious defects | Approve with brief reason |
| Security issue | Reject, list as #1 priority |
| Logic bug | Reject, explain the bug |
| Missing critical tests | Reject if new logic untested |
| Style issues only | Approve, ignore style |
| Minor improvements possible | Approve, don't mention |

## Final Rule

```text
Obvious defects → Reject with priorities
No obvious defects → Approve with brief reason
```

Keep it simple. Catch the important stuff.
