---
description: Stage all changes, create commit, and push to remote (use with caution)
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git push:*), Bash(git diff:*), Bash(git log:*), Bash(git pull:*)
---

# Commit and Push Everything

⚠️ **CAUTION**: Stage ALL changes, commit, and push to remote. Use only when confident all changes belong together.

## Workflow

### 1. Analyze Repository and Changes

Run in parallel:

- `git status` - Show modified/added/deleted/untracked files
- `git diff --stat` - Show change statistics
- `git branch --show-current` - Show current branch name

**Check for repository-specific rules:**

- Look for `AGENTS.md`, `CONTRIBUTING.md`, `.github/CONTRIBUTING.md` for commit/branch naming conventions
- Check `.github/workflows/*.yml` for branch name patterns or commit message requirements
- If repo-specific rules exist, follow those exactly

### 2. Verify Branch Strategy

**Check current branch:**

- If on `main` or `master`:
  - Check if repo-specific rules allow direct commits to main
  - If unclear, **ASK USER**: "This repo may require feature branches. Should I create a new branch or commit to main?"
  - Wait for user response before proceeding

**Branch naming requirements (if creating new branch):**

- Must start with: `feature/`, `fix/`, `docs/`, `chore/`, `refactor/`, `test/`, or `perf/`
- Example: `feature/add-login`, `fix/api-error`, `docs/readme-update`

### 3. Safety Checks

**❌ STOP and WARN if detected:**

- Secrets: `.env*`, `*.key`, `*.pem`, `credentials.json`, `secrets.yaml`, `id_rsa`, `*.p12`, `*.pfx`, `*.cer`
- API Keys: Any `*_API_KEY`, `*_SECRET`, `*_TOKEN` variables with real values (not placeholders like `your-api-key`, `xxx`, `placeholder`)
- Large files: `>10MB` without Git LFS
- Build artifacts: `node_modules/`, `dist/`, `build/`, `__pycache__/`, `*.pyc`, `.venv/`
- Temp files: `.DS_Store`, `thumbs.db`, `*.swp`, `*.tmp`

**API Key Validation:**
Check modified files for patterns like:

```bash
OPENAI_API_KEY=sk-proj-xxxxx  # ❌ Real key detected!
AWS_SECRET_KEY=AKIA...         # ❌ Real key detected!
STRIPE_API_KEY=sk_live_...    # ❌ Real key detected!

# ✅ Acceptable placeholders:
API_KEY=your-api-key-here
SECRET_KEY=placeholder
TOKEN=xxx
API_KEY=<your-key>
SECRET=${YOUR_SECRET}
```

**✅ Verify:**

- `.gitignore` properly configured
- No merge conflicts
- Correct branch (warn if main/master)
- API keys are placeholders only

### 4. Request Confirmation

Present summary:

```text
📊 Changes Summary:
- X files modified, Y added, Z deleted
- Total: +AAA insertions, -BBB deletions

🔒 Safety: ✅ No secrets | ✅ No large files | ⚠️ [warnings]
🌿 Branch: [name] → origin/[name]

I will: git add . → commit → push

Type 'yes' to proceed or 'no' to cancel.
```

**WAIT for explicit "yes" before proceeding.**

### 5. Execute (After Confirmation)

Run sequentially:

```bash
git add .
git status  # Verify staging
```

### 6. Generate Commit Message

**Priority order for commit message rules:**

1. **Repository-specific rules** (if found in step 1):
   - Follow exactly as specified in `AGENTS.md`, `CONTRIBUTING.md`, or workflow files

2. **Conventional commits (default)** - Max 8 words, no body:

**Format:** `[type]: Brief summary (max 8 words)`

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`, `build`, `ci`

**Examples:**

```text
feat: Add user authentication system
fix: Resolve API timeout issue
docs: Update installation instructions
refactor: Simplify error handling logic
```

**DO NOT include:**

- Multi-line descriptions
- Body text or bullet points
- Detailed explanations

### 7. Commit and Push

```bash
git commit -m "[Generated commit message]"
git push || git pull --rebase && git push
git log -1 --oneline --decorate  # Verify
```

### 8. Confirm Success

```text
✅ Successfully pushed to remote!

Commit: [hash] [message]
Branch: [branch] → origin/[branch]
Files changed: X (+insertions, -deletions)
```

## Error Handling

**Common issues:**

- **git add fails**: Check file permissions or if repo is initialized
- **git commit fails**: Verify git config has user.name and user.email set
- **git push fails**: Try `git pull --rebase && git push` or check if remote branch exists

For protected branches, use the PR workflow instead.

## When to Use

✅ **Good:**

- Multi-file documentation updates
- Feature with tests and docs
- Bug fixes across files
- Project-wide formatting/refactoring
- Configuration changes

❌ **Avoid:**

- Uncertain what's being committed
- Contains secrets/sensitive data
- Protected branches without review
- Merge conflicts present
- Want granular commit history
- Pre-commit hooks failing

## Alternatives

If user wants control, suggest:

1. **Selective staging**: Review/stage specific files
2. **Interactive staging**: `git add -p` for patch selection
3. **PR workflow**: Create branch → push → PR (use `/pr` command)

**⚠️ Remember**: Always review changes before pushing. When in doubt, use individual git commands for more control.
