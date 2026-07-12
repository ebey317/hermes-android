# Common pitfalls

- **Google Play Termux is broken/outdated.** Always use F-Droid: https://f-droid.org/packages/com.termux/.
- **Android kills background Termux.** Use `termux-wake-lock` (https://f-droid.org/packages/com.termux/) and keep Termux in recent apps.
- **Python 3.14 breaks the venv.** Either build Python 3.13 from source or wait for Hermes to raise the `<3.14` cap.
- **Web UI must be restarted after any venv rebuild.** It can become a "ghost" process holding a deleted Python binary.
- **Don't ask the user for API keys they already provided.** Hermes CLI and Web UI share `~/.hermes/.env` and `~/.hermes/config.yaml`.
- **Provider `api_key` must reference the `.env` variable, not a literal.** If `ollama-cloud` has `api_key: ollama` instead of `api_key: ${OLLAMA_API_KEY}`, all Ollama Cloud requests will fail with authorization errors. Same for `openrouter` and `${OPENROUTER_API_KEY}`.
- **Live edits to config.yaml may not stick while a ghost Web UI process is running.** Stop the Web UI before editing, or edit via a helper script that can overwrite it atomically.

## Direct links

| What | Link |
|------|------|
| Termux | https://f-droid.org/packages/com.termux/ |
| F-Droid | https://f-droid.org |
| Tailscale Android | https://f-droid.org/packages/com.tailscale.ipn/ or https://tailscale.com/download/android |
| Ollama Cloud key | https://ollama.com/settings |
| Hermes Agent | https://github.com/NousResearch/hermes-agent |
| Hermes Web UI | https://github.com/nesquena/hermes-webui |
