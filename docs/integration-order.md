# Recommended integration order

Use this order to avoid damaging a live kiosk while still building toward the full stack.

## 1. Shell only

Start with `linux-tv-kiosk-shell` and serve it locally:

```bash
python3 -m http.server 8080
```

Verify the static shell before adding remote input, live data, or deploy tooling.

## 2. Live data

Use `local-dashboard-live-data-updater` to write browser-facing snapshots:

```bash
ldlu inspect examples/live-config.json --json
ldlu schema config --output schemas/config.schema.json
ldlu schema snapshot --output schemas/snapshot.schema.json
ldlu run examples/live-config.json --output-json /tmp/live.json --output-js /tmp/live.js
```

Do not publish raw provider output. Keep redaction enabled unless debugging privately.

## 3. Widget contracts

Use `local-dashboard-widget-sdk` for schema/type-backed widget manifests:

```bash
ldw schema --output schemas/contracts.schema.json
ldw typescript --output types/contracts.d.ts
ldw validate examples/widgets examples/presets
python3 scripts/build_catalog_viewer.py
python3 -m http.server 8766  # open /examples/catalog-viewer/
```

## 4. Remote control

Use `xiaomi-mitv-remote-linux-kiosk` in non-grab mode first:

```bash
xiaomi-remote --lang ru help
LKR_GRAB=0 xiaomi-remote lab --output hardware-validation-report.json
```

Switch to `LKR_GRAB=1` only after shell integration is confirmed.

## 5. Guarded config editing

Use `guarded-local-config-editor` with a workspace profile:

```bash
glce preview examples/config/app.json examples/config/tx-set-title.json \
  --profile examples/profiles/kiosk-dashboard.profile.json
```

Expose browser/admin UI only through narrow profiles. When a profile contains `configSchema`, `glce` also validates the resulting config before preview/apply succeeds.

## 6. Guarded deploy

Use `guarded-kiosk-deploy` dry-runs before any mutation:

```bash
gkd plan examples/manifests/static-kiosk.json --source-root examples/sample-app
gkd apply examples/manifests/static-kiosk.json \
  --source-root examples/sample-app \
  --approve "APPLY static-kiosk-demo TO kiosk-demo" \
  --dry-run \
  --report-json /tmp/gkd-apply-report.json
```

Before any non-local target, run the built-in disposable localhost SSH harness:

```bash
./scripts/disposable_ssh_integration.sh
```

Run real `apply` only on disposable/non-production targets first.
