# Known Issues

## Platform

- **Architecture:** Only `aarch64` is tested. `arm` (32-bit) and `x86_64` may work but are not verified.
- **RAM:** At least 6 GB recommended. The initial install compiles Rust extensions and needs free memory.
- **No swap:** Android/Termux typically has no swap. OOM kills are possible during long builds.
- **Background kills:** Android suspends Termux unless `termux-wake-lock` is active and battery optimization is disabled.
- **SSHD dies when screen is off:** Keep Termux in recent apps or use `termux-wake-lock`.

## Termux Python version drift

- This guide is written for **Termux Python 3.14.6** (mid-2026).
- If Termux later ships Python 3.15, the `LD_PRELOAD` path and the `requires-python` patch will need updating.
- If Termux ships Python 3.13 or earlier, the install is easier because prebuilt wheels may exist.

## Hermes dependencies

- **faster-whisper** is not available on Android (no `ctranslate2` wheels).
- **Browser automation** is intentionally skipped by the Termux installer.
- **Docker** is not available.
- Voice transcription via local model is not supported; use cloud providers for voice.

## Ollama Cloud

- A key that can list models may still fail on chat completions. The installer tests the chat endpoint before continuing.
- Model slugs must match Ollama Cloud exactly. Use the model picker in the Web UI or check `https://ollama.com/v1/models`.

## Security

- API keys are stored in plain text in `~/.hermes/.env`.
- The Web UI is bound to `127.0.0.1` by default; it is not reachable from the public internet unless you deliberately expose it.
- Tailscale is recommended for remote access instead of opening ports.

## Web UI auth

- The installer requires a password.
- If you lose the password, you must disable auth in `~/.hermes/webui/settings.json` and restart.

## Build times

- First install can take 30–90 minutes on a mid-range ARM tablet.
- Future `git pull` + `pip install -e .` updates are much faster.
