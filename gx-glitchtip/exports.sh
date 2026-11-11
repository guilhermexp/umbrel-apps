#!/usr/bin/env bash

# Secrets derived from the per-app seed, stable across restarts.
export APP_GLITCHTIP_DB_PASSWORD=$(echo -n "${APP_SEED}-glitchtip-db" | sha256sum | cut -d' ' -f1)
export APP_GLITCHTIP_SECRET_KEY=$(echo -n "${APP_SEED}-glitchtip-secret" | sha256sum | cut -d' ' -f1)

# Optional overrides: one-line files in the app data folder (Files > Apps > GlitchTip).
#   data/public-url     public base URL used in DSNs, e.g. https://umbrel.example.ts.net:8271
#   data/registration   "false" closes sign-ups after the first account is created
DATA_DIR="${EXPORTS_APP_DIR}/data"

APP_GLITCHTIP_DOMAIN="http://${DEVICE_DOMAIN_NAME}:8271"
if [[ -s "${DATA_DIR}/public-url" ]]; then
  APP_GLITCHTIP_DOMAIN="$(head -n1 "${DATA_DIR}/public-url" | tr -d '[:space:]')"
fi
export APP_GLITCHTIP_DOMAIN

APP_GLITCHTIP_REGISTRATION="true"
if [[ -s "${DATA_DIR}/registration" ]] && [[ "$(head -n1 "${DATA_DIR}/registration" | tr -d '[:space:]')" == "false" ]]; then
  APP_GLITCHTIP_REGISTRATION="false"
fi
export APP_GLITCHTIP_REGISTRATION
