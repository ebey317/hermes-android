#!/data/data/com.termux/files/usr/bin/bash
set -e

# Hermes Agent Android installer
# One-command install for Termux aarch64.

REPO_URL="https://github.com/NousResearch/hermes-agent.git"
WEBUI_REPO="https://github.com/NousResearch/hermes-webui.git"
INSTALL_DIR="$HOME/.hermes/hermes-agent"
WEBUI_DIR="$HOME/hermes-webui"
PREFIX="/data/data/com.termux/files/usr"
PY_MAJ=$(python -c "import sys; print(sys.version_info.major)")
PY_MIN=$(python -c "import sys; print(sys.version_info.minor)")
OLLAMA_KEY_URL="https://ollama.com/settings"

# Find this script's directory for fallback bootstrap
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Hermes Agent installer for Android/Termux"
echo "Python version detected: ${PY_MAJ}.${PY_MIN}"
echo ""
echo "You will need an Ollama Cloud API key from:"
echo "  $OLLAMA_KEY_URL"
echo ""

# 1. Bootstrap
if [ -f "$SCRIPT_DIR/scripts/bootstrap-termux.sh" ]; then
  bash "$SCRIPT_DIR/scripts/bootstrap-termux.sh"
else
  echo "Bootstrap script not found next to install.sh; running inline bootstrap..."
  termux-wake-lock 2>/dev/null || true
  pkg update -y
  pkg upgrade -y
  pkg install -y git python clang make pkg-config libffi openssl ca-certificates curl openssh nodejs ripgrep ffmpeg tmux rust python-cryptography termux-wake-lock
fi

termux-wake-lock 2>/dev/null || true

# 2. Clone Hermes Agent
if [ -d "$INSTALL_DIR" ]; then
  echo "==> Updating existing Hermes clone..."
  cd "$INSTALL_DIR"
  git fetch origin
  git reset --hard origin/main || true
else
  echo "==> Cloning Hermes Agent from $REPO_URL ..."
  git clone "$REPO_URL" "$INSTALL_DIR"
  cd "$INSTALL_DIR"
fi

# 3. Pin to a known-good tag if available
if git describe --tags --abbrev=0 >/dev/null 2>&1; then
  TAG=$(git describe --tags --abbrev=0)
  echo "==> Pinning to tag $TAG"
  git checkout "$TAG" || true
fi

# 4. Patch pyproject.toml for Python 3.14
if [ "$PY_MAJ" -eq 3 ] && [ "$PY_MIN" -ge 14 ]; then
  echo "==> Python 3.14+ detected: patching pyproject.toml..."
  sed -i 's/requires-python = ">=3.11,<3.14"/requires-python = ">=3.11"/' pyproject.toml || true
  sed -i 's/"PyJWT\[crypto\]==2.13.0"/"PyJWT==2.13.0"/' pyproject.toml || true
  sed -i 's/"cryptography==46.0.7",/# "cryptography==46.0.7",/' pyproject.toml || true
fi

# 5. Check for prebuilt Termux packages
PREBUILT=0
if pkg search python-pydantic >/dev/null 2>&1; then
  echo "==> Found prebuilt Termux Python packages; installing..."
  pkg install -y python-pydantic python-jiter python-maturin 2>/dev/null || true
  PREBUILT=1
fi

# 6. Create venv
if [ -d "$INSTALL_DIR/venv" ]; then
  echo "==> Removing old venv..."
  rm -rf "$INSTALL_DIR/venv"
fi

if [ "$PREBUILT" -eq 1 ]; then
  python -m venv --system-site-packages "$INSTALL_DIR/venv"
else
  python -m venv "$INSTALL_DIR/venv"
fi

# 7. Install Hermes
export LD_PRELOAD="$PREFIX/lib/libpython${PY_MAJ}.${PY_MIN}.so"
export PIP_NO_BUILD_ISOLATION=1

"$INSTALL_DIR/venv/bin/python" -m pip install --upgrade pip setuptools wheel

if [ -f "constraints-termux.txt" ]; then
  "$INSTALL_DIR/venv/bin/python" -m pip install -e ".[termux]" -c constraints-termux.txt
elif [ -f "requirements-termux.txt" ]; then
  "$INSTALL_DIR/venv/bin/python" -m pip install -e ".[termux]" -r requirements-termux.txt
else
  "$INSTALL_DIR/venv/bin/python" -m pip install -e ".[termux]"
fi

# 8. Hermes wrapper
ln -sf "$INSTALL_DIR/venv/bin/hermes" "$PREFIX/bin/hermes" 2>/dev/null || true

# 9. Web UI clone/install
if [ -d "$WEBUI_DIR" ]; then
  echo "==> Updating Web UI..."
  cd "$WEBUI_DIR"
  git fetch origin || true
  git reset --hard origin/main || true
else
  echo "==> Cloning Web UI from $WEBUI_REPO ..."
  git clone "$WEBUI_REPO" "$WEBUI_DIR" 2>/dev/null || {
    echo "Web UI repo not accessible; skipping separate clone."
    echo "The bundled Web UI from Hermes will be used if available."
  }
fi

# 10. API key setup
ENV_FILE="$HOME/.hermes/.env"
mkdir -p "$HOME/.hermes"
if [ ! -f "$ENV_FILE" ] || ! grep -q "OLLAMA_API_KEY=" "$ENV_FILE" 2>/dev/null; then
  echo ""
  echo "==> Get your Ollama Cloud API key from:"
  echo "     $OLLAMA_KEY_URL"
  echo ""
  echo "==> Paste your Ollama Cloud API key and press Enter:"
  printf "OLLAMA_API_KEY=" > "$ENV_FILE"
  cat >> "$ENV_FILE"
  echo "" >> "$ENV_FILE"
  chmod 600 "$ENV_FILE"
fi

# 11. Validate key with real chat completion
echo "==> Validating Ollama Cloud key with a real chat request..."
source "$ENV_FILE"
RESP=$(curl -sS -m 30 -H "Authorization: Bearer $OLLAMA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"nemotron-3-super","messages":[{"role":"user","content":"hello"}],"stream":false}' \
  https://ollama.com/v1/chat/completions)

if echo "$RESP" | grep -q "chat.completion"; then
  echo "==> Key is valid and can chat."
else
  echo "ERROR: Key cannot chat. Response:"
  echo "$RESP"
  echo ""
  echo "Your key may be read-only. Get a fresh inference key from:"
  echo "  $OLLAMA_KEY_URL"
  exit 1
fi

# 12. Hermes config
CONFIG="$HOME/.hermes/config.yaml"
if [ ! -f "$CONFIG" ]; then
  echo "==> Creating default Hermes config..."
  if [ -f "$SCRIPT_DIR/config/config.yaml.example" ]; then
    cp "$SCRIPT_DIR/config/config.yaml.example" "$CONFIG"
  else
    cat > "$CONFIG" <>EOF
model:
  api_key: \${OLLAMA_API_KEY}
  base_url: https://ollama.com/v1
  context_length: 65536
  default: nemotron-3-super
  max_tokens: 2048
  ollama_num_ctx: 65536
  provider: ollama-cloud
EOF
  fi
fi

# 13. Set Web UI password
if [ -f "$HOME/.hermes/webui/settings.json" ]; then
  echo "==> Enforcing Web UI password..."
  python3 -c "
import json
p = '/data/data/com.termux/files/home/.hermes/webui/settings.json'
try:
    d = json.load(open(p))
except FileNotFoundError:
    d = {}
d['auth_enabled'] = True
d['password_auth_enabled'] = True
json.dump(d, open(p, 'w'), indent=2)
" || true
fi

# 14. Start services
echo "==> Starting Hermes gateway..."
nohup hermes gateway run > "$HOME/.hermes/gateway.log" 2>&1 < /dev/null &

if [ -f "$WEBUI_DIR/server.py" ]; then
  echo "==> Starting Web UI..."
  cd "$WEBUI_DIR"
  nohup "$INSTALL_DIR/venv/bin/python" server.py > "$HOME/.hermes/webui/server.log" 2>&1 < /dev/null &
  cd "$INSTALL_DIR"
fi

# 15. Pin packages
echo "==> Pinning Termux packages..."
apt-mark hold python python-cryptography rust 2>/dev/null || true

# 16. Verification
echo ""
echo "==> Verifying..."
hermes version
hermes gateway status | head -5

echo ""
echo "==> Hermes installed."
echo "Web UI: http://127.0.0.1:8787"
echo "Config: $CONFIG"
echo "Keys:   $ENV_FILE"
echo ""
echo "If the Web UI doesn't load, wait 10 seconds and hard-refresh the browser."
echo "For help: https://github.com/YOUR_GITHUB_USER/hermes-android/blob/main/docs/TROUBLESHOOTING.md"
