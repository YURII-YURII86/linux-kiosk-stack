# Quality gates

Every component repo now has a reproducible quality gate.

| Repository | Gate command | Focus |
| --- | --- | --- |
| `linux-kiosk-appliance-runtime` | `./scripts/repo_quality_gate.sh` | Safe install refusal, generated unit content, doctor/status/smoke, docs, privacy. |
| `xiaomi-mitv-remote-linux-kiosk` | `./scripts/repo_quality_gate.sh` | CLI, docs, diagnostics, profiles, lab report, redacted submission flow, privacy. |
| `linux-tv-kiosk-shell` | `./scripts/repo_quality_gate.sh` | Static checks, contract checks, DOM smoke, docs, privacy. |
| `local-dashboard-widget-sdk` | `./scripts/repo_quality_gate.sh` | Schema/types freshness, browser catalog viewer assets/checks, entry points, docs, privacy. |
| `local-dashboard-widget-manager` | `./scripts/repo_quality_gate.sh` | 22-type registry, examples, Studio data/screenshot checks, docs, privacy. |
| `local-dashboard-live-data-updater` | `./scripts/repo_quality_gate.sh` | Redaction behavior, schema freshness, docs, output safety, privacy. |
| `guarded-local-config-editor` | `./scripts/repo_quality_gate.sh` | Profile enforcement, profile schema hook accept/reject checks, static editor demo assets/checks, CLI/server boundaries, docs, privacy. |
| `guarded-kiosk-deploy` | `./scripts/repo_quality_gate.sh` | Plan/apply/rollback reports, disposable SSH harness when `sshd` is available, docs, CI hygiene, privacy. |

This meta repo also has a smoke test that verifies the stack manifest, status matrix, and README markers.
