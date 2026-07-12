# Quality gates

Every component repo now has a reproducible quality gate.

| Repository | Gate command | Focus |
| --- | --- | --- |
| `xiaomi-mitv-remote-linux-kiosk` | `./scripts/repo_quality_gate.sh` | CLI, docs, diagnostics, profiles, lab report, privacy. |
| `linux-tv-kiosk-shell` | `./scripts/repo_quality_gate.sh` | Static checks, contract checks, DOM smoke, docs, privacy. |
| `local-dashboard-widget-sdk` | `./scripts/repo_quality_gate.sh` | Schema/types freshness, browser catalog viewer assets/checks, entry points, docs, privacy. |
| `local-dashboard-live-data-updater` | `./scripts/repo_quality_gate.sh` | Redaction behavior, docs, output safety, privacy. |
| `guarded-local-config-editor` | `./scripts/repo_quality_gate.sh` | Profile enforcement, CLI/server boundaries, docs, privacy. |
| `guarded-kiosk-deploy` | `./scripts/repo_quality_gate.sh` | Plan/apply/rollback reports, disposable SSH harness when `sshd` is available, docs, CI hygiene, privacy. |

This meta repo also has a smoke test that verifies the stack manifest, status matrix, and README markers.
