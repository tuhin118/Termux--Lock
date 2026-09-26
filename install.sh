#!/data/data/com.termux/files/usr/bin/bash

# ═══════════════════════════════════════════════════════
#  Termux-Lock Installer
#  GitHub: https://github.com/tuhin118/Termux--Lock
# ═══════════════════════════════════════════════════════

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="$HOME/.termux-lock"
BIN_DIR="$PREFIX/bin"

echo "╔══════════════════════════════════════╗"
echo "║   🔐 Termux-Lock Installer          ║"
echo "╚══════════════════════════════════════╝"
echo

# ── Install dependencies ──
echo "📦 Installing required packages..."
pkg install openssl openssl-tool figlet -y >/dev/null 2>&1
echo "✅ Packages installed"
echo

# ── Copy files ──
echo "📁 Copying files..."
mkdir -p "$INSTALL_DIR/bin"
cp "$REPO_DIR/bin/"*.sh "$INSTALL_DIR/bin/"
chmod +x "$INSTALL_DIR/bin/"*.sh
echo "✅ Files copied"
echo

# ── Register command ──
echo "🔗 Creating 'termux-lock' command..."
cat > "$BIN_DIR/termux-lock" <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash

INSTALL_DIR="$HOME/.termux-lock"

case "$1" in
    setup)
        bash "$INSTALL_DIR/bin/setup.sh"
        ;;
    login)
        bash "$INSTALL_DIR/bin/login.sh"
        ;;
    reset)
        bash "$INSTALL_DIR/bin/reset.sh"
        ;;
    uninstall)
        bash "$INSTALL_DIR/bin/uninstall.sh"
        ;;
    *)
        echo "🔐 Termux-Lock — Usage"
        echo
        echo "  termux-lock setup      → Set a new password"
        echo "  termux-lock login      → Manually trigger login"
        echo "  termux-lock reset      → Reset password via recovery code"
        echo "  termux-lock uninstall  → Fully uninstall Termux-Lock"
        echo
        ;;
esac
EOF
chmod +x "$BIN_DIR/termux-lock"
echo "✅ Command created"
echo

# ── Add hook to .bashrc ──
echo "🪝 Adding login hook to .bashrc..."

HOOK='[ -f "$HOME/.termux-lock/bin/login.sh" ] && bash "$HOME/.termux-lock/bin/login.sh"'

touch "$HOME/.bashrc"

if ! grep -qF "termux-lock/bin/login.sh" "$HOME/.bashrc"; then
    printf '%s\n\n' "$HOOK" | cat - "$HOME/.bashrc" > "$HOME/.bashrc.tmp"
    mv "$HOME/.bashrc.tmp" "$HOME/.bashrc"
    echo "✅ Hook added"
else
    echo "ℹ️  Hook already exists, skipping"
fi
echo

# ── Done ──
echo "╔══════════════════════════════════════╗"
echo "║   ✅ Installation completed!        ║"
echo "╚══════════════════════════════════════╝"
echo
echo "🚀 Run the following to set your password:"
echo "   termux-lock setup"
echo
echo "⚠️  Restart Termux after setup."
echo

# ── Interactive setup ──
read -p "Run password setup now? (y/n): " choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    echo
    bash "$INSTALL_DIR/bin/setup.sh"
fi
