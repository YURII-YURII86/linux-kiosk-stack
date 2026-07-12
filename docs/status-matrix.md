# Status matrix

This matrix reflects the post-hardening public repository state.

| Layer | Repository | Version | Main proof | New hardening value |
| --- | --- | ---: | --- | --- |
| Remote | `xiaomi-mitv-remote-linux-kiosk` | `v0.2.7` | Fresh clone, CI, repo quality gate | Unified bilingual `xiaomi-remote` CLI, doctor, profiles, lab, hardware report artifact. |
| Shell | `linux-tv-kiosk-shell` | `v0.2.0` | Fresh clone, CI, DOM smoke | Dependency-free runtime validation for render/focus/modal/remote bridge behavior. |
| Widgets | `local-dashboard-widget-sdk` | `v0.2.1` | Fresh clone, CI, schema/type freshness, catalog viewer check | JSON Schema and TypeScript exports plus static browser catalog viewer for non-Python consumers. |
| Live data | `local-dashboard-live-data-updater` | `v0.2.1` | Fresh clone, CI, redaction checks, schema freshness | Default redaction, inspect/redact commands, config/snapshot JSON Schema export, systemd user service example. |
| Config editing | `guarded-local-config-editor` | `v0.2.1` | Fresh clone, CI, profile enforcement, schema hook accept/reject checks | Workspace profiles: file/op/path allowlists, HTTP enforcement, and result config schema validation. |
| Deploy | `guarded-kiosk-deploy` | `v0.2.1` | Fresh clone, CI, rollback dry-run report, disposable localhost SSH/SCP harness | Real rollback command, checkpoint missing markers, apply/rollback reports, real disposable SSH apply/rollback proof. |

## Verified across component repos

- Public GitHub repository exists.
- MIT license exists.
- GitHub Actions CI exists and was green after the hardening pass.
- Fresh clone was tested after publish.
- Each repo has a `scripts/repo_quality_gate.sh` or equivalent quality gate.
- Public examples were kept generic and privacy-scanned.

## Honest gaps

These are not hidden:

- Real end-to-end validation on physical kiosk hardware is still pending.
- Real Xiaomi/MiTV remote hardware validation after extraction is still pending.
- `guarded-kiosk-deploy` mutating SSH apply/rollback is validated on disposable localhost SSH; non-local disposable VM/host validation is still pending.
- `linux-tv-kiosk-shell` still needs real browser screenshots/GIFs and optional Playwright visual gate.
- Full combined integration demo is still pending.

## Safety rule

The stack is designed for Intel Stick-class fragile kiosk devices, but live production hardware is not touched by default. Hardware or production validation requires explicit approval and a rollback plan.
