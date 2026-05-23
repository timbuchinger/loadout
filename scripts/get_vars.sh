#!/usr/bin/env bash

set -euo pipefail

# get_vars.sh - Export 1Password entries to encrypted JSON
# 
# Usage: get_vars.sh [--vault VAULT_NAME] [--output OUTPUT_FILE]
#
# Environment variables:
#   GET_VARS_ENCRYPTION_KEY - Required. Encryption key for securing the output
#   OP_SESSION_*            - Optional. 1Password session token
#
# Output: JSON file with encrypted values in ~/.get_vars.json
# Note: Only exports items tagged with 'agents'

# Configuration
OUTPUT_FILE="${HOME}/.get_vars.json"
VAULT_NAME=""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --vault)
      VAULT_NAME="$2"
      shift 2
      ;;
    --output)
      OUTPUT_FILE="$2"
      shift 2
      ;;
    --help|-h)
      echo "Usage: $0 [--vault VAULT_NAME] [--output OUTPUT_FILE]"
      echo ""
      echo "Options:"
      echo "  --vault VAULT_NAME    Specific 1Password vault to export from"
      echo "  --output OUTPUT_FILE  Output file path (default: ~/.get_vars.json)"
      echo ""
      echo "Environment variables:"
      echo "  GET_VARS_ENCRYPTION_KEY  Required. Key for encrypting values"
      exit 0
      ;;
    *)
      echo -e "${RED}Error: Unknown option $1${NC}"
      exit 1
      ;;
  esac
done

# Check for required tools
if ! command -v op &> /dev/null; then
  echo -e "${RED}Error: 1Password CLI (op) not found${NC}"
  echo "Install from: https://developer.1password.com/docs/cli/get-started/"
  exit 1
fi

if ! command -v jq &> /dev/null; then
  echo -e "${RED}Error: jq not found${NC}"
  echo "Install with: apt-get install jq (or brew install jq on macOS)"
  exit 1
fi

if ! command -v openssl &> /dev/null; then
  echo -e "${RED}Error: openssl not found${NC}"
  exit 1
fi

# Check for encryption key
if [[ -z "${GET_VARS_ENCRYPTION_KEY:-}" ]]; then
  echo -e "${RED}Error: GET_VARS_ENCRYPTION_KEY environment variable not set${NC}"
  echo "Set it with: export GET_VARS_ENCRYPTION_KEY='your-secure-key'"
  exit 1
fi

# Check 1Password authentication
if ! op whoami &> /dev/null; then
  echo -e "${YELLOW}Not signed in to 1Password. Attempting sign-in...${NC}"
  
  # Check if running in an interactive terminal
  if [[ -t 0 ]]; then
    # Interactive terminal - attempt signin
    signin_output=$(op signin 2>&1)
    signin_exit=$?
    
    if [[ $signin_exit -eq 0 ]]; then
      # Successfully got session export commands, evaluate them
      eval "$signin_output"
      
      # Verify authentication worked
      if ! op whoami &> /dev/null; then
        echo -e "${RED}Error: Sign-in appeared to succeed but authentication still failed${NC}"
        exit 1
      fi
      echo -e "${GREEN}✓ Signed in successfully${NC}"
    else
      echo -e "${RED}Error: Failed to sign in to 1Password${NC}"
      echo "$signin_output"
      exit 1
    fi
  else
    # Non-interactive (script/CI) - cannot prompt for password
    echo -e "${RED}Error: Not signed in and cannot prompt in non-interactive mode${NC}"
    echo "Please sign in first by running: eval \$(op signin)"
    exit 1
  fi
fi

# Function to encrypt a value
encrypt_value() {
  local value="$1"
  if [[ -z "$value" ]]; then
    echo ""
    return 0
  fi
  echo -n "$value" | openssl enc -aes-256-cbc -a -salt -pbkdf2 -pass pass:"${GET_VARS_ENCRYPTION_KEY}" 2>/dev/null || {
    echo "Error: Failed to encrypt value" >&2
    return 1
  }
}

# Function to get all items from 1Password with 'agents' tag
get_items() {
  if [[ -n "$VAULT_NAME" ]]; then
    op item list --vault "$VAULT_NAME" --tags agents --format json
  else
    op item list --tags agents --format json
  fi
}

# Function to get item details and encrypt sensitive fields
process_item() {
  local item_id="$1"
  local item_json
  
  # Get full item details
  item_json=$(op item get "$item_id" --format json)
  
  # Extract metadata
  local item_title=$(echo "$item_json" | jq -r '.title')
  local item_category=$(echo "$item_json" | jq -r '.category')
  local item_id_out=$(echo "$item_json" | jq -r '.id')
  local item_tags=$(echo "$item_json" | jq -r '.tags // [] | join(",")')
  
  # Process fields and encrypt sensitive values
  local fields_json=$(echo "$item_json" | jq -r '.fields // []' | jq -c 'map({
    label: .label,
    type: .type,
    value: (if .value then .value else null end),
    encrypted: (if .value then true else false end)
  })')
  
  # Encrypt each field value
  local encrypted_fields="[]"
  local field_count=$(echo "$fields_json" | jq 'length')
  
  for ((i=0; i<field_count; i++)); do
    local field=$(echo "$fields_json" | jq -c ".[$i]")
    local value=$(echo "$field" | jq -r '.value')
    local label=$(echo "$field" | jq -r '.label')
    local type=$(echo "$field" | jq -r '.type')
    
    if [[ "$value" != "null" ]] && [[ -n "$value" ]]; then
      local encrypted=$(encrypt_value "$value")
      encrypted_fields=$(echo "$encrypted_fields" | jq --arg label "$label" --arg type "$type" --arg enc "$encrypted" \
        '. += [{label: $label, type: $type, encrypted_value: $enc}]')
    fi
  done
  
  # Build item object
  jq -n \
    --arg id "$item_id_out" \
    --arg title "$item_title" \
    --arg category "$item_category" \
    --arg tags "$item_tags" \
    --argjson fields "$encrypted_fields" \
    '{id: $id, title: $title, category: $category, tags: $tags, fields: $fields}'
}

# Main execution
echo -e "${GREEN}Starting 1Password export (items tagged 'agents' only)...${NC}"

# Get all items with 'agents' tag
echo "Retrieving items tagged with 'agents'..."
items=$(get_items)
item_count=$(echo "$items" | jq 'length')

echo "Found $item_count items tagged 'agents'"

# Process each item
output_items="[]"
processed=0

while IFS= read -r item; do
  item_id=$(echo "$item" | jq -r '.id')
  item_title=$(echo "$item" | jq -r '.title')
  
  echo -n "Processing: $item_title... "
  
  if processed_item=$(process_item "$item_id"); then
    output_items=$(echo "$output_items" | jq --argjson item "$processed_item" '. += [$item]')
    ((processed++))
    echo "✓"
  else
    echo "Failed (skipping)"
    continue
  fi
done < <(echo "$items" | jq -c '.[]')

# Create final output with metadata
final_output=$(jq -n \
  --arg timestamp "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --arg vault "$VAULT_NAME" \
  --argjson items "$output_items" \
  '{
    exported_at: $timestamp,
    vault: (if $vault == "" then null else $vault end),
    item_count: ($items | length),
    items: $items
  }')

# Write to file
echo "$final_output" > "$OUTPUT_FILE"

echo -e "${GREEN}✓ Export complete${NC}"
echo "Output written to: $OUTPUT_FILE"
echo "Items exported: $processed (tagged with 'agents')"
echo ""
echo -e "${YELLOW}Important:${NC}"
echo "- Only items tagged 'agents' in 1Password are exported"
echo "- Keep GET_VARS_ENCRYPTION_KEY secure and backed up"
echo "- Decrypt with: echo 'encrypted_value' | openssl enc -aes-256-cbc -d -a -pbkdf2 -pass pass:\"\$GET_VARS_ENCRYPTION_KEY\""
