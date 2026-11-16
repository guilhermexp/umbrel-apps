# Dench on Umbrel

This package runs the Dench server image (`ghcr.io/guilhermexp/hermes-dench`,
pinned by digest) on umbrelOS. It is built by the `Imagem do servidor` workflow
of the Dench repository from `docker/server/Dockerfile`; nothing is compiled on
the Umbrel.

## Access

Install from Guilherme Apps while the Tailscale app is running and signed in.
The `post-start` hook publishes this app on the existing Tailscale node only:

| HTTPS port | Backend (host loopback) | Use |
|-----------:|-------------------------|-----|
| 8460 | 127.0.0.1:13460 | Dench (and `/terminal-ws/` → 13461) |
| 8446 | 127.0.0.1:13446 | WhatsApp UI |
| 8447 | 127.0.0.1:13447 | WhatsApp API |

Open `https://YOUR-UMBREL-NAME.ts.net:8460` from a Tailscale-connected device.
The panel's port 443 and other Serve mappings are preserved; a port already
used by another service makes the hook fail instead of taking it over. No
public internet endpoint is created and nothing is published on the LAN.

The owner is `dono@dench.local`. Umbrel shows the initial password, derived
from the private per-app seed. It is set once; later starts never reset a
password changed in Dench, so Umbrel's shown password may become outdated.

## Start sequence

1. `pre-start` creates `data/{home,instance,configuration}` for UID 1000 and,
   once, `configuration/app.env` (login, audit, owner, public URL). It refuses
   to start if the Tailscale address no longer matches that file, and copies it
   to `dench.env`, the file Compose reads. `dench.env` ships empty because
   Umbrel pulls images before any hook runs; never edit it, edit the master.
2. `whatsapp-init` (same image, app stopped) installs the WhatsApp stack on the
   first start; afterwards it prepares the functions cache and applies only new
   WhatsApp migrations through the canonical ledger. Failure keeps Dench down.
3. `app` starts the supervisor; `post-start` waits for `/api/system/health`,
   sets the owner password once and publishes the Tailscale ports.

`data/integration-status` must say `ready`; `data/public-url` gives the address.

## Updates and backups

An update pins a new image digest here and bumps the version. Umbrel stops the
app, pulls the image and starts it, so `whatsapp-init` migrates before the new
version runs. There is no automatic rollback after a migration and no snapshot
is taken by this package: back up the app data (stopped app) before updating.
Uninstalling deletes app data.

## Limits

The Linux server controller (`deploy-server.mjs`: systemd timers, snapshot
before migration, update from Settings) is not used here; Settings ›
Atualizações shows the updater as not installed. WhatsApp Web devices are
paired by QR inside Dench.
