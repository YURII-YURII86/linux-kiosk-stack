# Linux Kiosk Stack

[![CI](https://github.com/YURII-YURII86/linux-kiosk-stack/actions/workflows/ci.yml/badge.svg)](https://github.com/YURII-YURII86/linux-kiosk-stack/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A small local-first toolkit stack for building, operating, and safely deploying Linux TV kiosks, local dashboards, signage screens, and appliance panels.

This is the map repo. The actual tools live in focused repositories.

One-line flow: **Remote → Shell → Widgets → Live data → Safe config editing → Guarded deploy**.

```text
Bluetooth remote
  ↓
Linux TV kiosk shell
  ↓
Widget contracts
  ↓
Live data snapshots
  ↓
Guarded local config editing
  ↓
Guarded deploy
```

## The stack

| Layer | Repository | Purpose |
| --- | --- | --- |
| Remote input | [`xiaomi-mitv-remote-linux-kiosk`](https://github.com/YURII-YURII86/xiaomi-mitv-remote-linux-kiosk) | Use a Xiaomi/MiTV Bluetooth remote as a Linux kiosk/app controller. |
| Kiosk shell | [`linux-tv-kiosk-shell`](https://github.com/YURII-YURII86/linux-tv-kiosk-shell) | Vanilla static TV dashboard shell with focus grid, modal details, local data, and remote action bridge. |
| Widget SDK | [`local-dashboard-widget-sdk`](https://github.com/YURII-YURII86/local-dashboard-widget-sdk) | Contract-first JSON widget manifests, renderer/source contracts, presets, catalog, scaffold. |
| Live data | [`local-dashboard-live-data-updater`](https://github.com/YURII-YURII86/local-dashboard-live-data-updater) | Provider-based host-side snapshot generator that writes `live.json` and browser-friendly `live.js`. |
| Config editing | [`guarded-local-config-editor`](https://github.com/YURII-YURII86/guarded-local-config-editor) | Local transaction bridge: preview, diff, approval phrase, checkpointed apply, rollback. |
| Deploy | [`guarded-kiosk-deploy`](https://github.com/YURII-YURII86/guarded-kiosk-deploy) | Manifest-based safe deploys for fragile Linux kiosks: validate, plan, checkpoint, exact-file apply, verify. |

## Why these projects belong together

A Linux kiosk is not just a web page. A reliable kiosk needs:

- a physical control path that works from a couch or wall-mounted screen;
- a lightweight browser shell that does not require a heavy framework;
- explicit contracts for widgets and panel layout;
- backend-side data collection that avoids leaking secrets into browser code;
- guarded local editing so a UI cannot break config directly;
- deploy tooling that avoids blind `rsync` on a fragile production display.

This stack covers that full lifecycle while staying local-first and simple.

## Recommended architecture

```text
+-------------------------+        +---------------------------+
| Xiaomi / MiTV remote    |        | local data providers      |
| /dev/input/event*       |        | system/rss/http/command   |
+-----------+-------------+        +-------------+-------------+
            |                                    |
            v                                    v
+-------------------------+        +---------------------------+
| xiaomi-mitv-remote-*    |        | local-dashboard-live-*    |
| writes KIOSK_REMOTE     |        | writes data/live.js       |
+-----------+-------------+        +-------------+-------------+
            |                                    |
            +----------------+-------------------+
                             v
              +-----------------------------+
              | linux-tv-kiosk-shell        |
              | static browser dashboard    |
              +---------------+-------------+
                              |
                              v
              +-----------------------------+
              | widget contracts/catalog    |
              | local-dashboard-widget-sdk  |
              +---------------+-------------+
                              |
       config changes         | deploy changes
              v               v
+--------------------------+  +---------------------------+
| guarded-local-config-*   |  | guarded-kiosk-deploy      |
| preview/apply/rollback   |  | plan/apply/checkpoint     |
+--------------------------+  +---------------------------+
```

## Quick start path

### 1. Start with the shell

```bash
git clone https://github.com/YURII-YURII86/linux-tv-kiosk-shell.git
cd linux-tv-kiosk-shell
python3 -m http.server 8080
```

Open:

```text
http://127.0.0.1:8080/
```

### 2. Generate local live data

```bash
git clone https://github.com/YURII-YURII86/local-dashboard-live-data-updater.git
cd local-dashboard-live-data-updater
python3 -m venv .venv
. .venv/bin/activate
pip install -e .
ldlu run examples/live-config.json --output-json /tmp/live.json --output-js /tmp/live.js
```

Copy or symlink `/tmp/live.js` into the shell's `data/live.js`, then change `index.html` to load `data/live.js` instead of `data/live.example.js`.

### 3. Add remote control

```bash
git clone https://github.com/YURII-YURII86/xiaomi-mitv-remote-linux-kiosk.git
cd xiaomi-mitv-remote-linux-kiosk
python3 -m venv .venv
. .venv/bin/activate
pip install -e .
xiaomi-mitv-remote-setup --init-keymap --dry-run
```

After pairing the remote and validating key codes, run the daemon against the kiosk root so it writes `data/remote-action.js`.

### 4. Define widgets/contracts

```bash
git clone https://github.com/YURII-YURII86/local-dashboard-widget-sdk.git
cd local-dashboard-widget-sdk
python3 -m venv .venv
. .venv/bin/activate
pip install -e .
ldw validate examples/widgets examples/presets
ldw catalog examples/widgets --json
```

### 5. Guard local config edits

```bash
git clone https://github.com/YURII-YURII86/guarded-local-config-editor.git
cd guarded-local-config-editor
python3 -m venv .venv
. .venv/bin/activate
pip install -e .
glce preview examples/config/app.json examples/config/tx-set-title.json
```

### 6. Deploy safely

```bash
git clone https://github.com/YURII-YURII86/guarded-kiosk-deploy.git
cd guarded-kiosk-deploy
python3 -m venv .venv
. .venv/bin/activate
pip install -e .
gkd validate examples/manifests/static-kiosk.json
gkd plan examples/manifests/static-kiosk.json --source-root examples/sample-app
```

Only run `gkd apply` after reviewing the plan and testing on a disposable target.

## Current verification status

Verified across the published repos:

- each repo has a public GitHub repository;
- each repo has at least one release;
- each repo has GitHub Actions CI;
- each repo was fresh-cloned and smoke-tested at publication time;
- public examples were sanitized and kept generic.

Still pending:

- real end-to-end hardware validation on a physical kiosk stack;
- real Xiaomi/MiTV remote validation after standalone extraction;
- disposable-host SSH validation for `guarded-kiosk-deploy apply`;
- full integration demo combining all six tools;
- screenshots/GIF/video demos.

## When to use this stack

Good fit:

- local TV dashboards;
- browser kiosk mode;
- digital signage;
- local appliance panels;
- Raspberry Pi / NUC / Intel Stick style devices;
- weak Linux hardware where heavy frameworks are undesirable;
- deployments where breaking the live screen is painful.

Not a fit:

- cloud SaaS dashboards;
- full Grafana replacement;
- Android TV network remote control;
- mobile-first remote apps;
- multi-tenant web apps exposed to the public internet.

## Design principles

- Local-first.
- Browser reads bounded snapshots, not secrets.
- Physical remote support is first-class.
- JSON contracts before production UI.
- Preview before apply.
- Checkpoint before mutation.
- Exact-file deploys, not blind sync.
- Honest verification status.

## Repository status

| Repo | Latest public state |
| --- | --- |
| `xiaomi-mitv-remote-linux-kiosk` | `v0.2.1`, CI green at publication time. |
| `guarded-kiosk-deploy` | `v0.1.0`, CI green at publication time. |
| `local-dashboard-widget-sdk` | `v0.1.1`, CI green at publication time. |
| `guarded-local-config-editor` | `v0.1.0`, CI green at publication time. |
| `linux-tv-kiosk-shell` | `v0.1.0`, CI green at publication time. |
| `local-dashboard-live-data-updater` | `v0.1.0`, CI green at publication time. |

## Roadmap

- End-to-end demo repository or folder.
- Kiosk stack diagram screenshot.
- Hardware validation notes.
- `systemd` profile examples.
- Integration guide: remote + shell + live updater.
- Integration guide: widget SDK + shell config.
- Integration guide: config editor + deploy pipeline.

## License

MIT. Each linked repository has its own MIT license.
