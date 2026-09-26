#!/data/data/com.termux/files/usr/bin/bash

echo "🗑️  Termux-Lock আনইনস্টল হচ্ছে..."

# .bashrc থেকে হুক সরান
sed -i '/.termux-lock\/bin\/login.sh/d' "$HOME/.bashrc" 2>/dev/null || true

# ফাইল মুছুন
rm -rf "$HOME/.termux-lock"
rm -f "$PREFIX/bin/termux-lock"

echo "✅ আনইনস্টল সম্পন্ন!"
