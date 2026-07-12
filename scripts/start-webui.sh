#!/data/data/com.termux/files/usr/bin/bash
set -e

# Start or restart the Hermes Web UI.

INSTALL_DIR="$HOME/.hermes/hermes-agent"
WEBUI_DIR="$HOME/hermes-webui"
LOG="$HOME/.hermes/webui/server.log"

echo "==> Starting Hermes Web UI"

termux-wake-lock 2>/dev/null || true
pkill -f "hermes-webui/server.py" || true
sleep 2

if [ ! -f "$WEBUI_DIR/server.py" ]; then
  echo "ERROR: Web UI not found at $WEBUI_DIR/server.py"
  exit 1
fi

mkdir -p "$HOME/.hermes/webui"
cd "$WEBUI_DIR"
nohup "$INSTALL_DIR/venv/bin/python" server.py > "$LOG" 2>&1 < /dev/null &
cd "$HOME"

sleep 3
if python -c "import socket; s=socket.socket(); s.settimeout(3); s.connect(('127.0.0.1',8787)); s.close()" 2>/dev/null; then
  echo "Web UI is running on http://127.0.0.1:8787"
else
  echo "WARNING: Web UI did not respond on port 8787. Check $LOG"
  tail -20 "$LOG"
fi
