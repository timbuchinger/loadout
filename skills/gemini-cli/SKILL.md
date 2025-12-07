---
name: gemini-cli
description: "Use Gemini CLI for analyzing large codebases or multiple files that exceed context limits. Leverage Google Gemini's massive context window with `gemini -p` and `@` syntax for file/directory inclusion to verify implementations, check patterns, and understand project-wide architecture."
---

# Gemini CLI for Large Codebase Analysis

## What this Skill does

When you need to analyze large codebases, multiple files, or entire directories that might exceed your context window, use the Gemini CLI. This tool provides access to Google Gemini's large context capacity, allowing you to:

- Analyze entire codebases or large directories
- Compare multiple large files simultaneously
- Understand project-wide patterns or architecture
- Verify if specific features, patterns, or security measures are implemented
- Check for the presence of certain coding patterns across the entire codebase
- Work with files totaling more than 100KB

## File and Directory Inclusion Syntax

Use the `@` syntax to include files and directories in your Gemini prompts. **Important**: Paths are relative to WHERE you run the gemini command.

### Single File Analysis

```bash
gemini -p "@src/main.py Explain this file's purpose and structure"
```

### Multiple Files

```bash
gemini -p "@package.json @src/index.js Analyze the dependencies used in the code"
```

### Entire Directory

```bash
gemini -p "@src/ Summarize the architecture of this codebase"
```

### Multiple Directories

```bash
gemini -p "@src/ @tests/ Analyze test coverage for the source code"
```

### Current Directory and Subdirectories

```bash
gemini -p "@./ Give me an overview of this entire project"
```

Or use the `--all_files` flag:

```bash
gemini --all_files -p "Analyze the project structure and dependencies"
```

## Implementation Verification Examples

### Check if a Feature is Implemented

```bash
gemini -p "@src/ @lib/ Has dark mode been implemented in this codebase? Show me the relevant files and functions"
```

### Verify Authentication Implementation

```bash
gemini -p "@src/ @middleware/ Is JWT authentication implemented? List all auth-related endpoints and middleware"
```

### Check for Specific Patterns

```bash
gemini -p "@src/ Are there any React hooks that handle WebSocket connections? List them with file paths"
```

### Verify Error Handling

```bash
gemini -p "@src/ @api/ Is proper error handling implemented for all API endpoints? Show examples of try-catch blocks"
```

### Check for Rate Limiting

```bash
gemini -p "@backend/ @middleware/ Is rate limiting implemented for the API? Show the implementation details"
```

### Verify Caching Strategy

```bash
gemini -p "@src/ @lib/ @services/ Is Redis caching implemented? List all cache-related functions and their usage"
```

### Check for Specific Security Measures

```bash
gemini -p "@src/ @api/ Are SQL injection protections implemented? Show how user inputs are sanitized"
```

### Verify Test Coverage for Features

```bash
gemini -p "@src/payment/ @tests/ Is the payment processing module fully tested? List all test cases"
```

## When to Use Gemini CLI

Use `gemini -p` when:

- Analyzing entire codebases or large directories
- Comparing multiple large files
- Need to understand project-wide patterns or architecture
- Current context window is insufficient for the task
- Working with files totaling more than 100KB
- Verifying if specific features, patterns, or security measures are implemented
- Checking for the presence of certain coding patterns across the entire codebase

## Important Notes

- Paths in `@` syntax are relative to your current working directory when invoking gemini
- The CLI will include file contents directly in the context
- No need for `--yolo` flag for read-only analysis
- Gemini's context window can handle entire codebases that would overflow Claude's context
- When checking implementations, be specific about what you're looking for to get accurate results
- Always navigate to the appropriate directory before running gemini commands to ensure relative paths work correctly
