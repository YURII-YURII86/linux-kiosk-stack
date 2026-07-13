# Quality hardening plan

Goal: make every repository in the Linux Kiosk Stack unusually useful, transparent, safe, and easy to trust.

This plan is intentionally staged so hardening never risks a live production Intel Stick or kiosk.

## Non-negotiable safety rule

Do not run experimental validation on a live production kiosk, Intel Stick, signage player, or appliance without explicit operator approval for that exact test.

Preferred validation layers:

1. static checks;
2. unit tests;
3. fresh clone smoke tests;
4. CI matrix;
5. dry-runs;
6. disposable VM/container/SSH host;
7. non-production hardware;
8. production hardware only after explicit approval and rollback plan.

## Baseline quality bar for every repo

Every repository should have:

- clear README with problem, audience, quick start, status, safety boundaries;
- MIT license;
- CI;
- release tags;
- `SECURITY.md`;
- `CONTRIBUTING.md`;
- `SUPPORT.md`;
- issue templates;
- pull request template;
- smoke test runnable from a fresh clone;
- no secrets or private infrastructure in examples;
- honest verification status;
- roadmap that separates implemented vs planned.

## Repository-specific hardening

### xiaomi-mitv-remote-linux-kiosk

Next upgrades:

- real Xiaomi/MiTV remote hardware validation table;
- udev non-root permissions guide;
- GIF/video demo of remote controlling browser shell;
- richer interactive pairing wizard;
- device profile registry;
- integration example with `linux-tv-kiosk-shell`.

Validation must start with `LKR_GRAB=0` and must not touch the production kiosk session without explicit approval.

### guarded-kiosk-deploy

Next upgrades:

- disposable SSH target integration test;
- implemented `gkd rollback` command;
- JSON apply report;
- systemd-aware verification helpers;
- dry-run examples for common kiosk deploys;
- comparison doc: why not blind `rsync`.

Never test `apply` against a production device first.

### local-dashboard-widget-sdk

Next upgrades:

- JSON Schema export;
- TypeScript type generation;
- browser catalog viewer — closed in `local-dashboard-widget-sdk v0.2.1`;
- lab-to-production promotion gate;
- more renderer examples;
- integration example with `linux-tv-kiosk-shell`.

### guarded-local-config-editor

Next upgrades:

- pluggable validators;
- file allowlist profiles;
- richer static editor UI;
- transaction history log;
- signed transaction bundle option;
- integration example with widget/shell config.

Keep server local-first. Public-network exposure requires a separate threat model.

### linux-tv-kiosk-shell

Next upgrades:

- screenshot/GIF demo;
- Playwright visual smoke test;
- theme presets;
- more card renderers;
- remote + live data integrated example;
- performance budget document with measurable limits.

Do not add private provider data or environment-specific URLs.

### local-dashboard-live-data-updater

Next upgrades:

- systemd service example;
- provider plugin interface;
- JSON Schema for config/snapshot — closed in `local-dashboard-live-data-updater v0.2.1`;
- shell integration example;
- safe weather/RSS examples without hardcoded private locations;
- generated snapshot redaction guide.

Provider configs must stay generic in public examples.

### linux-kiosk-stack

Next upgrades:

- end-to-end demo guide;
- architecture diagram image generated from text source;
- matrix of validation status across repos;
- “which repo should I use?” decision tree;
- links to live releases and CI status.

## Best-practice sources used

This plan follows broadly accepted GitHub/open-source hygiene: clear README, license, contribution/security docs, CI, issue templates, releases, and honest verification status.


### linux-kiosk-appliance-runtime

Closed runtime/orchestration MVP gap in `v0.1.0`:

- canonical runtime prefix layout;
- service topology templates;
- systemd user unit templates;
- `lkar plan/install/validate/status/doctor/units/smoke`;
- broad unsafe prefix refusal;
- demo-prefix-first smoke checks.

Remaining: real production enablement and hardware validation.
