#!/usr/bin/env bash

# Umbrel provides derive_entropy using its private seed. Purpose-separated
# values stay stable on restart; neither the seed nor these values enter Git.
export APP_FLEET_MYSQL_ROOT_PASSWORD="$(derive_entropy "${EXPORTS_APP_ID}-mysql-root")"
export APP_FLEET_MYSQL_PASSWORD="$(derive_entropy "${EXPORTS_APP_ID}-mysql-user")"
export APP_FLEET_PRIVATE_KEY="$(derive_entropy "${EXPORTS_APP_ID}-server-key" | openssl dgst -sha256 -binary | openssl base64 -A)"
