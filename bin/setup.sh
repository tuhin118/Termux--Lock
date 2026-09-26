#!/data/data/com.termux/files/usr/bin/bash

CRED_FILE="$HOME/.termux-lock/creds.txt"
BYPASS_FILE="$HOME/.termux-lock/bypass.txt"
mkdir -p "$HOME/.termux-lock"

echo "=== 🔐 নতুন পাসওয়ার্ড সেটআপ ==="
read -p "ইউজারনেম: " username
read -s -p "পাসওয়ার্ড: " password; echo
read -s -p "আবার পাসওয়ার্ড: " password2; echo

if [ "$password" != "$password2" ]; then
    echo "❌ পাসওয়ার্ড মিলছে না!"
    exit 1
fi

pass_hash=$(echo -n "$password" | openssl dgst -sha256 | awk '{print $2}')
echo "$username" > "$CRED_FILE"
echo "$pass_hash" >> "$CRED_FILE"

echo
echo "=== 🗝️  ইমার্জেন্সি রিকভারি কোড ==="
read -p "গোপন রিকভারি ইউজারনেম: " secret_user
secret_hash=$(echo -n "$secret_user" | openssl dgst -sha256 | awk '{print $2}')
echo "$secret_hash" > "$BYPASS_FILE"

echo "✅ সেটআপ সম্পন্ন!"
