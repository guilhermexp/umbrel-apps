# Fleet on Umbrel Implementation Plan

> For agentic workers: execute the tasks in order; the root owns deployment and verification. The user explicitly authorized creating and executing this plan on 15 November 2026.

**Goal:** Install Fleet as `gx-fleet` in the existing Guilherme Apps store on the physical Lenovo Umbrel, with persistent data and private HTTPS for device agents.

**Architecture:** Adapt Fleet's official small-deployment Compose into a native Umbrel app containing Fleet, MySQL and Redis. Keep Umbrel app launching through its existing gateway; add only a dedicated Tailscale Serve HTTPS mapping for agent traffic, preserving the existing panel mapping. Use native lifecycle hooks for scoped integration, with no host Docker socket exposed to the Fleet containers.

**Tech Stack:** Fleet 4.94.1, compatible pinned MySQL 8 and Redis images, Docker Compose, Umbrel app manifests/exports/hooks, existing Tailscale node.

**Spec:** User-approved design in the conversation: physical Umbrel app with icon, free edition, private Tailscale access, HTTPS and persistent storage. No enrollment of existing devices is included.

## Global Constraints

- Target is physical Lenovo 82CG, Tailscale IP 100.127.132.27, never the Umbrel VM on Dokploy-US.
- Reuse `guilhermexp/umbrel-apps`, store ID `gx`; retain `gx-glitchtip` unchanged.
- Pin Fleet 4.94.1 and image digests; use a Fleet-supported MySQL version.
- Do not publish runtime passwords, enrollment secrets, seed values or private keys to Git.
- MySQL and Redis receive no host-published ports.
- Preserve Tailscale root HTTPS, hostname, routes, DNS and other apps.
- Derive stable, purpose-separated credentials from Umbrel's per-app seed.
- Do not install fleetd or enroll/manage existing devices as part of proving the server.

### Task 1: Package and prove configuration

Files: `gx-fleet/umbrel-app.yml`, `gx-fleet/docker-compose.yml`, `gx-fleet/exports.sh`, `gx-fleet/hooks/pre-start`, `gx-fleet/hooks/post-start`, `gx-fleet/hooks/post-stop`, `gx-fleet/hooks/pre-uninstall`, `gx-fleet/README.md`, `README.md`, `.gitignore`.

- [ ] Verify native lifecycle hook execution and gateway behavior from the installed Umbrel-compatible source.
- [ ] Resolve immutable image digests for Fleet 4.94.1, MySQL and Redis.
- [ ] Add the manifest, Compose and secret exports. Persistent mounts live below `APP_DATA_ROOT`. Fleet DB preparation runs before serving; health checks include MySQL and Redis.
- [ ] Add bounded hooks that create required writable app directories, integrate only the dedicated HTTPS mapping, and remove only that mapping when stopped/uninstalled. Record integration status without secret values in app-owned data.
- [ ] Validate shell syntax and actual exported credential stability/purpose separation with temporary input; validate Compose with `docker compose config --quiet` using synthetic seeds and paths.
- [ ] Run an isolated container smoke test where an engine is available: DB migrations, `/healthz`, Fleet version and initial setup status. Retain logs without passwords.
- [ ] Review the complete diff, especially mounts, authentication, certificates and mapping preservation.

### Task 2: Publish store and install

- [ ] Commit reviewed files on `deploy/fleet-umbrel`, integrate to `main` and push the store update, after all locally applicable gates pass.
- [ ] Refresh the existing community store through authenticated Umbrel UI; verify `gx-fleet` name and version before installing.
- [ ] Install through the native app UI and wait for terminal ready state. Inspect actual application logs on failure before making changes.
- [ ] Confirm the dedicated endpoint serves valid TLS, `/healthz` reports healthy MySQL/Redis connections, and the existing Umbrel panel remains available.

### Task 3: Verify user flow and persistence

- [ ] Open the Fleet icon in Umbrel and observe the Fleet setup/login UI.
- [ ] Secure the initial admin account using generated credentials, retained only in private app/local delivery storage; no password printed in logs or committed.
- [ ] Log into Fleet and observe the dashboard with zero managed hosts; reread server setup state through normal authenticated application behavior.
- [ ] Restart only `gx-fleet` through Umbrel, then confirm the account and settings persist and HTTPS/health return.
- [ ] Confirm Firefox, Obsidian, Ollama, Open WebUI, Tailscale and the Umbrel panel remain available; do not restart them.
- [ ] Record deployed commit, observed version, endpoint, tested flow, backup procedure and limits in `.tmp/verify/fleet-deploy/` and durable inventory. Finish branch cleanup without removing evidence.

## Recovery

If installation fails, retain the app data and diagnose logs. Stop only `gx-fleet` when needed; never use a global Docker prune or remove existing apps. The dedicated Tailscale mapping can be disabled independently; existing HTTPS mappings must remain unchanged. Uninstalling through Umbrel deletes Fleet data and is not a debugging step. App data needs a separately tested backup before business-critical use.
