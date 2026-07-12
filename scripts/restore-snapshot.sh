#!/data/data/com.termux/files/usr/bin/bash
set -e

# Restore Tabby's Hermes working state from a saved snapshot.
# Usage: bash restore-snapshot.sh /path/to/snapshot.json

if [ -z "$1" ]; then
  echo "Usage: $0 \u003csnapshot.json\u003e"
  echo "Available snapshots:"
  ls -1 /data/data/com.termux/files/home/hermes-android/snapshots/ 2>/dev/null || echo "  none found"
  exit 1
fi

SNAP="$1"
if [ ! -f "$SNAP" ]; then
  echo "ERROR: snapshot not found: $SNAP"
  exit 1
fi

echo "==> Restoring Hermes state from $SNAP"

# 1. Stop services
termux-wake-lock 2>/dev/null || true
pkill -f "hermes gateway run" || true
sleep 2
pkill -f "server.py" || true
sleep 2

# 2. Extract files from snapshot
python3 - "$SNAP" <<'PYEOF'
import json, sys, pathlib
snap = json.load(open(sys.argv[1]))
for path, content in snap.get("files", {}).items():
    if content == "__MISSING__":
        continue
    pathlib.Path(path).parent.mkdir(parents=True, exist_ok=True)
    pathlib.Path(path).write_text(content)
    print(f"restored {path}")
PYEOF

# 3. Restore wrapper
PREFIX=/data/data/com.termux/files/usr
PY_MAJ=$(python -c "import sys; print(sys.version_info.major)")
PY_MIN=$(python -c "import sys; print(sys.version_info.minor)")
LD_PATH="$PREFIX/lib/libpython${PY_MAJ}.${PY_MIN}.so"

printf '%s\n' \
  "#!/data/data/com.termux/files/usr/bin/bash" \
  "export LD_PRELOAD=$LD_PATH" \
  "source /data/data/com.termux/files/home/.hermes/.env 2>/dev/null || true" \
  'exec /data/data/com.termux/files/home/.hermes/hermes-agent/venv/bin/hermes "$@"' \
  > "$PREFIX/bin/hermes"
chmod 755 "$PREFIX/bin/hermes"

# 4. Hold packages
echo "==> Pinning packages..."
apt-mark hold python python-cryptography rust 2>/dev/null || true

# 5. Restart services
echo "==> Restarting services..."
nohup hermes gateway run > /data/data/com.termux/files/home/.hermes/gateway.log 2>&1 < /dev/null &
sleep 5
cd /data/data/com.termux/files/home/hermes-webui
nohup /data/data/com.termux/files/home/.hermes/hermes-agent/venv/bin/python server.py > /data/data/com.termux/files/home/.hermes/webui/server-restart.log 2>&1 < /dev/null &
cd /data/data/com.termux/files/home
sleep 5

echo "==> Verifying..."
hermes version
hermes gateway status | head -5

if python -c "import socket; s=socket.socket(); s.settimeout(3); s.connect(('127.0.0.1',8787)); s.close()" 2>/dev/null; then
  echo "Web UI is up on http://127.0.0.1:8787"
else
  echo "WARNING: Web UI not responding. Check ~/.hermes/webui/server-restart.log"
fi

echo ""
echo "Restore complete. Send a test message in the Web UI to confirm."
