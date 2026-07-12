#!/data/data/com.termux/files/usr/bin/bash
set -e

# Bootstrap Termux for Hermes Agent installation
# Run this first if you are doing a manual install.
# The main install.sh runs these steps automatically.

echo "==> Hermes Android bootstrap"

# 1. Architecture check
ARCH=$(dpkg --print-architecture)
if [ "$ARCH" != "aarch64" ]; then
  echo "ERROR: This installer is only tested on aarch64. Your architecture: $ARCH"
  exit 1
fi

# 2. Android version check
API=$(getprop ro.build.version.sdk)
if [ "$API" -lt 31 ]; then
  echo "ERROR: Android 12 (API 31) or newer is required. Your API level: $API"
  exit 1
fi

# 3. Keep Termux awake
termux-wake-lock 2>/dev/null || true

# 4. Update packages
echo "==> Updating Termux packages..."
pkg update -y
pkg upgrade -y

# 5. Core packages
echo "==> Installing core packages..."
pkg install -y \
  git \
  python \
  clang \
  make \
  pkg-config \
  libffi \
  openssl \
  ca-certificates \
  curl \
  openssh \
  nodejs \
  ripgrep \
  ffmpeg \
  tmux

# 6. Rust toolchain (required for pydantic-core / jiter source builds)
echo "==> Installing Rust..."
pkg install -y rust

# 7. Termux prebuilt cryptography (saves 20+ minutes)
echo "==> Installing Termux cryptography..."
pkg install -y python-cryptography

# 8. Wake lock helper
echo "==> Installing termux-wake-lock..."
pkg install -y termux-wake-lock 2>/dev/null || true

# 9. Storage permission helper
if [ ! -d "$HOME/storage" ]; then
  echo "==> Run 'termux-setup-storage' if you want to access shared storage."
fi

# 10. SSH setup
if [ ! -f "$HOME/.ssh/authorized_keys" ]; then
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
  touch "$HOME/.ssh/authorized_keys"
  chmod 600 "$HOME/.ssh/authorized_keys"
  echo "==> Created ~/.ssh/authorized_keys. Paste your public key if you want passwordless SSH."
fi

# 11. Print summary
echo ""
echo "Bootstrap complete."
echo "Architecture: $ARCH"
echo "Android API: $API"
echo "Python version: $(python --version)"
echo "Username: $(whoami)"
echo ""
echo "Next: run install.sh"
