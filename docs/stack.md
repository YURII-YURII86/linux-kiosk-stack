# Stack map

The stack is intentionally split into small repos.

- Remote input stays separate because hardware/input permissions are risky.
- Shell stays static because weak kiosk devices benefit from no-build deployments.
- Widget contracts stay separate because they are useful without the shell.
- Live data updater stays separate because providers are environment-specific.
- Config editor stays separate because mutation needs a guarded boundary.
- Deploy stays separate because production device safety is its own concern.

Together they form a complete local-first kiosk lifecycle.
