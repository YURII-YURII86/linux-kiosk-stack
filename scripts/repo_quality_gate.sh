#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

printf 'repo quality gate: linux-kiosk-stack\n'
fail() { printf 'FAIL: %s\n' "$1" >&2; exit 1; }

printf '\n[1/8] stack manifest v2\n'
python3 - <<'PY'
import json
from pathlib import Path
m=json.loads(Path('examples/stack.manifest.json').read_text())
assert m['schema'] == 'linux-kiosk-stack.manifest.v2'
assert m['stackVersion'] == '0.2.0'
assert len(m['repos']) == 6
names={r['name'] for r in m['repos']}
expected={'xiaomi-mitv-remote-linux-kiosk','linux-tv-kiosk-shell','local-dashboard-widget-sdk','local-dashboard-live-data-updater','guarded-local-config-editor','guarded-kiosk-deploy'}
assert names == expected, names
for repo in m['repos']:
    assert repo['version'].startswith('v0.2.'), repo
    assert repo['capabilities'], repo
    assert repo['honestGaps'], repo
print('ok')
PY

printf '\n[2/8] README required markers\n'
python3 - <<'PY'
from pathlib import Path
readme=Path('README.md').read_text()
required=[
  'Remote → Shell → Widgets → Live data → Safe config editing → Guarded deploy',
  'xiaomi-mitv-remote-linux-kiosk',
  'linux-tv-kiosk-shell',
  'local-dashboard-widget-sdk',
  'local-dashboard-live-data-updater',
  'guarded-local-config-editor',
  'guarded-kiosk-deploy',
  'v0.2.7',
  'v0.2.0',
  'Quality gates',
  'docs/status-matrix.md',
]
missing=[x for x in required if x not in readme]
assert not missing, missing
print('ok')
PY

printf '\n[3/8] docs required sections\n'
python3 - <<'PY'
from pathlib import Path
checks={
  'docs/status-matrix.md':['Status matrix','Honest gaps','Safety rule'],
  'docs/integration-order.md':['Recommended integration order','Remote control','Guarded deploy'],
  'docs/quality-gates.md':['Quality gates','guarded-kiosk-deploy'],
  'docs/stack.md':['Stack map'],
  'docs/integration-plan.md':['Integration plan'],
  'docs/quality-hardening.md':['Quality hardening plan'],
}
for path, markers in checks.items():
    text=Path(path).read_text()
    for marker in markers:
        assert marker in text, (path, marker)
print('ok')
PY

printf '\n[4/8] smoke test\n'
./scripts/smoke_test.sh

printf '\n[5/8] local markdown links\n'
python3 - <<'PY'
from pathlib import Path
import re
root=Path('.').resolve(); errors=[]
for p in root.rglob('*'):
    if not p.is_file() or '.git' in p.parts or '.ai_context' in p.parts or '__pycache__' in p.parts: continue
    if p.suffix.lower() != '.md' and not p.name.startswith('README') and p.name != 'CHANGELOG.md': continue
    text=p.read_text(errors='replace')
    for m in re.finditer(r'(?<!!)\[[^\]]+\]\(([^)]+)\)', text):
        target=m.group(1).strip().split()[0].strip('<>')
        if not target or target.startswith(('#','http://','https://','mailto:','tel:')): continue
        rel=target.split('#',1)[0]
        if rel and not (p.parent/rel).resolve().exists():
            errors.append(f'{p}:{text.count(chr(10),0,m.start())+1}:{target}')
if errors:
    print('\n'.join(errors)); raise SystemExit(1)
print('ok')
PY

printf '\n[6/8] public privacy scan\n'
python3 - <<'PY'
from pathlib import Path
needles=['14'+':ab','tail'+'ad','/mnt/'+'slane','Мои '+'приложения','Сл'+'ейн','SL'+'ANE','slane'+'-stick','gh'+'p_','Keen'+'etic']
hits=[]
for p in Path('.').rglob('*'):
    if not p.is_file() or '.git' in p.parts or '__pycache__' in p.parts or '.ai_context' in p.parts or p.name in {'AGENTS.md','CLAUDE.md'}: continue
    text=p.read_text(errors='ignore')
    for n in needles:
        if n in text: hits.append((str(p), n))
if hits:
    print('bad hits', hits[:50]); raise SystemExit(1)
print('ok')
PY

printf '\n[7/8] CI workflow hygiene\n'
grep -q 'permissions:' .github/workflows/ci.yml
grep -q 'contents: read' .github/workflows/ci.yml
grep -q 'ubuntu-24.04' .github/workflows/ci.yml
grep -q 'Repository quality gate' .github/workflows/ci.yml
printf 'ok\n'

printf '\n[8/8] changelog version\n'
grep -q '## 0.2.0' CHANGELOG.md
printf 'ok\n'

printf '\nrepo quality gate ok\n'
