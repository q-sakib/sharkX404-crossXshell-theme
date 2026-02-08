#!/bin/bash
set -e

# Load .env
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo ".env not found!"
  exit 1
fi

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
      \"repositories\": {\"read\": true,\"write\": true}
    }
  }")

TOKEN=$(echo "$RESP" | jq -r '.password')

# Save in Keychain (macOS)
security add-internet-password \
  -a "$BB_USER" \
  -s bitbucket.org \
  -w "$TOKEN" \
  -T /usr/bin/git \
  -U

echo "✅ Token rotated and saved to Keychain"

# Optional: update .env
sed -i '' "s|^BB_TOKEN=.*|BB_TOKEN=$TOKEN|" .env
