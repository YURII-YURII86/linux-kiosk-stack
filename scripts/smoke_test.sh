#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 - <<'PY'
import json
from pathlib import Path
readme = Path('README.md').read_text()
required = [
  'xiaomi-mitv-remote-linux-kiosk',
  'linux-tv-kiosk-shell',
  'local-dashboard-widget-sdk',
  'local-dashboard-live-data-updater',
  'guarded-local-config-editor',
  'guarded-kiosk-deploy',
  'Remote → Shell → Widgets → Live data → Safe config editing → Guarded deploy',
]
missing = [x for x in required if x not in readme]
if missing:
    raise SystemExit(f'missing README markers: {missing}')
manifest = json.loads(Path('examples/stack.manifest.json').read_text())
assert manifest['schema'] == 'linux-kiosk-stack.manifest.v2'
assert len(manifest['repos']) == 6
assert manifest['flow'][0] == 'remote'
assert all(repo['version'].startswith('v0.2.') for repo in manifest['repos'])
print('stack docs ok')
PY
echo 'smoke ok'
