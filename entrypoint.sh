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

RESPONSE=$(curl -s -X POST \
  -H "Content-Type: application/json" \
  -H "X-Auth-Token: ${AUTH_TOKEN}" \
  -H "X-User-Id: ${USER_ID}" \
  -d "$(jq -n --arg channel "$CHANNEL" --arg text "$MESSAGE" '{"channel": $channel, "text": $text}')" \
  "${SERVER}/api/v1/chat.postMessage")

mapfile -t response_data < <(jq -r '.success, .channel, .message.u.username, .message._id' <<< "$RESPONSE")
SUCCESS="${response_data[0]}"
CHANNEL_NAME="${response_data[1]}"
SENDER="${response_data[2]}"
MSG_ID="${response_data[3]}"

if [ "$SUCCESS" != "true" ]; then
  ERROR=$(jq -r '.error // .message // "unknown error"' <<< "$RESPONSE")
  echo -e "${RED}${BOLD}✗ Failed to send message${RESET} — ${ERROR}"
  exit 1
fi

echo -e "${GREEN}${BOLD}✓ Message sent${RESET} — channel: ${BOLD}${CHANNEL_NAME}${RESET}, sender: ${SENDER}, id: ${MSG_ID}"
