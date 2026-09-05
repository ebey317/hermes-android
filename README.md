# Hermes Agent on Android

> Install [Hermes Agent](https://github.com/NousResearch/hermes-agent) natively on Android through Termux, with a browser-based Web UI and optional Tailscale remote access.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform: Android](https://img.shields.io/badge/Platform-Android-brightgreen?logo=android)](https://termux.dev)
[![Shell](https://img.shields.io/badge/Shell-Bash-blue.svg)]()

This is the Android counterpart to the desktop Hermes experience: one assistant that runs locally on your phone or tablet, controlled through a clean web interface.

---

## What You Get

- **Hermes CLI** installed in a Python venv
- **Hermes Web UI** on `http://127.0.0.1:8787`
- **Ollama Cloud** configured as the default model provider
- **Tailscale** mesh VPN for remote SSH management
- Version-pinned Termux packages to avoid silent breakages from `pkg upgrade`
- SSH server on **port 8022**
- Web UI password enforcement during install

> **Note:** This setup uses **Ollama Cloud**, not a local Ollama server. You do not need to install or run `ollama` on Android. For local models, install the separate Ollama Android app.

---

## Supported Devices

- Android 12 or newer
- `aarch64` (ARM 64-bit) only
- At least 6 GB RAM recommended
- Termux from **F-Droid**, not Google Play

---

## Quick Start

### 1. Install prerequisites

See [`docs/PREREQUISITES.md`](docs/PREREQUISITES.md) for step-by-step screenshots.

TL;DR:

1. Enable **Install unknown apps** for your file manager/browser.
2. Install **F-Droid** from [f-droid.org](https://f-droid.org).
3. From F-Droid, install **Termux** ([link](https://f-droid.org/packages/com.termux/)).
4. From F-Droid, install **Tailscale** ([link](https://f-droid.org/packages/com.tailscale.ipn/)).
5. Open Termux and run:
   ```bash
   bash <(curl -fsSL https://raw.githubusercontent.com/ebey317/hermes-android/main/install.sh)
   ```

### 2. Paste your API key

When the installer prompts, paste your **Ollama Cloud** API key from [ollama.com/settings](https://ollama.com/settings). The installer validates the key by sending a real test message.

### 3. Open the Web UI

On the Android device, open a browser and go to:

```
http://127.0.0.1:8787
```

Send a message. The assistant should reply.

### 4. Optional: remote management over Tailscale

After Tailscale is signed in, your tablet gets a stable IP like `100.x.y.z`. From another machine on the same Tailscale network:

```bash
ssh -p 8022 -o ConnectTimeout=30 u0_aNNN@100.x.y.z
```

Use the username that `whoami` prints inside Termux.

---

## Important Defaults

| Setting | Value |
|---|---|
| Web UI port | `8787` |
| Hermes CLI config | `~/.hermes/config.yaml` |
| API keys | `~/.hermes/.env` |
| Default provider | `ollama-cloud` |
| Default model | `nemotron-3-super` |
| SSH port | `8022` |

---

## Verification

After install, these should all succeed:

```bash
hermes version
hermes doctor
hermes gateway status
```

And in the browser:

1. Open `http://127.0.0.1:8787`
2. Create a new chat
3. Type a message and press Enter
4. You should get a reply from the model

---

## Security

- API keys are stored in plain text in `~/.hermes/.env`. Restrict access:
  ```bash
  chmod 600 ~/.hermes/.env
  ```
- The Web UI listens on `127.0.0.1` by default and is **not** exposed to the public internet.
- Tailscale provides encrypted, account-private remote access.
- Set a Web UI password if the device is shared. The installer requires this by default; see [`docs/PERMISSIONS.md`](docs/PERMISSIONS.md).

---

## Getting Help

- [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md)
- [`docs/KNOWN_ISSUES.md`](docs/KNOWN_ISSUES.md)
- [`docs/MAINTENANCE.md`](docs/MAINTENANCE.md)

---

## License

MIT — see [LICENSE](LICENSE).

---

## Paid Setup Services

The public installer is the **Community** tier: free, cloud-only, automatic.

For local models, hybrid cloud+local, hands-off remote setup, or multi-device deployments, see [PRICING.md](PRICING.md).

Inquiries: **ebey317@gmail.com**
