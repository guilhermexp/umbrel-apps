# Dench Umbrel package

Packages the Dench server image; do not change Dench itself here. The image and
its runtime contract live in the Dench repository (`docker/server/`,
`tools/server/`). `umbrel-app.yml.template` renders the initial owner password;
`exports.sh` derives it with Umbrel's `derive_entropy`. Never put runtime
secrets, Umbrel seeds, tokens or private keys in this repository.

Native `hooks/` run on the Umbrel host. They manage only this app's Tailscale
Serve ports 8460 (with `/terminal-ws/`), 8446 and 8447 and must preserve every
other handler, especially the panel on 443. Containers get no Docker socket,
host networking or Tailscale state. Publish only after the owner password is
set. An owner's changed password must survive restarts.

Validate with `bash -n gx-dench/exports.sh gx-dench/hooks/*`. An image update
pins the new digest and bumps `version` in both manifests. Verify on the real
Umbrel: install state, `integration-status`, TLS, owner login, WhatsApp UI,
app-only restart. Never uninstall to debug: it deletes app data.
