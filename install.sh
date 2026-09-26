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
echo "║   🔐 Termux-Lock ইনস্টলার           ║"
echo "╚══════════════════════════════════════╝"
echo

# ── ডিপেন্ডেন্সি ইনস্টল ──
echo "📦 প্রয়োজনীয় প্যাকেজ ইনস্টল হচ্ছে..."
pkg install openssl openssl-tool figlet -y >/dev/null 2>&1
echo "✅ প্যাকেজ ইনস্টল সম্পন্ন"
echo

# ── ফাইল কপি ──
echo "📁 ফাইল কপি হচ্ছে..."
mkdir -p "$INSTALL_DIR/bin"
cp "$REPO_DIR/bin/"*.sh "$INSTALL_DIR/bin/"
chmod +x "$INSTALL_DIR/bin/"*.sh
echo "✅ ফাইল কপি সম্পন্ন"
echo

# ── কমান্ড রেজিস্টার ──
echo "🔗 'termux-lock' কমান্ড তৈরি হচ্ছে..."
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
        echo "🔐 Termux-Lock — ব্যবহারবিধি"
        echo
        echo "  termux-lock setup      → নতুন পাসওয়ার্ড সেট করুন"
        echo "  termux-lock login      → ম্যানুয়ালি লগইন করুন"
        echo "  termux-lock reset      → রিকভারি কোড দিয়ে পাসওয়ার্ড রিসেট"
        echo "  termux-lock uninstall  → সম্পূর্ণ আনইনস্টল"
        echo
        ;;
esac
EOF
chmod +x "$BIN_DIR/termux-lock"
echo "✅ কমান্ড তৈরি সম্পন্ন"
echo

# ── .bashrc হুক ──
echo "🪝 .bashrc-এ লগইন হুক যোগ হচ্ছে..."

HOOK='[ -f "$HOME/.termux-lock/bin/login.sh" ] && bash "$HOME/.termux-lock/bin/login.sh"'

# .bashrc না থাকলে তৈরি
touch "$HOME/.bashrc"

# আগে থেকে হুক থাকলে ডুপ্লিকেট হবে না
if ! grep -qF "termux-lock/bin/login.sh" "$HOME/.bashrc"; then
    # হুক সবার উপরে যোগ করা (login screen আগে দেখাবে)
    printf '%s\n\n' "$HOOK" | cat - "$HOME/.bashrc" > "$HOME/.bashrc.tmp"
    mv "$HOME/.bashrc.tmp" "$HOME/.bashrc"
    echo "✅ হুক যোগ সম্পন্ন"
else
    echo "ℹ️  হুক আগে থেকেই আছে, স্কিপ করা হলো"
fi
echo

# ── সেটআপ চালানো ──
echo "╔══════════════════════════════════════╗"
echo "║   ✅ ইনস্টল সফলভাবে সম্পন্ন!        ║"
echo "╚══════════════════════════════════════╝"
echo
echo "🚀 এখন পাসওয়ার্ড সেট করতে চালান:"
echo "   termux-lock setup"
echo
echo "⚠️  সেটআপ শেষে Termux বন্ধ করে আবার খুলুন।"
echo

# ── ইন্টারঅ্যাক্টিভ সেটআপ ──
read -p "এখনই পাসওয়ার্ড সেট করতে চান? (y/n): " choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    echo
    bash "$INSTALL_DIR/bin/setup.sh"
fi
