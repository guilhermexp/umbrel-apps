# Terminal (gx-terminal)

A host root shell in the browser, packaged from
[ttyd](https://github.com/tsl0922/ttyd) 1.7.7. Click the icon on the Umbrel
home screen and a bash login shell opens on the Umbrel host — no SSH client,
keys or extra password.

## How it works

- `ttyd -W` serves a writable terminal on port 7681 inside the container.
- `nsenter -t 1 -m -u -i -n -p -- /bin/bash -l` enters the host PID 1
  namespaces, so the shell runs on the host as root, with host networking,
  mounts and processes. The container is `privileged` with `pid: host` for
  exactly this reason.
- The Umbrel app gateway proxies HTTP and the ttyd WebSocket on port **8273**
  and keeps the umbrelOS login in front (`PROXY_AUTH_ADD` is never disabled).
- No Tailscale Serve hook, no published extra ports, no persistent app data.
  Root's shell history lives in the host's `/root`, as with any host shell.

## Security model

Anyone with an authenticated umbrelOS session gets **root on the host**. That
is the same trust level as installing any app, but it is explicit here. Keep
the Umbrel password strong; do not share the dashboard session; do not add a
Tailscale/public mapping for this app without thinking it through.

## Operations

- Open: home screen → Terminal (or `http://umbrel.local:8273`).
- Logs: app details → logs in the Umbrel UI (`docker logs gx-terminal_app_1`
  on the host). Each browser connection spawns one `nsenter`/`bash` child;
  closing the tab ends the shell.
- Restart/stop only this app from the UI; open shells die with the container.
- Uninstalling removes the container only; nothing else is touched.

## Updating

Pin the new upstream digest in `docker-compose.yml` (multi-arch index digest
from Docker Hub) and bump `version` in `umbrel-app.yml`. The image must keep
`nsenter` (the Ubuntu-based official image ships util-linux) and `bash`.