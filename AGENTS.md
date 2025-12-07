# Agent Guide: Creating Skills for Claude Code

## What Are Skills?

Skills are modular, self-contained packages that extend Claude's capabilities by providing specialized knowledge, workflows, and tools. Think of them as "onboarding guides" for specific domains or tasks—they transform Claude from a general-purpose agent into a specialized agent equipped with procedural knowledge.

Skills are folders of instructions, scripts, and resources that Claude loads dynamically to improve performance on specialized tasks. They teach Claude how to complete specific tasks in a repeatable way.

## CRITICAL: Markdown Linting

**ALWAYS ensure markdownlint passes after every change to any Markdown file.**

This repository uses markdownlint to maintain consistent formatting. After making ANY changes to `.md` files:

1. **Run markdownlint locally on ALL files** (same as CI):

   ```bash
   npx markdownlint-cli2 "**/*.md"
   ```

2. Fix all linting errors before committing
3. Verify the command returns `Summary: 0 error(s)`

The repository includes `.markdownlint.json` configuration. All Markdown files must pass linting with this configuration.

**CRITICAL: Do NOT rely on `get_errors` or VS Code extension alone** - these only check files in VS Code's context, not all markdown files. Always run `markdownlint-cli2` on the entire repository to match CI behavior exactly.

**Never commit Markdown files with linting errors.**

## CRITICAL: README Maintenance

**ALWAYS update the "Available Skills" section in README.md when creating, modifying, or removing skills.**

After creating, updating, or removing a skill:

1. Update the skill list in `README.md` under "Available Skills"
2. Provide a 1-2 sentence high-level overview of what the skill does
3. Keep entries in alphabetical order
4. Ensure the description is concise and matches the skill's actual purpose

This ensures users can quickly discover and understand available skills without diving into individual SKILL.md files.

## CRITICAL: Marketplace Manifest Maintenance

**ALWAYS update `.claude-plugin/marketplace.json` when creating, modifying, or removing skills.**

After creating, updating, or removing a skill:

1. Add/remove/update the skill path in the `skills` array under the `loadout-skills` plugin
2. Keep skill paths in alphabetical order
3. Update the plugin's `description` field if the overall collection's scope changes
4. Ensure all skill paths use the format `./skills/skill-name`

The marketplace.json file defines the skill collection for Claude and must stay synchronized with the actual skills directory. All skills should be in a single plugin named `loadout-skills`.

## Skill Components

Every skill consists of two main parts:

### 1. SKILL.md (Required)

The `SKILL.md` file is the only required component. It serves as the skill's entrypoint and contains:

#### YAML Frontmatter (Required)

The frontmatter has 2 required fields:

- **`name`**: The skill name in hyphen-case (lowercase, alphanumeric + hyphens only). Must match the directory name.
- **`description`**: A complete description of what the skill does and when to use it. This is the PRIMARY TRIGGERING MECHANISM for your skill.
  - Include both WHAT the skill does and WHEN to use it
  - Include specific scenarios, file types, or tasks that trigger it
  - All "when to use" information must be here—the body is only loaded after triggering

Optional fields:

- **`license`**: The license applied to the skill
- **`allowed-tools`**: List of pre-approved tools to run (Claude Code only)
- **`metadata`**: Map of custom key-value pairs for client-specific properties

#### Markdown Body (Required)

Instructions and guidance for using the skill. This is only loaded AFTER the skill triggers based on the description. Contains:

- Workflow instructions
- Usage guidelines
- Examples
- References to bundled resources

**Best Practice**: Keep the body under 500 lines. If approaching this limit, split content into separate reference files.

### 2. Bundled Resources (Optional)

Skills can include additional directories with supporting resources:

#### `scripts/` Directory

Executable code (Python, Bash, etc.) for tasks that require deterministic reliability or are repeatedly rewritten.

- **When to include**: When the same code is being rewritten repeatedly or deterministic reliability is needed
- **Examples**: `rotate_pdf.py`, `extract_form_fields.py`
- **Benefits**: Token efficient, deterministic, may be executed without loading into context
- **Note**: Scripts may still need to be read by Claude for patching or environment-specific adjustments

#### `references/` Directory

Documentation and reference material intended to be loaded as needed into context to inform Claude's process.

- **When to include**: For documentation that Claude should reference while working
- **Examples**: Database schemas, API documentation, company policies, workflow guides
- **Use cases**: `schema.md`, `api_reference.md`, `policies.md`
- **Benefits**: Keeps SKILL.md lean, loaded only when Claude determines it's needed
- **Best practice**: For large files (>10k words), include grep search patterns in SKILL.md
- **Avoid duplication**: Information should live in either SKILL.md or references, not both

#### `assets/` Directory

Files not intended to be loaded into context, but rather used within the output Claude produces.

- **When to include**: When the skill needs files that will be used in the final output
- **Examples**: `logo.png`, `template.pptx`, `frontend-boilerplate/`, `font.ttf`
- **Use cases**: Templates, images, icons, boilerplate code, fonts, sample documents
- **Benefits**: Separates output resources from documentation, enables Claude to use files without loading them

## Skill Structure

A typical skill folder looks like this:

```text
my-skill/
├── SKILL.md                    # Required entrypoint
└── (Optional resources)
    ├── scripts/                # Executable code
    │   ├── process.py
    │   └── validate.sh
    ├── references/             # Documentation
    │   ├── api_docs.md
    │   └── schema.md
    └── assets/                 # Output resources
        ├── template.html
        └── logo.png
```

## How to Create a Skill

Follow these steps in order:

### Step 1: Understand the Skill with Concrete Examples

Start with 2-3 concrete user requests that the skill should handle:

- "Help me rotate this PDF"
- "Build me a todo app"
- "Write a company newsletter"

Having concrete examples helps identify what resources the skill needs and how to structure the workflow.

### Step 2: Plan Reusable Skill Contents

Analyze each example to determine what scripts, references, and assets would be helpful:

- Does the task require rewriting the same code repeatedly? → Add to `scripts/`
- Does it need reference to schemas, APIs, or documentation? → Add to `references/`
- Does it use templates, images, or boilerplate files? → Add to `assets/`

**Example**: For a `pdf-editor` skill handling "rotate this PDF":

1. Rotating requires rewriting the same code each time
2. A `scripts/rotate_pdf.py` would be helpful

**Example**: For a `bigquery` skill handling "How many users logged in today?":

1. Querying requires rediscovering schemas each time
2. A `references/schema.md` documenting tables would be helpful

### Step 3: Initialize the Skill

Create the basic skill structure. The minimal structure is:

```bash
mkdir my-skill
cd my-skill
```

Create a `SKILL.md` file with this template:

```markdown
---
name: my-skill-name
description: A clear description of what this skill does and when to use it
---

# My Skill Name

[Add your instructions here that Claude will follow when this skill is active]

## Examples
- Example usage 1
- Example usage 2

## Guidelines
- Guideline 1
- Guideline 2
```

### Step 4: Edit the Skill

#### Update SKILL.md

**Writing Guidelines**: Always use imperative/infinitive form.

**Frontmatter**:

- Write a descriptive `name` in hyphen-case
- Write a comprehensive `description` that includes WHAT the skill does and WHEN to use it
- Include specific triggers: file types, scenarios, task types

**Body**:

- Write instructions for using the skill and its bundled resources
- Reference scripts, references, and assets as needed
- Keep it concise (under 500 lines)
- Use clear section structure

#### Common Structure Patterns

Choose the structure that fits your skill:

**1. Workflow-Based** (for sequential processes):

- Structure: Overview → Workflow Decision Tree → Step 1 → Step 2...
- Example: Document editing with clear step-by-step procedures

**2. Task-Based** (for tool collections):

- Structure: Overview → Quick Start → Task Category 1 → Task Category 2...
- Example: PDF skill with Merge, Split, Extract operations

**3. Reference/Guidelines** (for standards or specifications):

- Structure: Overview → Guidelines → Specifications → Usage...
- Example: Brand guidelines with Colors, Typography, Features

**4. Capabilities-Based** (for integrated systems):

- Structure: Overview → Core Capabilities → Feature 1 → Feature 2...
- Example: Product management with numbered capability list

#### Add Bundled Resources

Create supporting files as planned:

**Scripts**: Add executable code to `scripts/`

```bash
mkdir scripts
# Add your Python/Bash scripts
```

**References**: Add documentation to `references/`

```bash
mkdir references
# Add your reference documentation
```

**Assets**: Add output resources to `assets/`

```bash
mkdir assets
# Add your templates, images, etc.
```

### Step 5: Test and Iterate

Use the skill with real user requests and refine based on:

- What worked well
- What Claude struggled with
- What additional resources would help
- Whether the description triggers appropriately

## Reviewing and Customizing Existing Skills

When bringing in skills from external sources (such as the Anthropic Skills repository or other skill collections), **always review and customize them** before adding them to the loadout.

### Review Process

Before accepting an external skill:

1. **Read the entire skill** - Understand what it does, how it works, and when it triggers
2. **Evaluate fit** - Ensure it aligns with the repository's goals and doesn't duplicate existing functionality
3. **Check quality** - Verify the skill follows the design principles outlined in this guide
4. **Test the examples** - Run through the provided examples to ensure they work as expected

### Customization Requirements

**You must customize external skills** to ensure they are unique to this repository and optimized for agent effectiveness:

#### 1. Customize Examples

- **Replace generic examples** with specific, relevant scenarios from this repository's domain
- **Add concrete details** that make examples more actionable and less abstract
- **Ensure uniqueness** - Examples should reflect the specific use cases and context of this repository
- **Test examples work** - Verify that customized examples actually function as intended

#### 2. Optimize Content

Apply enhancements that improve agent effectiveness:

- **Clarify ambiguous instructions** - Make steps more explicit and actionable
- **Add missing context** - Include domain-specific knowledge or prerequisites
- **Improve triggering** - Refine the description to trigger appropriately for this repository's use cases
- **Strengthen workflows** - Add decision trees, checkpoints, or validation steps where helpful
- **Remove redundancy** - Eliminate duplicate or unnecessary content

#### 3. Augment Capabilities

Enhance the skill with improvements that benefit agents:

- **Add references** - Include relevant documentation or schemas in `references/` directory
- **Bundle scripts** - Add helper scripts in `scripts/` directory for repetitive tasks
- **Include assets** - Add templates or boilerplate in `assets/` directory
- **Expand guidelines** - Add best practices or common pitfalls specific to your context

### Goals of Customization

The goal is **optimization and augmentation**, not total revamping:

- ✅ **Do:** Customize examples, clarify instructions, add helpful resources
- ✅ **Do:** Improve clarity, add context, strengthen workflows
- ✅ **Do:** Make the skill more effective for agents in this repository
- ❌ **Don't:** Completely rewrite the skill's core logic or purpose
- ❌ **Don't:** Change the fundamental approach unless it's clearly broken
- ❌ **Don't:** Remove working features without good reason

### Example Customization

**Before (Generic):**

```markdown
## Examples
- Process data from API
- Transform results
- Save to database
```

**After (Customized):**

```markdown
## Examples
- Fetch customer orders from the Shopify API using stored credentials
- Transform order data to match the internal schema defined in `references/schema.md`
- Save normalized orders to PostgreSQL using the connection pool in `config/database.ts`
```

The customized version provides:

- Specific APIs and tools (Shopify, PostgreSQL)
- References to actual repository files
- Clear, actionable steps tied to the codebase

### Integration Checklist

Before adding an external skill to the repository:

- [ ] Read and understand the entire skill
- [ ] Customize all examples with repository-specific details
- [ ] Clarify any ambiguous instructions
- [ ] Add helpful enhancements (references, scripts, assets) where appropriate
- [ ] Update README.md with the skill description
- [ ] Update `.claude-plugin/marketplace.json` with the skill path
- [ ] Test the skill with real scenarios
- [ ] Verify markdown passes linting with `npx markdownlint-cli2 "**/*.md"`

## Core Design Principles

### 1. Concise is Key

- Keep SKILL.md under 500 lines
- Move detailed content to reference files
- Only include essential information

### 2. Progressive Disclosure

Skills use a three-level loading system:

1. **Metadata** (name + description) - Always in context (~100 words)
2. **SKILL.md body** - When skill triggers (<5k words)
3. **Bundled resources** - As needed by Claude (unlimited)

Keep content at the appropriate level to minimize context bloat.

### 3. Clear Triggering

The `description` field determines when the skill activates. Make it:

- Comprehensive about what the skill does
- Specific about when to use it (scenarios, file types, tasks)
- Clear about the skill's capabilities

### 4. Avoid Duplication

- Information should live in SKILL.md OR references, not both
- Prefer references for detailed information
- Keep only essential procedural instructions in SKILL.md

### 5. What NOT to Include

Do NOT create extraneous files:

- README.md
- INSTALLATION_GUIDE.md
- CHANGELOG.md
- QUICK_REFERENCE.md

The skill should only contain information needed for an AI agent to do the job, not documentation about the creation process.

## Example: Minimal Skill

```text
greeting-skill/
└── SKILL.md
```

**SKILL.md**:

```markdown
---
name: greeting-skill
description: Generates personalized greetings for different occasions and contexts. Use when the user asks for a greeting, welcome message, or formal salutation.
---

# Greeting Skill

Generate personalized greetings based on context.

## Guidelines
- Match formality to the occasion
- Include relevant details (time of day, event, relationship)
- Default to friendly but professional tone

## Examples
- "Good morning, welcome to the team!"
- "Dear valued customer, thank you for your purchase."
```

## Example: Complex Skill

```text
pdf-processor/
├── SKILL.md
├── scripts/
│   ├── rotate_pdf.py
│   ├── merge_pdfs.py
│   └── extract_text.py
├── references/
│   ├── pdf_library_docs.md
│   └── common_issues.md
└── assets/
    └── watermark.png
```

**SKILL.md**:

```markdown
---
name: pdf-processor
description: Comprehensive PDF manipulation toolkit for extracting text, merging/splitting documents, rotating pages, and adding watermarks. Use when Claude needs to programmatically process, generate, or analyze PDF documents.
---

# PDF Processor

## Quick Start

For common operations, use the provided scripts:
- Rotate pages: `scripts/rotate_pdf.py`
- Merge PDFs: `scripts/merge_pdfs.py`
- Extract text: `scripts/extract_text.py`

## Workflow

1. Identify the operation needed
2. Run the appropriate script
3. Verify the output

See `references/pdf_library_docs.md` for detailed API documentation.
```

## Resources

For more information:

- [Agent Skills Spec](https://github.com/anthropics/skills/blob/main/spec/agent-skills-spec.md) - Official specification
- [Skill Examples](https://github.com/anthropics/skills/tree/main/skills) - Browse real-world skills
- [Anthropic Skills Documentation](https://support.claude.com/en/articles/12512198-creating-custom-skills)

## Quick Reference

**Minimum Requirements**:

- Folder with a `SKILL.md` file
- YAML frontmatter with `name` and `description`
- Markdown body with instructions

**Best Practices**:

- Keep SKILL.md under 500 lines
- Put "when to use" information in the description
- Use bundled resources for reusable content
- Structure content using progressive disclosure
- Test with concrete examples
- Iterate based on real usage

**Common Patterns**:

- Sequential workflows for step-by-step processes
- Task-based organization for tool collections
- Reference documentation for complex domains
- Asset bundling for templates and resources
