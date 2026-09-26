#!/data/data/com.termux/files/usr/bin/bash

CRED_FILE="$HOME/.termux-lock/creds.txt"
BYPASS_FILE="$HOME/.termux-lock/bypass.txt"

[ ! -f "$CRED_FILE" ] && exec bash --login

trap '' SIGINT SIGTSTP

clear
figlet -f small "Termux Lock" 2>/dev/null || echo "=== TERMUX LOCK ==="
echo

read -p "ইউজারনেম: " input_user

if [ -f "$BYPASS_FILE" ]; then
    secret_hash=$(cat "$BYPASS_FILE")
    input_hash=$(echo -n "$input_user" | openssl dgst -sha256 | awk '{print $2}')
    if [ "$input_hash" = "$secret_hash" ]; then
        echo "🔓 রিকভারি কোড সঠিক!"
        sleep 1
        exec bash --login
    fi
fi

read -s -p "পাসওয়ার্ড: " input_pass; echo

saved_user=$(sed -n '1p' "$CRED_FILE")
saved_hash=$(sed -n '2p' "$CRED_FILE")
input_hash=$(echo -n "$input_pass" | openssl dgst -sha256 | awk '{print $2}')

if [ "$input_user" = "$saved_user" ] && [ "$input_hash" = "$saved_hash" ]; then
    echo "✅ লগইন সফল!"
    sleep 1
    exec bash --login
else
    echo "❌ ভুল ইউজারনেম বা পাসওয়ার্ড!"
    sleep 2
    exit 1
fi
