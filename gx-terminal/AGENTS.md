# Terminal Umbrel package

This directory packages upstream ttyd as a host terminal; do not modify ttyd
itself here. `umbrel-app.yml` controls the icon and home-screen entry; there
are no credentials, so no `exports.sh`, template or hooks exist.

The container is intentionally `privileged: true` with `pid: host`: `nsenter`
must reach host PID 1 to open a root shell. This is the app's purpose, not an
accident — never "harden" it by dropping privileges, and never set
`PROXY_AUTH_ADD=false`: the umbrelOS gateway login is the only authentication
in front of a root shell. Do not add Tailscale Serve or other public mappings
for this app without an explicit user decision.

Pin the ttyd image by multi-arch digest; bump `version` in the manifest on
image updates. The image must provide `nsenter` and `bash` (the official
Ubuntu-based ttyd image does). Keep the gateway target `gx-terminal_app_1:7681`
and the healthcheck in sync with the ttyd port.

Validate manifests and Compose YAML before publishing (e.g. `docker compose
config --quiet` with synthetic `APP_DATA_DIR`/`APP_DATA_ROOT` where needed).
Then verify on the real Umbrel: install state, icon on the home screen, login
gate in front of the terminal, a working root shell (`id`, `hostname`),
WebSocket input, and app-only restart. Never uninstall to debug; uninstalling
only removes this container, but keep the habit.