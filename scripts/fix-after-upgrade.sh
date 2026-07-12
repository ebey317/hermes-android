#!/data/data/com.termux/files/usr/bin/bash
set -e

# Recover Hermes after a Termux Python upgrade breaks the venv.
# Run this if you see errors like:
#   - No module named 'openai'
#   - HTTP 401/404/500 on every chat
#   - hermes gateway status fails
#   - Web UI keeps giving error banners

PREFIX="/data/data/com.termux/files/usr"
ENV="$HOME/.hermes/.env"

echo "==> Hermes post-upgrade recovery"

termux-wake-lock 2>/dev/null || true

# 1. Stop old services
pkill -f "hermes gateway run" || true
sleep 2
pkill -f "hermes-webui/server.py" || true
sleep 2

# 2. Detect current Python version
PY_MAJ=$(python -c "import sys; print(sys.version_info.major)")
PY_MIN=$(python -c "import sys; print(sys.version_info.minor)")
LD_PATH="$PREFIX/lib/libpython${PY_MAJ}.${PY_MIN}.so"

echo "Detected Python ${PY_MAJ}.${PY_MIN}"
echo "LD_PRELOAD target: $LD_PATH"

# 3. Ensure .env has LD_PRELOAD
if [ -f "$ENV" ]; then
  TMP=$(grep -v "^LD_PRELOAD=" "$ENV" 2>/dev/null || true)
  printf '%s\n' "$TMP" > "$ENV"
fi
echo "LD_PRELOAD=$LD_PATH" >> "$ENV"
echo "export LD_PRELOAD=$LD_PATH" >> "$ENV"
chmod 600 "$ENV"

# 4. Fix hermes wrapper
printf '%s\n' \
  "#!/data/data/com.termux/files/usr/bin/bash" \
  "export LD_PRELOAD=$LD_PATH" \
  "source /data/data/com.termux/files/home/.hermes/.env 2>/dev/null || true" \
  'exec /data/data/com.termux/files/home/.hermes/hermes-agent/venv/bin/hermes "$@"' \
  > "$PREFIX/bin/hermes"
chmod 755 "$PREFIX/bin/hermes"
echo "Fixed $PREFIX/bin/hermes"

# 5. Fix systemd user service if it exists
SVC="$PREFIX/lib/systemd/user/hermes-gateway.service"
if [ -f "$SVC" ] && ! grep -q "LD_PRELOAD=" "$SVC"; then
  sed -i "s|\[Service\]|[Service]\\nEnvironment=LD_PRELOAD=$LD_PATH|" "$SVC"
  echo "Patched $SVC"
fi

# 6. Pin packages so it doesn't break again
apt-mark hold python python-cryptography rust 2>/dev/null || true
echo "Pinned packages: $(apt-mark showhold | tr '\n' ' ')"

# 7. Restart gateway
export LD_PRELOAD="$LD_PATH"
source "$ENV" 2>/dev/null || true
echo "==> Starting gateway..."
nohup hermes gateway run > "$HOME/.hermes/gateway.log" 2>&1 < /dev/null &
sleep 5
hermes gateway status | head -5

# 8. Restart Web UI
if [ -f "$HOME/hermes-webui/server.py" ]; then
  echo "==> Starting Web UI..."
  cd "$HOME/hermes-webui"
  nohup "$HOME/.hermes/hermes-agent/venv/bin/python" server.py > "$HOME/.hermes/webui/server-restart.log" 2>&1 < /dev/null &
cd "$HOME"
fi

# 9. Verify model/provider
if [ -f "$HOME/.hermes/config.yaml" ]; then
  echo "==> Current model/provider:"
  python3 -c "
import yaml, pathlib
try:
    c = yaml.safe_load(pathlib.Path('/data/data/com.termux/files/home/.hermes/config.yaml').read_text())
    print('provider:', c.get('model',{}).get('provider'))
    print('base_url:', c.get('model',{}).get('base_url'))
    print('default:', c.get('model',{}).get('default'))
except Exception as e:
    print('config read error:', e)
" 2>/dev/null || grep -nE "provider:|base_url:|default:" "$HOME/.hermes/config.yaml" | head -6
fi

echo ""
echo "Recovery complete. Open http://127.0.0.1:8787 and send a test message."
