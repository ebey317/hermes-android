# Hermes Agent on Android

Install [Hermes Agent](https://github.com/NousResearch/hermes-agent) natively on Android through Termux, with a browser-based Web UI, Ollama Cloud integration, and optional Tailscale remote access.

- Get the Ollama Cloud API key: https://ollama.com/settings
- Get an OpenRouter key (optional): https://openrouter.ai/keys
- Get an OpenAI key (optional): https://platform.openai.com/api-keys
- Get Tailscale: https://tailscale.com/download/android
- Install Termux from F-Droid: https://f-droid.org/packages/com.termux/
- Hermes Agent source: https://github.com/NousResearch/hermes-agent
- Hermes Web UI source: https://github.com/nesquena/hermes-webui

This is the Android counterpart to the desktop Hermes experience: one assistant that runs locally on your phone/tablet, controlled through a clean web interface.

> **Note:** This setup uses **Ollama Cloud**, not a local Ollama server. You do not need to install or run `ollama` on Android. If you later want local models, install the separate Ollama Android app.

## What you get

- **Hermes CLI** installed in a Python venv
- **Hermes Web UI** on `http://127.0.0.1:8787`
- **Ollama Cloud** configured as the default model provider
- **Tailscale** mesh VPN for remote SSH management (you install the Android app; the script configures the rest)
- Version-pinned Termux packages so a random `pkg upgrade` doesn't silently break everything
- An SSH server on **port 8022** (configured and started by the installer)
- Web UI password enforcement (enabled during install)

## Supported devices

- Android 12 or newer
- `aarch64` (ARM 64-bit) only — this is what almost every modern Android phone/tablet uses
- At least 6 GB RAM recommended
- Termux from **F-Droid**, not Google Play

## Quick start

### 1. Install the prerequisites

See [`docs/PREREQUISITES.md`](docs/PREREQUISITES.md) for screenshots-level detail.

TL;DR:

1. Enable **Install unknown apps** for your file manager/browser.
2. Install **F-Droid** from https://f-droid.org.
3. From F-Droid, install **Termux** (https://f-droid.org/packages/com.termux/).
4. From F-Droid, install **Tailscale** (https://f-droid.org/packages/com.tailscale.ipn/).
5. Open Termux and run:
   ```bash
   bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USER/hermes-android/main/install.sh)
   ```

> **Free Community tier:** this script installs Ollama Cloud only, with one working model. No credit card required.
>
> **Want local models, hybrid cloud+local, hands-off setup, or multiple devices?** See [PRICING.md](PRICING.md).

> If you are sideloading from a flash drive, copy `install.sh` to the device and run `bash /sdcard/Download/install.sh` instead.

### 2. Paste your API key

When the installer prompts, paste your **Ollama Cloud** API key from https://ollama.com/settings.

The installer validates the key by actually sending a test chat message, not just listing models.

### 3. Open the Web UI

On the Android device, open a browser and go to:

```
http://127.0.0.1:8787
```

You should see the Hermes Web UI. Send a message. The assistant should reply.

### 4. Optional: remote management over Tailscale

After Tailscale is signed in, your tablet gets a stable IP like `100.x.y.z`. From another machine on the same Tailscale network:

```bash
ssh -p 8022 -o ConnectTimeout=30 u0_aNNN@100.x.y.z
```

Use the username that `whoami` prints inside Termux.

## Important defaults

- Web UI port: **8787**
- Hermes CLI config: `~/.hermes/config.yaml`
- API keys: `~/.hermes/.env`
- Default provider: **ollama-cloud**
- Default model: **nemotron-3-super**

## Verification

After install, these should all succeed:

```bash
hermes version
hermes doctor
hermes gateway status
```

And in the browser:

1. Open `http://127.0.0.1:8787`.
2. Create a new chat.
3. Type a message and press Enter.
4. You should get a reply from the model.

## Security

- API keys are stored in plain text in `~/.hermes/.env`. This is standard for Hermes, but keep the file readable only by you:
  ```bash
  chmod 600 ~/.hermes/.env
  ```
- The Web UI listens on `127.0.0.1` by default. It is **not** exposed to the public internet.
- Tailscale is used for remote access, which is encrypted and private to your account.
- **Set a Web UI password** if more than one person uses the device. The installer requires this by default; see [`docs/PERMISSIONS.md`](docs/PERMISSIONS.md).

## Getting help

- [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md)
- [`docs/KNOWN_ISSUES.md`](docs/KNOWN_ISSUES.md)
- [`docs/MAINTENANCE.md`](docs/MAINTENANCE.md)

## License

MIT — see the Hermes Agent repo for its license.

## Paid setup services

The public installer above is the **Community** tier: free, cloud-only, automatic.

If you want local models, hybrid cloud+local, hands-off remote setup, or a multi-device office/workstation deployment, see [PRICING.md](PRICING.md).

For paid setup inquiries: **business-development@anthropic.com**
