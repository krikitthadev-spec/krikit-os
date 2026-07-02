#!/usr/bin/env bash
set -euo pipefail
# Krikit OS installer for Termux
# Usage: curl -sL https://raw.githubusercontent.com/krikitthadev-spec/krikit-os/main/install.sh | bash

KR_DIR="${KR_DIR:-$HOME/krikit-os}"
DISTRO="${DISTRO:-alpine}"   # default inside proot-distro; set to debian for Debian
USE_PROOT="${USE_PROOT:-auto}" # auto, yes, no

echo "Krikit OS installer"
echo "Target dir: $KR_DIR"

# Detect Termux
if command -v pkg >/dev/null 2>&1; then
  PKG_CMD="pkg"
elif command -v apt >/dev/null 2>&1; then
  PKG_CMD="apt"
else
  echo "Warning: not detecting Termux package manager; continuing but you may need to install dependencies manually."
  PKG_CMD=""
fi

# Basic dependencies to install in Termux host
if [ -n "${PKG_CMD}" ]; then
  echo "Updating packages..."
  $PKG_CMD update -y || true
  $PKG_CMD upgrade -y || true
  echo "Installing dependencies (git, curl, proot-distro, fzf, tmux, bash)..."
  $PKG_CMD install -y git curl proot-distro fzf tmux bash coreutils
fi

# Clone repo
if [ -d "$KR_DIR" ]; then
  echo "Krikit repo already exists at $KR_DIR — pulling updates"
  git -C "$KR_DIR" pull || true
else
  echo "Cloning krikit-os repository into $KR_DIR..."
  git clone https://github.com/krikitthadev-spec/krikit-os.git "$KR_DIR" || {
    echo "Local copy: copying install files to $KR_DIR"
    mkdir -p "$KR_DIR"
    cp -r ./* "$KR_DIR"/ || true
  }
fi

# Install or ensure proot-distro present
if command -v proot-distro >/dev/null 2>&1; then
  echo "proot-distro found"
  if [ "$USE_PROOT" = "auto" ]; then
    USE_PROOT=yes
  fi
else
  echo "proot-distro not found"
  if [ "$USE_PROOT" = "auto" ]; then
    USE_PROOT=no
  fi
fi

# Install selected distro if using proot
if [ "$USE_PROOT" = "yes" ]; then
  if ! proot-distro list | grep -q "^$DISTRO"; then
    echo "Installing $DISTRO inside proot-distro (may take several minutes)..."
    proot-distro install "$DISTRO"
  else
    echo "$DISTRO already installed"
  fi
fi

# Create $HOME/bin and launcher script
mkdir -p "$HOME/bin"
cat > "$HOME/bin/krikit" <<'EOF'
#!/usr/bin/env bash
KR_DIR="$HOME/krikit-os"
DISTRO="${DISTRO:-alpine}"
if command -v proot-distro >/dev/null 2>&1 && proot-distro list | grep -q "^$DISTRO"; then
  proot-distro login "$DISTRO" --shared-tmp --bind "$KR_DIR":/root/krikit -- /bin/bash -lc "cd /root/krikit && ./krikit-shell"
else
  # Fallback: run shell inside Termux environment using the repo files
  cd "$KR_DIR" || exit 1
  ./krikit-shell
fi
EOF
chmod +x "$HOME/bin/krikit"

# Add $HOME/bin to PATH in .profile
if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$HOME/.profile" 2>/dev/null; then
  echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.profile"
  echo "Added $HOME/bin to PATH in .profile"
fi

echo "Install complete. Start Krikit with: source ~/.profile && krikit"
