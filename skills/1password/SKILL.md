---
name: 1password
description: Manage personal secrets and passwords using 1Password CLI (op). Use when the user asks to query, retrieve, create, or manage secrets in 1Password, 1p, or op. This is for personal secrets only - not for cloud provider secret managers like Azure Key Vault, AWS Secrets Manager, or GCP Secret Manager.
---

# 1Password CLI

Manage personal secrets and passwords using the 1Password CLI (`op`).

## CRITICAL RULES

1. **Tag Filter**: Only read secrets that have the `agents` tag. All queries MUST include `--tags agents` filter.
2. **Confirmation Required**: Always confirm with the user before creating or modifying secrets. No confirmation is needed for reading secrets.

## Prerequisites

Before using any `op` commands, ensure:

1. 1Password CLI is installed (`op --version`)
2. Desktop app integration is enabled (Settings > Developer > Integrate with 1Password CLI)
3. User is signed in (run any command to trigger authentication)

## Common Operations

### List Items

List items tagged for agent access:

```bash
op item list --tags agents
```

List items by category:

```bash
op item list --tags agents --categories Login
op item list --tags agents --categories Password
op item list --tags agents --categories "API Credential"
```

List items in a specific vault:

```bash
op item list --tags agents --vault Personal
```

### Get Item Details

Get full details for an item:

```bash
op item get "Item Name" --tags agents
```

Get specific fields:

```bash
op item get "GitHub Token" --tags agents --fields label=username,label=password
```

Get in JSON format:

```bash
op item get "API Key" --tags agents --format json
```

Get one-time password (OTP):

```bash
op item get "Google" --tags agents --otp
```

### Read Secret Values

Use `op read` with secret references for direct value retrieval:

```bash
op read "op://Personal/GitHub Token/password"
op read "op://Personal/API Key/credential"
```

Secret reference format:

```
op://vault-name/item-name/[section-name/]field-name
```

### Create Items

**ALWAYS confirm with user before creating items.**

Create a Login item:

```bash
op item create --category=login \
  --title='Service Name' \
  --vault='Personal' \
  --url='https://example.com' \
  --tags='agents' \
  username='user@example.com' \
  password='secure-password'
```

Create an API Credential:

```bash
op item create --category="API Credential" \
  --title='Service API' \
  --vault='Personal' \
  --tags='agents' \
  credential='api-key-value'
```

Create a Password item:

```bash
op item create --category=password \
  --title='Database Password' \
  --vault='Personal' \
  --tags='agents' \
  password='secure-password'
```

Create with auto-generated password:

```bash
op item create --category=login \
  --title='New Service' \
  --vault='Personal' \
  --tags='agents' \
  --url='https://example.com' \
  --generate-password='letters,digits,symbols,32' \
  username='user@example.com'
```

### Edit Items

**ALWAYS confirm with user before editing items.**

Edit a field value:

```bash
op item edit 'Service Name' 'password=new-password'
```

Add or update tags (preserving the `agents` tag):

```bash
op item edit 'Service Name' --tags='agents,production,api'
```

Generate new password:

```bash
op item edit 'Service Name' --generate-password='letters,digits,symbols,32'
```

### Delete Items

**ALWAYS confirm with user before deleting items.**

Delete an item:

```bash
op item delete "Old Service"
```

Archive instead of delete:

```bash
op item delete "Old Service" --archive
```

## Output Formats

Human-readable (default):

```bash
op item get "Service Name"
```

JSON format (for parsing):

```bash
op item get "Service Name" --format json
```

Parse with jq:

```bash
op item get "Service Name" --format json | jq '.fields[] | select(.label=="password") | .value'
```

## Common Patterns

### Find all agent-accessible secrets

```bash
op item list --tags agents --format json | jq -r '.[] | "\(.title) (\(.vault.name))"'
```

### Get password for a service

```bash
op item get "Service Name" --tags agents --fields label=password --format json | jq -r '.fields[0].value'
```

### Check if an item exists

```bash
op item get "Service Name" --tags agents --format json &>/dev/null && echo "exists" || echo "not found"
```

### List all API credentials for agents

```bash
op item list --tags agents --categories "API Credential"
```

## Categories

Available item categories:

- API Credential
- Bank Account
- Credit Card
- Database
- Document
- Driver License
- Email Account
- Identity
- Login
- Membership
- Outdoor License
- Passport
- Password
- Reward Program
- Secure Note
- Server
- Social Security Number
- Software License
- Wireless Router

## Error Handling

If authentication fails:

```bash
op signin
```

If item not found, verify:

1. Item exists in 1Password
2. Item has the `agents` tag
3. Correct vault is accessible
4. User is properly authenticated

## Best Practices

1. **Always use the `agents` tag** for items intended for agent access
2. **Confirm destructive operations** (create, edit, delete) with user
3. **Use secret references** (`op://...`) when injecting secrets into commands
4. **Prefer JSON format** when parsing output programmatically
5. **Use item IDs** instead of names for more reliable references
6. **Specify vault** when dealing with multiple vaults to avoid ambiguity
