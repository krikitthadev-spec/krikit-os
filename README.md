# Krikit OS (Termux edition)

Krikit OS is a minimal, terminal-first "OS" that runs inside Termux on Android. It provides:
- A small, versioned repo containing dotfiles, modules and a launcher
- Optional proot-distro integration (Alpine/Debian) for a fuller userland
- An interactive launcher (`krikit`) and menu-driven shell (`krikit-shell`)

Quick install (short)
1. In Termux:
   pkg update -y && pkg install -y git curl proot-distro fzf tmux bash
2. Clone this repo:
   git clone https://github.com/krikitthadev-spec/krikit-os.git $HOME/krikit-os
3. Run installer from repo:
   bash $HOME/krikit-os/install.sh
4. Start Krikit:
   source ~/.profile
   krikit

Detailed install & notes are below.

Why use proot-distro?
- Gives a clean Debian/Alpine userland without root.
- Easier to install standard Linux packages inside the sandbox.
- Use `KR_DIR` and `DISTRO` env vars to customize behavior.

Files
- install.sh — bootstrap installer for Termux + proot-distro
- krikit-shell — interactive menu
- modules/install_modules.sh — installs recommended packages inside the distro
- dotfiles/ — prompt and tmux config

Contributing
- PRs welcome. Add modules in modules/, update dotfiles, or submit feature requests.

License
- MIT
