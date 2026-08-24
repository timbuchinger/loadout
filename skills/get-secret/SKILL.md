---
name: get-secret
description: Retrieve and decrypt secrets from the local encrypted credential store (~/.get_vars.json). Use when the user needs to access stored credentials, API keys, passwords, or other secrets that have been exported from 1Password. This reads from the encrypted JSON file created by the get_vars.sh script.
---

# Get Secret

Retrieve and decrypt secrets from the local encrypted credential store.

## Prerequisites

1. **GET_VARS_ENCRYPTION_KEY environment variable** - Must be set to decrypt values. It is defined in `~/.bash_profile` (or `~/.bashrc`), which means it is **only available in a login shell**. The agent's default tool shell is non-login and will read it as UNSET.
2. **Encrypted store file** - Must exist at `~/.get_vars.json` (created by `scripts/get_vars.sh`)
3. **Required tools** - `jq` and `openssl` must be available

## CRITICAL: Run Decryption in a Login Shell

`GET_VARS_ENCRYPTION_KEY` is sourced from `~/.bash_profile` / `~/.bashrc`. The agent's bash tool runs a **non-login** shell, so the variable is UNSET there. **Every command that decrypts must be run through `bash -l -c '...'`** so the profile is sourced.

## CRITICAL: Use the Temp-File openssl Form

The `echo "$enc" | openssl ...` stdin-pipe form fails on OpenSSL 3.x with `reading input file`. The robust form writes the ciphertext to a temp file and reads it with `-in`, adding `-A` for single-line base64:

```bash
printf '%s' "$encrypted_value" > "$tmp"
openssl enc -aes-256-cbc -d -a -A -pbkdf2 -pass pass:"$GET_VARS_ENCRYPTION_KEY" -in "$tmp"
```

Do NOT use the `echo "$encrypted_value" | openssl ...` pipe form.

## How It Works

This skill reads the encrypted JSON file at `~/.get_vars.json` and decrypts specific secrets using the `GET_VARS_ENCRYPTION_KEY` environment variable. The file contains items exported from 1Password with all sensitive values encrypted using AES-256-CBC.

## Common Operations

### Search for Available Secrets

Searching does not require the encryption key, so it runs in the normal tool shell:

```bash
# List all items with titles and categories
jq -r '.items[] | "\(.title) (\(.category))"' ~/.get_vars.json

# Search for items by title
jq -r '.items[] | select(.title | contains("GitHub")) | "\(.title) - \(.category)"' ~/.get_vars.json

# List items by category
jq -r '.items[] | select(.category == "LOGIN") | .title' ~/.get_vars.json
```

### Retrieve and Decrypt a Secret

Combine extraction and decryption inside a single `bash -l -c`. Write the ciphertext to a temp file and let openssl read it via `-in`:

```bash
bash -l -c '
tmp=$(mktemp)
jq -r ".items[] | select(.title==\"GitHub Token\") | .fields[] | select(.label==\"password\") | .encrypted_value" ~/.get_vars.json > "$tmp"
openssl enc -aes-256-cbc -d -a -A -pbkdf2 -pass pass:"$GET_VARS_ENCRYPTION_KEY" -in "$tmp"
rm -f "$tmp"
'
```

### Helper Function

For repeated use, define a helper that must be run under `bash -l`. The cleanest way is to write it to a temp script and execute that script with a login shell:

```bash
cat > /tmp/get_secret.sh <<'FUNC'
get_secret() {
  local item_title="$1"
  local field_label="$2"
  local tmp encrypted_value

  if [[ -z "${GET_VARS_ENCRYPTION_KEY:-}" ]]; then
    echo "Error: GET_VARS_ENCRYPTION_KEY not set (run under bash -l)" >&2
    return 1
  fi

  encrypted_value=$(jq -r --arg title "$item_title" --arg label "$field_label" \
    '.items[] | select(.title==$title) | .fields[] | select(.label==$label) | .encrypted_value' \
    ~/.get_vars.json)

  if [[ -z "$encrypted_value" ]] || [[ "$encrypted_value" == "null" ]]; then
    echo "Error: Secret not found: $item_title / $field_label" >&2
    return 1
  fi

  tmp=$(mktemp)
  printf '%s' "$encrypted_value" > "$tmp"
  openssl enc -aes-256-cbc -d -a -A -pbkdf2 -pass pass:"$GET_VARS_ENCRYPTION_KEY" -in "$tmp"
  rm -f "$tmp"
}
FUNC

# Source and call inside a login shell
bash -l -c 'source /tmp/get_secret.sh; get_secret "GitHub Token" "password"'
bash -l -c 'source /tmp/get_secret.sh; get_secret "Service API" "credential"'
```

### Common Patterns

**Get username and password from a login:**

```bash
bash -l -c '
source /tmp/get_secret.sh
username=$(get_secret "Service Name" "username")
password=$(get_secret "Service Name" "password")
'
```

**Get API credential:**

```bash
bash -l -c 'source /tmp/get_secret.sh; get_secret "Service API" "credential"'
```

**Get secret by category (no decryption needed):**

```bash
jq -r '.items[] | select(.category=="API CREDENTIAL") | .title' ~/.get_vars.json
```

## Workflow

When a user asks for a secret:

1. **Check prerequisites**:
   - Verify `~/.get_vars.json` exists
   - Verify `jq` and `openssl` are available
   - Verify the key is available under a login shell: `bash -l -c 'echo "${GET_VARS_ENCRYPTION_KEY:+set}"'`

2. **Search for the item** (normal tool shell, no key needed):
   - Use `jq` to list available items if needed
   - Help the user identify the correct item title

3. **Identify the field**:
   - Common field labels: `username`, `password`, `credential`, `api_key`, `token`
   - Use `jq` to list fields for an item if needed

4. **Decrypt and provide**:
   - Extract the encrypted value and decrypt **inside `bash -l -c`** using the temp-file form
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

The variable is UNSET in non-login shells. Confirm it resolves under a login shell:

```bash
if [[ "$(bash -l -c 'echo "${GET_VARS_ENCRYPTION_KEY:-}"')" == "" ]]; then
  echo "Error: GET_VARS_ENCRYPTION_KEY not available in login shell"
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

If `openssl` fails with `reading input file`, you used the stdin-pipe form. Switch to the temp-file + `-in` form. If it still fails, the key is likely wrong (verify it resolved via `bash -l`). Test decryption:

```bash
bash -l -c '
tmp=$(mktemp)
printf "%s" "$1" > "$tmp"
openssl enc -aes-256-cbc -d -a -A -pbkdf2 -pass pass:"$GET_VARS_ENCRYPTION_KEY" -in "$tmp" &> /dev/null
rc=$?
rm -f "$tmp"
exit $rc
' _ "$encrypted_value" || echo "Error: Failed to decrypt - check GET_VARS_ENCRYPTION_KEY"
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
3. **Avoid writing to disk** - Don't save decrypted values to files (the temp file holds ciphertext only, not plaintext)
4. **Protect the encryption key** - Keep `GET_VARS_ENCRYPTION_KEY` secure
5. **Always clean up temp files** - `rm -f "$tmp"` after every openssl call

## Best Practices

1. **Always use `bash -l -c` for decryption** - the tool shell is non-login and won't have the key
2. **Always use the temp-file + `-in` + `-A` openssl form** - the stdin-pipe form fails on OpenSSL 3.x
3. **Search first** (normal shell) if you're unsure of the exact item title - no key needed for `jq` searches
4. **Use exact matches** - Item titles and field labels are case-sensitive
5. **Handle errors gracefully** - Check for null/empty values before decrypting
6. **Use the helper function** for repeated operations to reduce errors
