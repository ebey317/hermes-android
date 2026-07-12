# Maintenance

## Updating Termux packages safely

Hermes depends on specific Python and Rust versions. Before upgrading:

```bash
apt-mark showhold
```

You should see:

```
python
python-cryptography
rust
```

If you want to upgrade them anyway:

```bash
apt-mark unhold python python-cryptography rust
pkg update
pkg upgrade
apt-mark hold python python-cryptography rust
```

After a Python upgrade, run the recovery script:

```bash
bash ~/hermes-android/scripts/fix-after-upgrade.sh
```

## Updating Hermes

```bash
cd ~/.hermes/hermes-agent
git fetch origin
git checkout main
git pull
~/.hermes/hermes-agent/venv/bin/python -m pip install -e ".[termux]"
pkill -f server.py
sleep 2
cd ~/hermes-webui
python server.py &
```

## Updating the Web UI

```bash
cd ~/hermes-webui
git fetch origin
git checkout main
git pull
pkill -f server.py
sleep 2
python server.py &
```

## Switching models

Use the Web UI model dropdown, or run:

```bash
hermes model
```

Or edit `~/.hermes/config.yaml`:

```yaml
model:
  default: glm-5
  provider: ollama-cloud
  base_url: https://ollama.com/v1
  api_key: ${OLLAMA_API_KEY}
```

Then restart the Web UI:

```bash
pkill -f server.py
sleep 2
cd ~/hermes-webui
python server.py &
```

## Switching providers

To use OpenRouter instead of Ollama Cloud:

```bash
hermes config set model.provider openrouter
hermes config set model.api_key ${OPENROUTER_API_KEY}
hermes config set model.default "openai/gpt-4o-mini"
```

Or edit `~/.hermes/config.yaml` directly.

Available providers and keys:
- Ollama Cloud: https://ollama.com/settings
- OpenRouter: https://openrouter.ai/keys
- OpenAI: https://platform.openai.com/api-keys
- Anthropic: https://console.anthropic.com/settings/keys

## Backup

Important files to back up:

```
~/.hermes/.env
~/.hermes/config.yaml
~/.hermes/sessions/
~/.hermes/webui/settings.json
~/.ssh/authorized_keys
```

## Logs

| Log | Path |
|-----|------|
| Hermes gateway | `~/.hermes/gateway.log` |
| Web UI | `~/.hermes/webui/server.log` |
| Install | `~/.hermes/hermes-agent/hermes_install.log` |

## Verify after any change

```bash
hermes version
hermes doctor
hermes gateway status
curl -sS http://127.0.0.1:8787/api/auth/status
```

And always send a real test message through the Web UI.
