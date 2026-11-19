#!/usr/bin/env bash
# Optional presence ping. Reads plugin options from CLAUDE_PLUGIN_OPTION_* env vars.
# Never blocks or fails the session.
event="${1:-start}"
[ "${CLAUDE_PLUGIN_OPTION_PRESENCE}" = "true" ] || exit 0
[ -n "${CLAUDE_PLUGIN_OPTION_BACKEND_URL}" ] || exit 0

input="$(cat)"
session_id="$(printf '%s' "$input" | sed -n 's/.*"session_id" *: *"\([^"]*\)".*/\1/p' | head -n1)"

curl -sS -m 3 -o /dev/null \
  -X POST "${CLAUDE_PLUGIN_OPTION_BACKEND_URL}/presence" \
  -H "Authorization: Bearer ${CLAUDE_PLUGIN_OPTION_API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"event\":\"${event}\",\"user_id\":\"${CLAUDE_PLUGIN_OPTION_USER_ID}\",\"session_id\":\"${session_id}\"}" \
  >/dev/null 2>&1 || true
exit 0
