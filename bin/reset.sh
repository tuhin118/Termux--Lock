#!/data/data/com.termux/files/usr/bin/bash

echo "🔄 পাসওয়ার্ড রিসেট"
read -p "রিকভারি ইউজারনেম: " rec
BYPASS_FILE="$HOME/.termux-lock/bypass.txt"

if [ ! -f "$BYPASS_FILE" ]; then
    echo "❌ রিকভারি কোড সেট করা নেই!"
    exit 1
fi

secret_hash=$(cat "$BYPASS_FILE")
rec_hash=$(echo -n "$rec" | openssl dgst -sha256 | awk '{print $2}')

if [ "$rec_hash" = "$secret_hash" ]; then
    bash "$HOME/.termux-lock/bin/setup.sh"
else
    echo "❌ ভুল রিকভারি কোড!"
fi
