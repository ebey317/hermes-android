# Troubleshooting

## Before you start

Most problems fall into one of these buckets:

1. Android killed Termux.
2. Termux Python was upgraded and broke the venv.
3. The API key is read-only / wrong.
4. The config points at local Ollama instead of Ollama Cloud.
5. A long build ran out of RAM or time.

## Run diagnostics first

In Termux:

```bash
hermes version
hermes doctor
hermes gateway status
curl -sS http://127.0.0.1:8787/api/auth/status
curl -sS http://127.0.0.1:8787/api/settings | grep -E "default_model|default_model_provider"
```

Expected:
- `hermes version` prints a version number.
- `hermes doctor` reports no missing critical deps.
- `hermes gateway status` says running.
- `/api/auth/status` returns JSON.
- `/api/settings` shows `ollama-cloud` and a model like `nemotron-3-super`.

## Problem: Web UI shows 401 / 404 / 500 on every message

### Likely cause 1: LD_PRELOAD is missing

Run:

```bash
cat ~/.hermes/.env | grep LD_PRELOAD
cat /data/data/com.termux/files/usr/bin/hermes
```

You should see `LD_PRELOAD=/data/data/com.termux/files/usr/lib/libpython3.14.so` or similar.

Fix with the recovery script:

```bash
bash ~/hermes-android/scripts/fix-after-upgrade.sh
```

### Likely cause 2: API key is read-only

Test the key directly:

```bash
source ~/.hermes/.env
curl -sS -H "Authorization: Bearer $OLLAMA_API_KEY" https://ollama.com/v1/models | head -c 50
curl -sS -H "Authorization: Bearer $OLLAMA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"nemotron-3-super","messages":[{"role":"user","content":"hi"}]}' \
  https://ollama.com/v1/chat/completions
```

If the first works but the second says `Unauthorized`, your key can list models but cannot chat. Get a fresh inference key from <https://ollama.com/settings>.

### Likely cause 3: Config points at local Ollama

Check:

```bash
grep -nE "provider:|base_url:|default:" ~/.hermes/config.yaml | head -10
```

For Ollama Cloud, the `model` block should look like:

```yaml
model:
  provider: ollama-cloud
  base_url: https://ollama.com/v1
  default: nemotron-3-super
  api_key: ${OLLAMA_API_KEY}
```

Fix:

```bash
python3 -c "
import yaml, pathlib
p = pathlib.Path('/data/data/com.termux/files/home/.hermes/config.yaml')
c = yaml.safe_load(p.read_text())
c['model']['provider'] = 'ollama-cloud'
c['model']['base_url'] = 'https://ollama.com/v1'
c['model']['default'] = 'nemotron-3-super'
c['model']['api_key'] = '\${OLLAMA_API_KEY}'
p.write_text(yaml.dump(c, default_flow_style=False, sort_keys=False))
"
pkill -f server.py
sleep 2
cd ~/hermes-webui
python server.py &
```

## Problem: `No module named 'openai'` or similar

The Web UI is running from an old/deleted venv.

Fix:

```bash
pkill -f server.py
sleep 2
cd ~/hermes-webui
nohup ~/.hermes/hermes-agent/venv/bin/python server.py > ~/.hermes/webui/server-restart.log 2>&1 &
```

## Problem: Long install never finishes / OOM

Expected on a 4-core ARM tablet:
- `pydantic-core` build: 15–30 minutes
- `jiter` build: 10–20 minutes
- Total: 30–90 minutes

To survive:

```bash
termux-wake-lock
tmux new -s hermes_install
# inside tmux, run the install
bash install.sh
# then press Ctrl+B then D to detach
```

Monitor:

```bash
tmux attach -t hermes_install
```

Close other Android apps to free RAM. If the build still dies, the tablet doesn't have enough memory. Use a cloud provider instead of local inference, or install on a device with more RAM.

## Problem: SSH connection times out

Don't restart sshd immediately. Try:

```bash
ssh -p 8022 -o ConnectTimeout=30 -o ServerAliveInterval=10 u0_a180@100.x.y.z
```

If the tablet screen is off, wake it. If Tailscale relay is slow, higher timeouts help.

If sshd is actually not running, start it:

```bash
sshd
```

## Problem: `maturin` build fails

Make sure rust is installed and up to date:

```bash
pkg install rust
pkg upgrade rust
```

Then retry.

## Problem: Web UI asks for a password you don't know

Disable auth and restart:

```bash
python3 -c "
import json
p = '/data/data/com.termux/files/home/.hermes/webui/settings.json'
d = json.load(open(p))
d['auth_enabled'] = False
d['password_auth_enabled'] = False
json.dump(d, open(p, 'w'), indent=2)
"
pkill -f server.py
sleep 2
cd ~/hermes-webui
python server.py &
```

Then set a password from the Web UI settings page.

## Problem: Model switching in Web UI doesn't stick

The Web UI may override the default with `HERMES_WEBUI_DEFAULT_MODEL` in `~/hermes-webui/.env`. Check it:

```bash
cat ~/hermes-webui/.env
```

If it forces a model you don't want, edit or remove that line, then restart the Web UI.

## Problem: `curl` gives errors

Run:

```bash
apt update && apt full-upgrade -y
```

Then test `curl --version`.

## Still stuck?

Open an issue with:
- Device model
- Android version
- Termux `python --version`
- Output of `hermes version`, `hermes doctor`, `hermes gateway status`
- The exact error message from the Web UI
