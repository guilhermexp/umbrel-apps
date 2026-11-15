# Fleet Umbrel package

This directory packages upstream Fleet; do not modify Fleet itself here.
`umbrel-app.yml` controls the icon, URL and initial credential display.
`docker-compose.yml` pins upstream images and isolates the database/cache.
`umbrel-app.yml.template` renders the policy-compliant initial password.
`exports.sh` derives secrets with Umbrel's `derive_entropy` helper; never put
runtime secrets, Umbrel seeds, tokens or private keys in this repository.

Native executable `hooks/` run on the Umbrel host. They integrate only this app's
Tailscale Serve port 8272 with backend 127.0.0.1:13379. Preserve all other Serve
handlers, especially the panel on 443. Application containers must not receive
the Docker socket, host networking or Tailscale state. Expose HTTPS only after
the initial administrator exists; preserve pending-bootstrap retry recovery.
An established owner's account/password/server URL must survive restarts.

Validate shell syntax with `bash -n gx-fleet/exports.sh gx-fleet/hooks/*` from the
repository root. Compose validation needs synthetic exported credentials and an
app_proxy image supplied by Umbrel or an isolated validation override. For
runtime changes, exercise the real Fleet image with MySQL/Redis in an isolated
Compose project, including failed-bootstrap retry and retained credentials.
Then verify actual Umbrel install state, TLS, login, config and app-only restart.
Never use a production database as a negative control or uninstall to debug.

Plan: `../docs/superpowers/plans/2026-11-15-fleet-umbrel.md`.
Operations and backup limitations: `README.md` in this directory.
