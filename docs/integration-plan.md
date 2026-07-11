# Integration plan

A practical integration sequence:

1. Run `linux-tv-kiosk-shell` with demo data.
2. Replace `data/live.example.js` with output from `local-dashboard-live-data-updater`.
3. Add `xiaomi-mitv-remote-linux-kiosk` to write `data/remote-action.js`.
4. Use `local-dashboard-widget-sdk` to validate widget manifests before shell config changes.
5. Use `guarded-local-config-editor` to preview/apply shell config changes.
6. Use `guarded-kiosk-deploy` to ship exact files to the kiosk.

Every step should have a smoke test before production use.
