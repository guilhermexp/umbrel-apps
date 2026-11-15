# Fleet on the physical Umbrel

This package installs Fleet 4.94.1 with MySQL 8.4.8 and Redis 7.4.7. Images are
pinned by digest. The app's persistent data root contains `mysql`, `redis`,
`fleet`, `logs`, and `vulndb`.

## Access

Install from Guilherme Apps while Tailscale is running and signed in. The native
`post-start` hook adds only HTTPS port 8272 to the existing Tailscale node. It
proxies to Fleet's host-loopback port 13379. The panel's existing port 443 and
other Serve mappings are preserved. No public internet endpoint is created.

Open `https://YOUR-UMBREL-NAME.ts.net:8272` from a Tailscale-connected device.
Umbrel shows the generated initial administrator credentials when opening the
app. The username is `admin@fleet.local`; the password is derived from the private per-app seed and includes the symbol
required by Fleet. Umbrel renders it into the private installed manifest. Change the password in Fleet if desired; subsequent starts
do not replace an existing account. Umbrel will continue showing the initial
password, so remember an updated password separately.

Device agents connect directly over the Tailscale HTTPS endpoint and use
Fleet's own authentication. They do not need an Umbrel browser session. This
package does not enroll any computers or configure Apple/Windows/Android MDM.
Some features require a Fleet Premium license.

## Operations

`data/integration-status` must say `ready`. `data/public-url` gives the agent
server URL. `/healthz` checks MySQL and Redis; Fleet's dashboard must also be
verified after login. If a hook fails, Umbrel may still show the app as ready:
check the integration status and app logs before claiming a successful deploy.

Stopping or uninstalling disables only the Serve mapping that still points to
this app. Native hooks run on the Umbrel host; application containers receive
no Docker socket or Tailscale state. Fleet stays off the shared Umbrel network; only its app gateway joins both
networks. Its separate egress network allows outbound updates. MySQL and Redis are isolated on an internal backend network and expose no host
ports.

## Backup and recovery

Use a logical MySQL dump with the Fleet application user, and preserve the
private Umbrel seed/credentials separately. Keep app data backups outside this
server and test restoration before relying on Fleet for business operations.
Copying live MySQL files is not a consistent backup. A stopped-app data snapshot
is another recovery option; preserve ownership. Uninstalling deletes app data.
Updates run Fleet's database migrations; retain a pre-update database backup.
