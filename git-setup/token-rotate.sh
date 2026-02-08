#!/bin/bash
set -e

read -p "Bitbucket username: " BB_USER
read -s -p "Bitbucket account password (one-time): " BB_PASS
echo ""

read -s -p "New app password label: " LABEL
echo ""

RESP=$(curl -s -u "$BB_USER:$BB_PASS" \
  -H "Content-Type: application/json" \
  https://api.bitbucket.org/2.0/user/app-passwords \
  -d "{
    \"label\": \"$LABEL\",
    \"permissions\": {
      \"repositories\": {
        \"read\": true,
        \"write\": true
      }
    }
  }")

TOKEN=$(echo "$RESP" | jq -r '.password')

security add-internet-password \
  -a "$BB_USER" \
  -s bitbucket.org \
  -w "$TOKEN" \
  -T /usr/bin/git \
  -U

echo "✅ Token rotated and saved to Keychain"
