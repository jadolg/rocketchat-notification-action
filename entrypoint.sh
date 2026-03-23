#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
BOLD='\033[1m'
RESET='\033[0m'

SERVER="${INPUT_SERVER}"
USER="${INPUT_USER}"
PASSWORD="${INPUT_PASSWORD}"
MESSAGE="${INPUT_MESSAGE}"
CHANNEL="${INPUT_CHANNEL}"

LOGIN_RESPONSE=$(curl -s -X POST \
  -H "Content-Type: application/json" \
  -d "$(jq -n --arg user "$USER" --arg password "$PASSWORD" '{"user": $user, "password": $password}')" \
  "${SERVER}/api/v1/login")

mapfile -t login_data < <(jq -r '.data.authToken, .data.userId' <<< "$LOGIN_RESPONSE")
AUTH_TOKEN="${login_data[0]}"
USER_ID="${login_data[1]}"

if [ -z "$AUTH_TOKEN" ] || [ "$AUTH_TOKEN" = "null" ]; then
  LOGIN_ERROR=$(jq -r '.message // "unknown error"' <<< "$LOGIN_RESPONSE")
  echo -e "${RED}${BOLD}✗ Login failed${RESET} — ${LOGIN_ERROR}"
  exit 1
fi

echo -e "${GREEN}✓ Logged in${RESET} — ${USER}@${SERVER}"

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

LOGOUT_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
  -H "X-Auth-Token: ${AUTH_TOKEN}" \
  -H "X-User-Id: ${USER_ID}" \
  "${SERVER}/api/v1/logout") || true

if [ "${LOGOUT_STATUS}" = "200" ]; then
  echo -e "${GREEN}✓ Logged out${RESET}"
else
  echo -e "${RED}✗ Logout failed${RESET} — HTTP ${LOGOUT_STATUS}"
fi
