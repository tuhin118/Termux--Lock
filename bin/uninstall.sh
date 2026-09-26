#!/data/data/com.termux/files/usr/bin/bash

echo "🗑️  Termux-Lock আনইনস্টল হচ্ছে..."

# .bashrc থেকে হুক সরান
if [ -f "$HOME/.bashrc" ]; then
    sed -i '/termux-lock\/bin\/login.sh/d' "$HOME/.bashrc"
    echo "✅ .bashrc থেকে হুক সরানো হয়েছে"
fi

# ইনস্টল ফাইল মুছুন
if [ -d "$HOME/.termux-lock" ]; then
    rm -rf "$HOME/.termux-lock"
    echo "✅ ~/.termux-lock মুছে ফেলা হয়েছে"
fi

# কমান্ড মুছুন
if [ -f "$PREFIX/bin/termux-lock" ]; then
    rm -f "$PREFIX/bin/termux-lock"
    echo "✅ termux-lock কমান্ড মুছে ফেলা হয়েছে"
fi

echo
echo "✅ আনইনস্টল সম্পন্ন!"
echo "⚠️  Termux বন্ধ করে আবার খুললে লগইন স্ক্রিন আর আসবে না।"
