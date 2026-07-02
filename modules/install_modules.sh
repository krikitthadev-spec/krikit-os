#!/usr/bin/env bash
set -euo pipefail
echo "Installing recommended packages inside this environment..."
# Detect distro style: apk (Alpine) or apt (Debian)
if command -v apk >/dev/null 2>&1; then
  echo "Detected Alpine (apk)"
  apk update
  apk add --no-cache bash tmux neofetch htop vim fzf curl wget git
elif command -v apt-get >/dev/null 2>&1; then
  echo "Detected Debian/Ubuntu (apt)"
  apt-get update
  apt-get install -y bash tmux neofetch htop vim fzf curl wget git
else
  echo "Unknown package manager; please install packages manually: bash tmux neofetch htop vim fzf curl wget git"
fi
echo "Modules installation done."
