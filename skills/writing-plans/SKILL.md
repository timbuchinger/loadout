---
name: writing-plans
description: Use when design is complete and you need detailed implementation tasks - creates comprehensive implementation plans with exact file paths, complete code examples, and verification steps assuming minimal codebase familiarity
---

# Writing Plans

## Overview

Write comprehensive implementation plans assuming limited codebase context. Document everything needed: which files to touch for each task, code examples, testing approach, verification steps. Break work into bite-sized tasks following DRY, YAGNI, and TDD principles with frequent commits.

Assume the implementer is skilled but unfamiliar with the specific codebase and tooling.

## When to Use

- Design is complete and ready for implementation
- Need to break down work into concrete tasks
- Preparing work for delegation or future execution
- Want clear verification steps for each task

## Plan Location

Save plans to: `docs/plans/YYYY-MM-DD-<feature-name>.md`

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**

- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

Break larger tasks into these atomic steps. Each step should be independently verifiable.

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## Task Structure

```markdown
### Task N: [Component Name]

**Files:**

- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

**Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

**Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

**Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

**Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```

## Essential Elements

### Exact File Paths

Always specify complete paths:

- **Good**: `src/auth/validators.py`
- **Bad**: "the validators file"

For modifications, include line ranges if known: `config.json:45-52`

### Complete Code Examples

Include full, working code in the plan:

- **Good**: Show the complete function/test
- **Bad**: "Add validation for email field"

The implementer should be able to copy-paste code from the plan.

### Exact Commands

Specify complete commands with expected output:

```bash
# Run specific test
pytest tests/auth/test_login.py::test_invalid_email -v

# Expected output
FAIL: AssertionError: Expected validation error
```

### Verification Steps

Each task should explain how to verify it worked:

- What command to run
- What output to expect
- What to check manually if needed

## Commit Guidelines

Encourage frequent, atomic commits:

- One logical change per commit
- Meaningful commit messages
- Follow conventional commits format:
  - `feat:` for new features
  - `fix:` for bug fixes
  - `refactor:` for code changes without behavior change
  - `test:` for test-only changes
  - `docs:` for documentation

## Example Task

```markdown
### Task 1: Email Validation

**Files:**

- Create: `src/validators/email.py`
- Test: `tests/validators/test_email.py`

**Step 1: Write the failing test**

```python
# tests/validators/test_email.py
from src.validators.email import validate_email

def test_rejects_invalid_email():
    result = validate_email("notanemail")
    assert result == {"valid": False, "error": "Invalid format"}

def test_accepts_valid_email():
    result = validate_email("user@example.com")
    assert result == {"valid": True}
```

**Step 2: Run test to verify it fails**

Run: `pytest tests/validators/test_email.py -v`
Expected: FAIL with "ModuleNotFoundError: No module named 'src.validators.email'"

**Step 3: Write minimal implementation**

```python
# src/validators/email.py
import re

def validate_email(email):
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    if re.match(pattern, email):
        return {"valid": True}
    return {"valid": False, "error": "Invalid format"}
```

**Step 4: Run test to verify it passes**

Run: `pytest tests/validators/test_email.py -v`
Expected: PASS (2 tests)

**Step 5: Commit**

```bash
git add tests/validators/test_email.py src/validators/email.py
git commit -m "feat: add email validation"
```

## Best Practices

**Be specific:**

- Use exact file paths and line numbers
- Show complete code, not pseudocode
- Specify exact commands to run

**Be minimal:**

- Follow YAGNI - don't add features not in requirements
- Keep implementations simple
- Add complexity only when tests demand it

**Be testable:**

- Every feature has tests
- Tests written before implementation (TDD)
- Clear verification steps

**Be incremental:**

- Small commits after each working change
- Each task independently deliverable
- Build progressively

## Common Mistakes to Avoid

- Don't write "add validation" - show the exact validation code
- Don't write "update config" - show exact config changes
- Don't skip test commands - always show how to verify
- Don't make tasks too large - break down into 2-5 minute steps
- Don't assume knowledge of project structure - specify full paths

## Quick Reference

| Element | Required | Example |
|---------|----------|---------|
| File paths | Always exact | `src/auth/login.py` |
| Code examples | Complete & working | Full function/test |
| Commands | With expected output | `pytest path/test.py -v` → PASS |
| Commits | After each task | `git commit -m "feat: add feature"` |
| Granularity | 2-5 min per step | One action per step |

## Final Rule

```text
Plans should be executable by someone skilled but unfamiliar.
Every step: exact paths, complete code, clear verification.
```

Clear plans enable confident execution.
