#!/data/data/com.termux/files/usr/bin/bash
set -e

# Start or restart the Hermes gateway.

LOG="$HOME/.hermes/gateway.log"

echo "==> Starting Hermes gateway"

termux-wake-lock 2>/dev/null || true
pkill -f "hermes gateway run" || true
sleep 2

nohup hermes gateway run > "$LOG" 2>&1 < /dev/null &

sleep 5
hermes gateway status | head -10
