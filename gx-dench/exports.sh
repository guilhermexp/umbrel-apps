#!/usr/bin/env bash

# Umbrel provides derive_entropy from its private per-device seed. The value is
# stable across restarts and never enters Git or the image.
export APP_DENCH_OWNER_PASSWORD="$(derive_entropy "${EXPORTS_APP_ID}-owner-password" | cut -c1-32)"
