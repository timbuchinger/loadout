---
name: executing-plans
description: Use when given a complete implementation plan to execute in controlled batches with review checkpoints - loads plan, reviews critically, executes tasks in batches, reports for review between batches
---

# Executing Plans

## Overview

Load plan, review critically, execute tasks in batches, report for review between batches.

**Core principle:** Batch execution with checkpoints for review and feedback.

## When to Use

- Partner provides a complete implementation plan
- Plan has detailed tasks with verification steps
- Work benefits from checkpoint reviews
- Executing work created by writing-plans skill

## The Process

### Step 1: Load and Review Plan

1. Read the plan file (typically in `docs/plans/`)
2. Review critically - identify any questions or concerns
3. Check for:
   - Missing information or unclear steps
   - Potential blockers or dependencies
   - Inconsistencies or gaps in approach
4. **If concerns**: Raise them with your partner before starting
5. **If no concerns**: Create todo list and proceed

### Step 2: Execute Batch

#### Default: First 3 tasks

For each task in the batch:

1. Mark task as in_progress in todo list
2. Follow each step exactly (plans have bite-sized steps)
3. Run all verification steps as specified
4. Confirm tests pass and changes work
5. Mark task as completed

**Follow the plan precisely:**

- Execute steps in order
- Run commands as specified
- Verify expected output
- Don't skip verification steps
- Don't deviate from plan unless blocked

### Step 3: Report

When batch complete:

- Summarize what was implemented
- Show verification output (test results, command output)
- Highlight any issues or deviations
- Say: "Ready for feedback."

**Keep reports concise but complete:**

- Which tasks were completed
- Key changes made
- Verification results
- Any concerns or questions

### Step 4: Continue

Based on feedback:

- Apply requested changes if needed
- Execute next batch (next 3 tasks)
- Repeat until all tasks complete

### Step 5: Complete Development

After all tasks complete and verified:

- Run full test suite
- Verify all changes work together
- Review what was built
- Consider next steps (PR, deployment, etc.)

## When to Stop and Ask

**STOP executing immediately when:**

- Hit a blocker mid-batch (missing dependency, test fails unexpectedly)
- Instructions are unclear or ambiguous
- Verification fails repeatedly
- Discover plan has critical gaps
- Approach seems incorrect

**Ask for clarification rather than guessing.**

Don't try to work around blockers - stop and get guidance.

## When to Revisit Earlier Steps

**Return to Review (Step 1) when:**

- Partner updates the plan based on feedback
- Fundamental approach needs rethinking
- New information changes requirements

**Don't force through blockers** - stop and ask.

## Best Practices

**Be systematic:**

- Follow plan order unless advised otherwise
- Complete one task fully before starting next
- Don't skip ahead or batch tasks differently

**Be thorough:**

- Run all verification steps
- Check for unexpected side effects
- Verify changes work as intended

**Be communicative:**

- Report clearly at checkpoints
- Flag concerns early
- Ask when uncertain

**Be precise:**

- Follow instructions exactly
- Use exact file paths from plan
- Run exact commands specified

## Example Execution

### Batch 1 Report

```text
Completed tasks 1-3:

Task 1: Email Validation
- Created src/validators/email.py
- Created tests/validators/test_email.py
- Tests pass: 2/2 ✓

Task 2: User Model Update
- Modified src/models/user.py
- Added email field validation
- Tests pass: 5/5 ✓

Task 3: API Endpoint
- Created src/api/auth.py
- Integrated email validation
- Tests pass: 3/3 ✓

All verifications passed. Ready for feedback.
```

## Common Mistakes to Avoid

- Don't deviate from the plan without approval
- Don't skip verification steps to save time
- Don't batch more tasks than specified
- Don't continue when blocked
- Don't assume what the plan meant - ask

## Quick Reference

| Step     | Action                        | When to Stop   |
|----------|-------------------------------|----------------|
| 1. Load      | Review plan critically         | Concerns found |
| 2. Execute   | Implement 3 tasks              | Blocker hit    |
| 3. Report    | Show results, ask for feedback | -              |
| 4. Continue  | Next batch based on feedback   | All tasks done |
| 5. Complete  | Final verification             | -              |

## Final Rule

```text
Follow the plan exactly.
Stop when blocked or uncertain.
Report at checkpoints.
```

Trust the plan, but verify everything.
