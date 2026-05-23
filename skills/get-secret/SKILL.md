---
name: get-secret
description: Retrieve and decrypt secrets from the local encrypted credential store (~/.get_vars.json). Use when the user needs to access stored credentials, API keys, passwords, or other secrets that have been exported from 1Password. This reads from the encrypted JSON file created by the get_vars.sh script.
---

# Get Secret

Retrieve and decrypt secrets from the local encrypted credential store.

## Prerequisites

1. **GET_VARS_ENCRYPTION_KEY environment variable** - Must be set to decrypt values
2. **Encrypted store file** - Must exist at `~/.get_vars.json` (created by `scripts/get_vars.sh`)
3. **Required tools** - `jq` and `openssl` must be available

## How It Works

This skill reads the encrypted JSON file at `~/.get_vars.json` and decrypts specific secrets using the `GET_VARS_ENCRYPTION_KEY` environment variable. The file contains items exported from 1Password with all sensitive values encrypted using AES-256-CBC.

## Common Operations

### Search for Available Secrets

Before retrieving a secret, you can search for available items:

```bash
# List all items with titles and categories
jq -r '.items[] | "\(.title) (\(.category))"' ~/.get_vars.json

# Search for items by title
jq -r '.items[] | select(.title | contains("GitHub")) | "\(.title) - \(.category)"' ~/.get_vars.json

# List items by category
jq -r '.items[] | select(.category == "LOGIN") | .title' ~/.get_vars.json
```

### Retrieve and Decrypt a Secret

To get a decrypted secret value:

```bash
# Get a specific field from an item by title and field label
encrypted_value=$(jq -r '.items[] | select(.title=="GitHub Token") | .fields[] | select(.label=="password") | .encrypted_value' ~/.get_vars.json)
echo "$encrypted_value" | openssl enc -aes-256-cbc -d -a -pbkdf2 -pass pass:"$GET_VARS_ENCRYPTION_KEY"
```

### Common Patterns

**Get username and password from a login:**

```bash
# Get username
encrypted_username=$(jq -r '.items[] | select(.title=="Service Name") | .fields[] | select(.label=="username") | .encrypted_value' ~/.get_vars.json)
username=$(echo "$encrypted_username" | openssl enc -aes-256-cbc -d -a -pbkdf2 -pass pass:"$GET_VARS_ENCRYPTION_KEY")

# Get password
encrypted_password=$(jq -r '.items[] | select(.title=="Service Name") | .fields[] | select(.label=="password") | .encrypted_value' ~/.get_vars.json)
password=$(echo "$encrypted_password" | openssl enc -aes-256-cbc -d -a -pbkdf2 -pass pass:"$GET_VARS_ENCRYPTION_KEY")
```

**Get API credential:**

```bash
encrypted_api_key=$(jq -r '.items[] | select(.title=="Service API") | .fields[] | select(.label=="credential") | .encrypted_value' ~/.get_vars.json)
api_key=$(echo "$encrypted_api_key" | openssl enc -aes-256-cbc -d -a -pbkdf2 -pass pass:"$GET_VARS_ENCRYPTION_KEY")
```

**Get secret by category:**

```bash
# Get all API credentials
jq -r '.items[] | select(.category=="API CREDENTIAL") | .title' ~/.get_vars.json
```

### Helper Function

For repeated use, create a helper function:

```bash
get_secret() {
  local item_title="$1"
  local field_label="$2"
  
  local encrypted_value=$(jq -r --arg title "$item_title" --arg label "$field_label" \
    '.items[] | select(.title==$title) | .fields[] | select(.label==$label) | .encrypted_value' \
    ~/.get_vars.json)
  
  if [[ -z "$encrypted_value" ]] || [[ "$encrypted_value" == "null" ]]; then
    echo "Error: Secret not found: $item_title / $field_label" >&2
    return 1
  fi
  
  echo "$encrypted_value" | openssl enc -aes-256-cbc -d -a -pbkdf2 -pass pass:"$GET_VARS_ENCRYPTION_KEY"
}

# Usage
password=$(get_secret "GitHub Token" "password")
api_key=$(get_secret "Service API" "credential")
```

## Workflow

When a user asks for a secret:

1. **Check prerequisites**:
   - Verify `GET_VARS_ENCRYPTION_KEY` is set
   - Verify `~/.get_vars.json` exists
   - Verify `jq` and `openssl` are available

2. **Search for the item**:
   - Use `jq` to list available items if needed
   - Help the user identify the correct item title

3. **Identify the field**:
   - Common field labels: `username`, `password`, `credential`, `api_key`, `token`
   - Use `jq` to list fields for an item if needed

4. **Decrypt and provide**:
   - Extract the encrypted value with `jq`
   - Decrypt with `openssl`
   - Provide the decrypted value to the user

## JSON Structure

The encrypted store has this structure:

```json
{
  "exported_at": "2026-05-23T02:36:50Z",
  "vault": "Personal",
  "item_count": 5,
  "items": [
    {
      "id": "abc123",
      "title": "GitHub Token",
      "category": "LOGIN",
      "tags": "agents,automation",
      "fields": [
        {
          "label": "username",
          "type": "STRING",
          "encrypted_value": "U2FsdGVkX1..."
        },
        {
          "label": "password",
          "type": "CONCEALED",
          "encrypted_value": "U2FsdGVkX1..."
        }
      ]
    }
  ]
}
```

## Error Handling

### Encryption key not set

```bash
if [[ -z "${GET_VARS_ENCRYPTION_KEY:-}" ]]; then
  echo "Error: GET_VARS_ENCRYPTION_KEY environment variable not set"
  exit 1
fi
```

### File not found

```bash
if [[ ! -f ~/.get_vars.json ]]; then
  echo "Error: Encrypted store not found at ~/.get_vars.json"
  echo "Run scripts/get_vars.sh to create it"
  exit 1
fi
```

### Secret not found

If `jq` returns `null` or empty string, the item or field doesn't exist. Help the user search for the correct item name.

### Decryption failure

If `openssl` fails, the encryption key is likely incorrect:

```bash
# Test decryption
if ! echo "$encrypted_value" | openssl enc -aes-256-cbc -d -a -pbkdf2 -pass pass:"$GET_VARS_ENCRYPTION_KEY" &> /dev/null; then
  echo "Error: Failed to decrypt - check GET_VARS_ENCRYPTION_KEY"
  exit 1
fi
```

## Categories Reference

Common 1Password categories you'll see:

- `LOGIN` - Username/password combinations
- `PASSWORD` - Simple passwords
- `API CREDENTIAL` - API keys and tokens
- `SECURE NOTE` - Secure notes with custom fields
- `DATABASE` - Database credentials
- `SERVER` - Server credentials
- `CREDIT CARD` - Credit card information
- `BANK ACCOUNT` - Bank account details

## Security Notes

1. **Never log or display decrypted values** - Handle them in memory only
2. **Clear variables after use** - `unset` sensitive variables when done
3. **Avoid writing to disk** - Don't save decrypted values to files
4. **Protect the encryption key** - Keep `GET_VARS_ENCRYPTION_KEY` secure

## Best Practices

1. **Always verify prerequisites** before attempting to decrypt
2. **Search first** if you're unsure of the exact item title
3. **Use exact matches** - Item titles and field labels are case-sensitive
4. **Handle errors gracefully** - Check for null/empty values before decrypting
5. **Use helper functions** for repeated operations to reduce errors
