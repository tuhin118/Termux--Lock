#!/data/data/com.termux/files/usr/bin/bash

echo "🔄 Password Reset"
read -p "Recovery username: " rec

BYPASS_FILE="$HOME/.termux-lock/bypass.txt"

if [ ! -f "$BYPASS_FILE" ]; then
    echo "❌ No recovery code has been set!"
    exit 1
fi

secret_hash=$(cat "$BYPASS_FILE")
rec_hash=$(echo -n "$rec" | openssl dgst -sha256 | awk '{print $2}')

if [ "$rec_hash" = "$secret_hash" ]; then
    echo "✅ Recovery code verified. Starting new password setup..."
    echo
    bash "$HOME/.termux-lock/bin/setup.sh"
else
    echo "❌ Invalid recovery code!"
    exit 1
fi
