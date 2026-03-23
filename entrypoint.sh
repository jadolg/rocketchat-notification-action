#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
BOLD='\033[1m'
RESET='\033[0m'

SERVER="${INPUT_SERVER}"
AUTH_TOKEN="${INPUT_AUTH_TOKEN}"
USER_ID="${INPUT_USER_ID}"
MESSAGE="${INPUT_MESSAGE}"
CHANNEL="${INPUT_CHANNEL}"

HTTP_CODE=$(curl -s -o /tmp/rc_response -w "%{http_code}" -X POST \
  -H "Content-Type: application/json" \
  -H "X-Auth-Token: ${AUTH_TOKEN}" \
  -H "X-User-Id: ${USER_ID}" \
  -d "$(jq -n --arg channel "$CHANNEL" --arg text "$MESSAGE" '{"channel": $channel, "text": $text}')" \
  "${SERVER}/api/v1/chat.postMessage") || {
  echo -e "${RED}${BOLD}✗ Connection failed${RESET} — could not reach ${SERVER}"
  exit 1
}
RESPONSE=$(cat /tmp/rc_response)

if [ "$HTTP_CODE" = "401" ]; then
  echo -e "${RED}${BOLD}✗ Authentication failed${RESET} — invalid auth-token or user-id"
  exit 1
fi

if ! jq -e '.success' <<< "$RESPONSE" > /dev/null 2>&1; then
  echo -e "${RED}${BOLD}✗ Unexpected response${RESET} (HTTP ${HTTP_CODE})"
  exit 1
fi

SUCCESS=$(jq -r '.success' <<< "$RESPONSE")

if [ "$SUCCESS" != "true" ]; then
  ERROR=$(jq -r '.error // .message // "unknown error"' <<< "$RESPONSE")
  echo -e "${RED}${BOLD}✗ Failed to send message${RESET} — ${ERROR}"
  exit 1
fi

mapfile -t response_data < <(jq -r '.channel, .message.u.username, .message._id' <<< "$RESPONSE")
CHANNEL_NAME="${response_data[0]}"
SENDER="${response_data[1]}"
MSG_ID="${response_data[2]}"

echo -e "${GREEN}${BOLD}✓ Message sent${RESET} — channel: ${BOLD}${CHANNEL_NAME}${RESET}, sender: ${SENDER}, id: ${MSG_ID}"
